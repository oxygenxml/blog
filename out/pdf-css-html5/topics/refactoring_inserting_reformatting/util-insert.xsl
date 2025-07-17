<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  exclude-result-prefixes="#all"
  version="3.0">

  <!-- define some content models -->
  <xsl:variable name="content-models" as="map(xs:string, xs:string*)" select="map {
    'glossgroup': ('title', 'prolog', 'glossgroup', 'glossentry'),
    'keywords': ('indexterm', 'keyword'),
    'metadata': ('audience', 'category', 'keywords', 'prodinfo', 'othermeta', 'data', 'sort-as', 'data-about', 'foreign', 'mathml', 'svg-container', 'unknown'),
    'prolog': ('author', 'source', 'publisher', 'copyright', 'critdates', 'permissions', 'metadata', 'change-historylist', 'resourceid', 'data', 'sort-as', 'data-about', 'foreign', 'mathml', 'svg-container', 'unknown'),
    'topic': ('title', 'titlealts', 'shortdesc', 'abstract', 'prolog', 'body', 'related-links', 'topic')
  }"/>

  <!-- perform content-aware insertion on an element -->
  <xsl:template match="*" mode="insert-stuff">
    <xsl:param name="path" as="xs:string*"/>  <!-- can be path string ('a/b/c') or list of element names ('a', 'b', 'c') -->
    <xsl:param name="content" as="element()*" tunnel="yes"/>
    <xsl:param name="indent" as="xs:string" tunnel="yes" select="'self'"/>  <!-- indent method for newly created intermediate levels -->

    <!-- tokenize untokenized path components as needed -->
    <xsl:variable name="path-sequence" as="xs:string*" select="$path ! tokenize(., '/')"/>

    <!-- if path levels remain to recurse, get the next path level -->
    <xsl:variable name="path-element-name" select="head($path-sequence)" as="xs:string?"/>
    <xsl:variable name="path-element-original" select="*[name() eq $path-element-name]" as="element()?"/>

    <!-- choose what to insert in this current element (the "parent") -->
    <xsl:variable name="parent-name" select="name()" as="xs:string"/>
    <xsl:variable name="insert-in-parent" as="node()*">
      <xsl:choose>
        <xsl:when test="$path-element-name">
          <!-- we are still recursing the path - create or modify the next path element -->
          <xsl:variable name="path-element-to-process" as="element()">
            <xsl:choose>
              <xsl:when test="$path-element-original">
                <!-- the path element exists at this level; use it -->
                <xsl:sequence select="$path-element-original"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- the path element does not exist at this level; create it -->
                <xsl:element name="{$path-element-name}">
                  <xsl:if test="$indent">
                    <xsl:attribute name="indent" select="$indent"/>
                  </xsl:if>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!-- recursively process this path element, then insert it into its parent below -->
          <xsl:apply-templates select="$path-element-to-process" mode="#current">
            <xsl:with-param name="path" select="tail($path-sequence)" as="xs:string*"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <!-- we've reached the end of the path - insert the content at this level -->
          <xsl:sequence select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- get the content model we must respect in this current element (the "parent") -->
    <xsl:if test="empty($content-models($parent-name))">
      <xsl:message terminate="yes" expand-text="yes">No content model found for '{$parent-name}'.</xsl:message>
    </xsl:if>
    <xsl:variable name="content-model" select="$content-models($parent-name)" as="xs:string+"/>

    <!--iteratively insert one element at a time into the parent -->
    <xsl:iterate select="$insert-in-parent">
      <xsl:param name="current-parent" select="." as="element()"/>
      <xsl:on-completion select="$current-parent"/>
      <xsl:variable name="this-element-to-insert" select="." as="element()"/>

      <!-- compute an updated parent element with this content element inserted -->
      <xsl:variable name="new-parent" as="element()">
        <!-- get all content up to (and including) the current insertion element type, per the content model -->
        <xsl:variable name="this-element-name" select="name($this-element-to-insert)" as="xs:string"/>
        <xsl:if test="empty(index-of($content-model, $this-element-name))">
          <xsl:message terminate="yes" expand-text="yes">'{$this-element-name}' not found in content model for '{$parent-name}'.</xsl:message>
        </xsl:if>
        <xsl:variable name="preceding-elements" select="$current-parent/*[name() = $content-model[position() &lt;= index-of($content-model, $this-element-name)]]" as="element()*"/>
        <xsl:variable name="preceding-nodes" select="$preceding-elements/(.|preceding-sibling::node())" as="node()*"/>
        <!-- create the updated parent element -->
        <xsl:copy select="$current-parent">
          <!-- include the preceding content (if we updated an existing path element, don't include the original) -->
          <xsl:sequence select="@*, $preceding-nodes except $path-element-original"/>
          <!-- insert this element -->
          <xsl:sequence select="$this-element-to-insert"/>
          <!-- include the following content -->
          <xsl:sequence select="node() except ($preceding-nodes)"/>
        </xsl:copy>
      </xsl:variable>
      <xsl:next-iteration>
        <xsl:with-param name="current-parent" select="$new-parent"/>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:template>

</xsl:stylesheet>

