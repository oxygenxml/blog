<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ditaaccess="java:ro.sync.ecss.dita.extensions.DITAXSLTExtensionFunctionUtil"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://dita.oasis-open.org/architecture/2005/"
  exclude-result-prefixes="#all" version="3.0">

  <!-- define the list of topic elements (add specialized topics as needed) -->
  <xsl:variable name="topic-types" as="xs:string+" select="('concept', 'glossentry', 'glossgroup', 'learningAssessment', 'learningBase', 'learningContent', 'learningOverview', 'learningPlan', 'learningSummary', 'reference', 'task', 'topic', 'troubleshooting')"/>


  <!-- define a "get-referenced-element" mode that returns the element referenced by an <xref> or <link> element -->
  <xsl:mode name="get-referenced-element" on-no-match="deep-skip"/>

  <!-- always skip non-DITA and external references -->
  <xsl:template match="*[@scope = 'external']" mode="get-referenced-element" as="element()?" priority="20"/>
  <xsl:template match="*[@format and not(@format = 'dita')]" mode="get-referenced-element" as="element()?" priority="10"/>

  <!-- return the element referenced by an @href or @keyref reference -->
  <xsl:template match="*[@href | @keyref]" mode="get-referenced-element" as="element()*">
    <!-- remember the context in which our cross-reference element exists -->
    <xsl:variable name="current-uri" as="xs:anyURI" select="base-uri(.)"/>

    <!-- get the @href, or resolve the @keyref to an @href -->
    <xsl:variable name="href-to-resolve" as="xs:string?" select="if (@href) then @href else ditaaccess:getKeyRefAbsoluteReference(@keyref, $current-uri)"/>

    <!-- if we have a non-empty @href, process it -->
    <xsl:if test="normalize-space($href-to-resolve) ne ''">

      <!-- parse the @href: [file]#topic_id[/element_id] -->
      <xsl:variable name="href" as="map(*)">
        <xsl:analyze-string select="$href-to-resolve" regex="^([^#]*)(?:#([^/]+)(?:/(.+))?)?$">
          <xsl:matching-substring>
            <xsl:map>
              <xsl:map-entry key="'file'" select="if (regex-group(1) != '') then resolve-uri(regex-group(1), $current-uri) else $current-uri"/>
              <xsl:map-entry key="'topic_id'" select="regex-group(2)"/>
              <xsl:map-entry key="'element_id'" select="regex-group(3)"/>
            </xsl:map>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:variable>

      <!-- if we parsed the @href, search for the referenced element -->
      <xsl:if test="exists($href) and map:contains($href, 'file') and doc-available($href?file)">

        <!-- if we're searching within the same document as our reference, search the in-memory document instead of the on-disk document
             (in case we are in the middle of multiple-pass processing and the current document differs from the on-disk document) -->
        <xsl:variable name="ref-doc-root-element" as="element()">
          <xsl:variable name="this-doc-root-element" as="element()" select="(ancestor-or-self::*)[1]"/>
          <xsl:variable name="that-doc-root-element" as="element()" select="document($href?file)/*"/>
          <xsl:variable name="that-doc-is-this-doc" as="xs:boolean" select="base-uri($that-doc-root-element) = base-uri($this-doc-root-element) and local-name($that-doc-root-element) = local-name($this-doc-root-element) and $that-doc-root-element/@id = $this-doc-root-element/@id"/>
          <xsl:sequence select="if ($that-doc-is-this-doc) then $this-doc-root-element else $that-doc-root-element"/>
        </xsl:variable>

        <!-- find the topic or subtopic within the document to search -->
        <xsl:variable name="that-topic" as="element()*">
          <xsl:choose>
            <xsl:when test="$href?topic_id = ('', '[FIRST_TOPIC_ID]')">  <!-- "[FIRST_TOPIC_ID]" is a special API return value -->
              <xsl:sequence select="$ref-doc-root-element"/>
            </xsl:when>
            <xsl:when test="$href?topic_id = '.'">
              <xsl:sequence select="./ancestor::*[local-name(.) = $topic-types][1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="$ref-doc-root-element/descendant-or-self::*[@id = $href?topic_id]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- search for the referenced topic or non-topic element -->
        <xsl:variable name="that-elt" as="element()*">
          <xsl:choose>
            <xsl:when test="$href?element_id != ''">
              <!-- element ID specified - search the specified topic's content without also searching its subtopics -->
              <xsl:sequence select="$that-topic/*[not(local-name(.) = $topic-types)]/descendant-or-self::*[@id = $href?element_id]"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- no element ID specified - return the referenced topic -->
              <xsl:sequence select="$that-topic"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- process the search results -->
        <xsl:choose>
          <xsl:when test="count($that-elt) = 0">
            <!-- no match found; return an empty sequence -->
          </xsl:when>
          <xsl:when test="count($that-elt) = 1">
            <!-- a single element matched; return it -->
            <xsl:sequence select="$that-elt"/>
          </xsl:when>
          <xsl:when test="count($that-elt) > 1">
            <!-- multiple elements matched; warn of an ambiguous match (and return an empty sequence) -->
            <xsl:message expand-text="yes">Duplicate @id value '{$href?id}' found in '{$href?file}'; please fix and rerun.</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
