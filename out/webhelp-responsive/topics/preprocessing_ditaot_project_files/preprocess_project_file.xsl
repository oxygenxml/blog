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


  <!-- this is a DITA-OT project file preprocessor to support the following:

       * #3682: In DITA-OT project files, allow a PDF <deliverable> to specify its output file name (https://github.com/dita-ot/dita-ot/issues/3682)
       * #3690: In DITA-OT project files, apply both <context> and <publication> DITAVAL filtering (https://github.com/dita-ot/dita-ot/issues/3690)

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
    <xsl:apply-templates select="document(@href, /)/*/*" mode="#current"/>
  </xsl:template>


  <!-- PASS 2 -->
  <xsl:mode name="pass2" on-no-match="shallow-copy"/>

  <!-- remove duplicate elements from <include> -->
  <xsl:template match="/project/*[preceding-sibling::*[deep-equal(., current())]]" mode="pass2"/>


  <!-- PASS 3 -->
  <xsl:mode name="pass3" on-no-match="shallow-copy"/>

  <!-- PASS 3 - pull @idref'ed <context> or <publication> elements inline -->
  <xsl:template match="(context|publication)[@idref]" mode="pass3">
    <xsl:variable name="element" as="element()">
      <xsl:copy-of select="//*[@id = current()/@idref]"/>
    </xsl:variable>

    <xsl:variable name="params" as="element()*">
      <xsl:copy-of select="param[parent::publication]"/>
    </xsl:variable>

    <xsl:copy select="$element">
      <xsl:apply-templates select="$element/((@* except @id)|node())" mode="#current"/>  <!-- omit @id -->
      <xsl:sequence select="$params"/>  <!-- include <param> overrides in <publication> references -->
    </xsl:copy>
  </xsl:template>

  <!-- PASS 3 - remove the original <context> or <publication> definitions we no longer need -->
  <xsl:template match="(context|publication)[@id]" mode="pass3"/>


  <!-- PASS 4 -->
  <xsl:mode name="pass4" on-no-match="shallow-copy"/>

  <!-- PASS 4 - add <deliverable>-specific <param> settings to <publication> -->
  <xsl:template match="publication" mode="pass4">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
      <xsl:sequence select="../param"/>
    </xsl:copy>
  </xsl:template>

  <!-- PASS 4 - move <publication>-specific <profile> settings to <context> -->
  <xsl:template match="context" mode="pass4">
    <xsl:variable name="ditavals" as="element(ditaval)*">
      <xsl:sequence select="profile/ditaval"/>
      <xsl:sequence select="../publication/profile/ditaval"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|(node() except profile)" mode="#current"/>
      <xsl:if test="exists($ditavals)">
        <profile>
          <xsl:sequence select="$ditavals"/>
        </profile>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- PASS 4 - delete moved elements from their original locations -->
  <xsl:template match="deliverable/param" mode="pass4"/>
  <xsl:template match="publication/profile" mode="pass4"/>

</xsl:stylesheet>

