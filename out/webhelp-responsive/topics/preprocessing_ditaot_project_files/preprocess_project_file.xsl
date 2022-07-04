<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:mine="http://mine"
  xmlns="https://www.dita-ot.org/project"
  xpath-default-namespace="https://www.dita-ot.org/project"
  exclude-result-prefixes="#all"
  version="3.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="file.separator" as="xs:string" select="':'"/>

  <!-- this is a DITA-OT project file preprocessor to support the following:

       * #3682: In DITA-OT project files, allow a PDF <deliverable> to specify its output file name (https://github.com/dita-ot/dita-ot/issues/3682)
       * #3690: In DITA-OT project files, apply both <context> and <publication> DITAVAL filtering (https://github.com/dita-ot/dita-ot/issues/3690)
       * #3873: args.filter does not support multiple relative paths in DITA-OT project file (https://github.com/dita-ot/dita-ot/issues/3873)

       current limitations:

       * <include> is not supported
  -->



  <!-- TOP-LEVEL PASS -->
  <xsl:mode on-no-match="shallow-copy"/>

  <!-- TOP-LEVEL PASS - apply passes 1 through 4 to document -->
  <xsl:template match="/">
    <xsl:variable name="pass1-results" as="document-node()">
      <xsl:apply-templates select="/" mode="pass1"/>
    </xsl:variable>

    <xsl:variable name="pass2-results" as="document-node()">
      <xsl:apply-templates select="$pass1-results" mode="pass2"/>
    </xsl:variable>

    <xsl:variable name="pass3-results" as="document-node()">
      <xsl:apply-templates select="$pass2-results" mode="pass3"/>
    </xsl:variable>

    <xsl:variable name="pass4-results" as="document-node()">
      <xsl:apply-templates select="$pass3-results" mode="pass4"/>
    </xsl:variable>

    <xsl:sequence select="$pass4-results"/>
  </xsl:template>


  <!-- PASS 1 -->
  <xsl:mode name="pass1" on-no-match="shallow-copy"/>

  <!-- PASS 1 - resolve <include> references -->
  <xsl:template match="include[@href]" mode="pass1">
    <xsl:apply-templates select="document(@href, /)/*/*" mode="pass1"/>
  </xsl:template>

  <!-- PASS 1 - convert <ditaval> and <param name="args.filter"> to use absolute path -->
  <!--  <xsl:template match="(ditaval|param[@name = 'args.filter'])/(@path|@value|@href)">-->  <!-- attribute list requires Saxon 10 -->
  <xsl:template match="(ditaval|param[@name = 'args.filter'])/@*[name() = ('path', 'value', 'href')]" mode="pass1">
    <xsl:attribute name="{name()}">
      <xsl:value-of select="resolve-uri(., base-uri(.))"/>
    </xsl:attribute>
  </xsl:template>


  <!-- PASS 2 -->
  <xsl:mode name="pass2" on-no-match="shallow-copy"/>

  <!-- remove duplicate elements from <include> -->
  <xsl:template match="/project/*[preceding-sibling::*[deep-equal(., current())]]" mode="pass2"/>


  <!-- PASS 3 -->
  <xsl:mode name="pass3" on-no-match="shallow-copy"/>

  <!-- PASS 3 - convert <profile> to <param name="args.filter"> -->
  <xsl:template match="profile[ditaval[@path|@value|@href]]" mode="pass3">
    <xsl:for-each select="ditaval">
      <param name="args.filter" xmlns="https://www.dita-ot.org/project">
        <xsl:apply-templates select="./(@path|@value|@href)"/>
      </param>
    </xsl:for-each>
  </xsl:template>

  <!-- PASS 3 - pull @idref'ed <context> or <publication> elements inline -->
  <xsl:template match="(context|publication)[@idref]" mode="pass3">
    <xsl:variable name="element" as="element()">
      <xsl:copy-of select="//*[@id = current()/@idref]"/>
    </xsl:variable>

    <xsl:variable name="params" as="element()*">
      <xsl:copy-of select="param[parent::publication]"/>
    </xsl:variable>

    <xsl:copy select="$element">
      <xsl:apply-templates select="$element/((@* except @id)|node())" mode="pass3"/>  <!-- omit @id -->
      <xsl:sequence select="$params"/>  <!-- include <param> overrides in <publication> references -->
    </xsl:copy>
  </xsl:template>

  <!-- PASS 3 - remove the original <context> or <publication> definitions we no longer need -->
  <xsl:template match="(context|publication)[@id]" mode="pass3"/>


  <!-- PASS 4 -->
  <xsl:mode name="pass4" on-no-match="shallow-copy"/>

  <xsl:template match="publication" mode="pass4">
    <xsl:copy>
      <!-- copy everything except original DITAVAL references -->
      <xsl:apply-templates select="@*|(node() except param[@name = 'args.filter'])" mode="pass4"/>

      <!-- add new merged DITAVAL reference -->
      <xsl:sequence select="mine:merge-ditaval(..//param[@name = 'args.filter'][@href|@path|@value])"/>

      <!-- add any <deliverable>-specific <param> settings -->
      <xsl:sequence select="../param"/>
    </xsl:copy>
  </xsl:template>

  <!-- given a set of <param> elements, return a single <param> using a colon-separated reference list -->
  <xsl:function name="mine:merge-ditaval" as="element()*">
    <xsl:param name="ditavals" as="element()*"/>
    <xsl:if test="count($ditavals/(@href|@path|@value)) > 0">
      <param name="args.filter" xmlns="https://www.dita-ot.org/project">
        <xsl:attribute name="value">  <!-- file lists must use @value, not @href or @path -->
          <xsl:choose>
            <xsl:when test="$file.separator eq ':'">  <!-- in Linux, 'file:' cannot be used in DITAVAL file list -->
              <xsl:value-of select="string-join($ditavals/replace((@href|@path|@value), 'file:', ''), $file.separator)"/>
            </xsl:when>
            <xsl:when test="$file.separator eq ';'">  <!-- in Windows, 'file:' must be used in DITAVAL file list -->
              <xsl:value-of select="string-join($ditavals/(@href|@path|@value), $file.separator)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </param>
    </xsl:if>
  </xsl:function>

  <!-- delete "moved" elements in their old locations -->
  <xsl:template match="deliverable/context/param" mode="pass4"/>
  <xsl:template match="deliverable/param" mode="pass4"/>

</xsl:stylesheet>

