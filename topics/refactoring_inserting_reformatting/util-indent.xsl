<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:mine="mine:local"
  version="3.0">

  <!-- define an XSLT3 map of the known fixed outer tag types -->
  <xsl:variable name="outer-tag-type" as="map(xs:string, xs:string*)" select="map {
    'abstract': 'block', 'alt': 'block', 'area': 'block', 'author': 'block', 'body': 'block', 'cite': 'text', 'codeph': 'text', 'colspec': 'block', 'coords': 'block', 'dd': 'block', 'ddhd': 'block', 'desc': 'block', 'dl': 'block', 'dlentry': 'block', 'dlhead': 'block', 'draft-comment': '', 'dt': 'block', 'dthd': 'block', 'entry': 'block', 'equation-block': 'block', 'equation-figure': 'block', 'equation-inline': 'text', 'equation-number': 'text', 'example': 'block', 'fig': 'block', 'figgroup': 'block', 'fn': 'text', 'foreign': '', 'image': '', 'imagemap': 'block', 'indexterm': '', 'keyword': '', 'keywords': 'block', 'li': 'block', 'link': 'block', 'linktext': 'block', 'mathml': 'block', 'menucascade': 'text', 'metadata': 'block', 'module': 'block', 'note': 'block', 'ol': 'block', 'othermeta': 'block', 'p': 'block', 'ph': 'text', 'pre': 'block', 'prolog': 'block', 'reference-section': 'block', 'related-links': 'block', 'required-cleanup': '', 'resourceid': 'block', 'row': 'block', 'section': 'block', 'shape': 'block', 'shortdesc': 'block', 'sort-as': '', 'sub': 'text', 'sup': 'text', 'table': 'block', 'tbody': 'block', 'term': 'text', 'text': 'text', 'tgroup': 'block', 'thead': 'block', 'title': 'block', 'topic': 'block', 'uicontrol': 'text', 'ul': 'block', 'unknown': '', 'xref': 'text',
    'abbrevlist': 'block', 'addressdetails': 'block', 'administrativearea': '', 'amendments': 'block', 'anchor': 'block', 'anchorid': 'block', 'anchorkey': 'block', 'anchorref': 'block', 'appendices': 'block', 'appendix': 'block', 'approved': 'block', 'authorinformation': 'block', 'backmatter': 'block', 'bibliolist': 'block', 'bookabstract': 'block', 'bookchangehistory': 'block', 'bookevent': 'block', 'bookeventtype': 'block', 'bookid': 'block', 'booklibrary': 'block', 'booklist': 'block', 'booklists': 'block', 'bookmap': 'block', 'bookmeta': 'block', 'booknumber': 'block', 'bookowner': 'block', 'bookpartno': 'block', 'bookrestriction': 'block', 'bookrights': 'block', 'booktitle': 'block', 'booktitlealt': 'block', 'chapter': 'block', 'colophon': 'block', 'completed': 'block', 'contactnumber': 'block', 'contactnumbers': 'block', 'copyrfirst': 'block', 'copyrlast': 'block', 'country': '', 'day': 'block', 'dedication': 'block', 'ditavalmeta': 'block', 'ditavalref': 'block', 'draftintro': 'block', 'dvrKeyscopePrefix': 'block', 'dvrKeyscopeSuffix': 'block', 'dvrResourcePrefix': 'block', 'dvrResourceSuffix': 'block', 'edited': 'block', 'edition': 'block', 'emailaddress': 'block', 'emailaddresses': 'block', 'exportanchors': 'block', 'figurelist': 'block', 'firstname': 'block', 'frontmatter': 'block', 'generationidentifier': 'block', 'glossarylist': 'block', 'honorific': 'block', 'indexlist': 'block', 'isbn': 'block', 'keydef': 'block', 'lastname': 'block', 'locality': '', 'localityname': '', 'mainbooktitle': 'block', 'maintainer': 'block', 'map': 'block', 'mapref': 'block', 'middlename': 'block', 'month': 'block', 'namedetails': 'block', 'navref': 'block', 'notices': 'block', 'organization': 'block', 'organizationinfo': 'block', 'organizationname': 'block', 'organizationnamedetails': 'block', 'otherinfo': 'block', 'part': 'block', 'person': 'block', 'personinfo': 'block', 'personname': 'block', 'postalcode': '', 'preface': 'block', 'printlocation': 'block', 'published': 'block', 'publisherinformation': 'block', 'publishtype': 'block', 'relcell': 'block', 'relcolspec': 'block', 'relheader': 'block', 'relrow': 'block', 'reltable': 'block', 'reviewed': 'block', 'revisionid': 'block', 'started': 'block', 'summary': 'block', 'tablelist': 'block', 'tested': 'block', 'thoroughfare': '', 'toc': 'block', 'topicgroup': 'block', 'topichead': 'block', 'topicmeta': 'block', 'topicref': 'block', 'topicset': 'block', 'topicsetref': 'block', 'trademarklist': 'block', 'url': 'block', 'urls': 'block', 'ux-window': 'block', 'volume': 'block', 'year': 'block',
    'glossAbbreviation': 'block', 'glossAcronym': 'block', 'glossAlt': 'block', 'glossAlternateFor': 'block', 'glossBody': 'block', 'glossPartOfSpeech': 'block', 'glossProperty': 'block', 'glossScopeNote': 'block', 'glossShortForm': 'block', 'glossStatus': 'block', 'glossSurfaceForm': 'block', 'glossSymbol': 'block', 'glossSynonym': 'block', 'glossUsage': 'block', 'glossdef': 'block', 'glossentry': 'block', 'glossgroup': 'block', 'glossterm': 'block'
    }"/>

  <!-- define an XSLT3 map of the known fixed inner tag types -->
  <xsl:variable name="inner-tag-type" as="map(xs:string, xs:string*)" select="map {
    'abstract': 'block', 'alt': 'text', 'area': 'block', 'author': 'text', 'body': 'block', 'cite': 'text', 'codeph': 'text', 'colspec': '', 'coords': 'text', 'dd': 'block', 'ddhd': 'block', 'desc': 'text', 'dl': 'block', 'dlentry': 'block', 'dlhead': 'block', 'draft-comment': '', 'dt': 'text', 'dthd': 'text', 'entry': '', 'equation-block': 'block', 'equation-figure': 'block', 'equation-inline': 'block', 'equation-number': 'text', 'example': 'block', 'fig': 'block', 'figgroup': 'block', 'fn': 'text', 'foreign': '', 'image': 'block', 'imagemap': 'block', 'indexterm': 'text', 'keyword': 'text', 'keywords': 'block', 'li': 'block', 'link': 'block', 'linktext': 'text', 'mathml': 'block', 'menucascade': 'block', 'metadata': 'block', 'module': 'block', 'note': 'block', 'ol': 'block', 'othermeta': '', 'p': 'text', 'ph': 'text', 'pre': 'text', 'prolog': 'block', 'reference-section': 'block', 'related-links': 'block', 'required-cleanup': '', 'resourceid': 'block', 'row': 'block', 'section': 'block', 'shape': 'text', 'shortdesc': 'text', 'sort-as': 'text', 'sub': 'text', 'sup': 'text', 'table': 'block', 'tbody': 'block', 'term': 'text', 'text': 'text', 'tgroup': 'block', 'thead': 'block', 'title': 'text', 'topic': 'block', 'uicontrol': 'text', 'ul': 'block', 'unknown': '', 'xref': 'text',
    'abbrevlist': '', 'addressdetails': 'text', 'administrativearea': 'text', 'amendments': '', 'anchor': '', 'anchorid': '', 'anchorkey': '', 'anchorref': 'block', 'appendices': 'block', 'appendix': 'block', 'approved': 'block', 'authorinformation': 'block', 'backmatter': 'block', 'bibliolist': '', 'bookabstract': '', 'bookchangehistory': 'block', 'bookevent': 'block', 'bookeventtype': '', 'bookid': 'block', 'booklibrary': 'text', 'booklist': '', 'booklists': 'block', 'bookmap': 'block', 'bookmeta': 'block', 'booknumber': 'text', 'bookowner': 'block', 'bookpartno': 'text', 'bookrestriction': '', 'bookrights': 'block', 'booktitle': 'block', 'booktitlealt': 'text', 'chapter': 'block', 'colophon': '', 'completed': 'block', 'contactnumber': 'text', 'contactnumbers': 'block', 'copyrfirst': 'block', 'copyrlast': 'block', 'country': 'text', 'day': 'text', 'dedication': '', 'ditavalmeta': 'block', 'ditavalref': 'block', 'draftintro': 'block', 'dvrKeyscopePrefix': 'text', 'dvrKeyscopeSuffix': 'text', 'dvrResourcePrefix': 'text', 'dvrResourceSuffix': 'text', 'edited': 'block', 'edition': 'text', 'emailaddress': 'text', 'emailaddresses': 'block', 'exportanchors': 'block', 'figurelist': '', 'firstname': 'text', 'frontmatter': 'block', 'generationidentifier': 'text', 'glossarylist': 'block', 'honorific': 'text', 'indexlist': '', 'isbn': 'text', 'keydef': 'block', 'lastname': 'text', 'locality': 'text', 'localityname': 'text', 'mainbooktitle': 'text', 'maintainer': 'block', 'map': 'block', 'mapref': 'block', 'middlename': 'text', 'month': 'text', 'namedetails': 'block', 'navref': '', 'notices': 'block', 'organization': 'text', 'organizationinfo': 'block', 'organizationname': 'text', 'organizationnamedetails': 'block', 'otherinfo': 'text', 'part': 'block', 'person': 'text', 'personinfo': 'block', 'personname': 'block', 'postalcode': 'text', 'preface': 'block', 'printlocation': 'text', 'published': 'block', 'publisherinformation': 'block', 'publishtype': '', 'relcell': 'block', 'relcolspec': 'block', 'relheader': 'block', 'relrow': 'block', 'reltable': 'block', 'reviewed': 'block', 'revisionid': 'block', 'started': 'block', 'summary': 'text', 'tablelist': '', 'tested': 'block', 'thoroughfare': 'text', 'toc': '', 'topicgroup': 'block', 'topichead': 'block', 'topicmeta': 'block', 'topicref': 'block', 'topicset': 'block', 'topicsetref': 'block', 'trademarklist': '', 'url': 'text', 'urls': 'block', 'ux-window': '', 'volume': 'text', 'year': 'text',
    'glossAbbreviation': 'text', 'glossAcronym': 'text', 'glossAlt': 'block', 'glossAlternateFor': '', 'glossBody': 'block', 'glossPartOfSpeech': '', 'glossProperty': 'text', 'glossScopeNote': '', 'glossShortForm': 'test', 'glossStatus': '', 'glossSurfaceForm': 'text', 'glossSymbol': 'block', 'glossSynonym': 'text', 'glossUsage': 'text', 'glossdef': 'block', 'glossentry': 'block', 'glossgroup': 'block', 'glossterm': 'text'
    }"/>


  <!-- get indent width for document -->
  <xsl:variable name="doc-indent">
    <!-- get a sequence of all indent widths in the document -->
    <xsl:variable name="all-indents" as="xs:int*">
      <xsl:apply-templates select="/" mode="get-all-indents"/>
    </xsl:variable>

    <!-- return the most common value
         (defaults to 4 if no indenting exists) -->
    <xsl:for-each-group select="if (count($all-indents) > 0) then ($all-indents) else (4)" group-by=".">
      <xsl:sort select="count(current-group())" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="string-join((1 to current-grouping-key()) ! ' ')"/>  <!-- build a string of spaces -->
      </xsl:if>
    </xsl:for-each-group>
  </xsl:variable>

  <!-- this template mode explores the document and returns all the indent widths it finds -->
  <xsl:mode name="get-all-indents" on-no-match="shallow-skip"/>

  <!-- for "newline-ident" text elements followed directly by an element, return the indent width -->
  <xsl:template match="text()[matches(., '^\n *$')][following-sibling::node()[1][self::*]]" mode="get-all-indents">
    <xsl:value-of select="round((string-length(.)-1) div count(ancestor::*))"/>
  </xsl:template>

  <!-- do not recurse into any level that contains non-whitespace text content -->
  <xsl:template match="node()[../text()[matches(., '\S')]]" mode="get-all-indents" priority="10"/>


  <!-- define a mode that applies new indentation as directed by an @indent atribute -->
  <xsl:mode name="indent-stuff" on-no-match="shallow-copy"/>

  <!-- explicitly avoid reindenting non-DITA content -->
  <xsl:template match="m:math|foreign|unknown" mode="indent-stuff">  <!-- TO-DO - add svg element -->
    <xsl:sequence select="."/>
  </xsl:template>

  <!-- deep-copy sections of the document that are not affected by @indent -->
  <xsl:template match="*
    [not(.//@indent)]
    [not(../*[contains-token(@indent, ('siblings')) or contains-token(@indent, ('adjacent-siblings'))])]
    [not(..[contains-token(@indent, 'children')])]
    [not(ancestor::*[contains-token(@indent, 'deep')])]" mode="indent-stuff">
    <xsl:sequence select="."/>
  </xsl:template>

  <!-- remove old indentation text before opening tags -->
  <xsl:template match="text()[following-sibling::node()[1][mine:is-indented(.)][mine:outer-tag-type(.) = 'block']]" mode="indent-stuff">
    <xsl:value-of select="replace(., '\s+$', '')"/>
  </xsl:template>

  <!-- remove old indentation text before closing tags -->
  <xsl:template match="text()
                         [not(following-sibling::node())]
                         [(parent::*[mine:is-indented(.)][mine:inner-tag-type(.) = 'block']) or
                          (preceding-sibling::node()[1][mine:is-indented(.)][mine:outer-tag-type(.) = 'block'])]" mode="indent-stuff">
    <xsl:value-of select="replace(., '\s+$', '')"/>
  </xsl:template>

  <!-- add new indentation text before opening tags -->
  <xsl:template match="*[mine:is-indented(.)][mine:outer-tag-type(.) = 'block']" mode="indent-stuff" priority="15">
    <xsl:value-of select="'&#10;' || string-join((1 to count(ancestor::*)) ! $doc-indent)"/>  <!-- add indent before first node -->
    <xsl:next-match/>  <!-- process first node -->
  </xsl:template>

  <!-- add new indentation text before closing tags -->
  <xsl:template match="node()
                         [not(following-sibling::node())]
                         [(parent::*[mine:is-indented(.)][mine:inner-tag-type(.) = 'block']) or
                          ((., preceding-sibling::node()[1])[self::*][1][mine:is-indented(.)][mine:outer-tag-type(.) = 'block'])]" mode="indent-stuff" priority="10">
    <xsl:next-match/>  <!-- process last node -->
    <xsl:value-of select="'&#10;' || string-join((1 to count(ancestor::*)-1) ! $doc-indent)"/>  <!-- add indent after last node -->
  </xsl:template>

  <!-- remove @indent as we go -->
  <xsl:template match="@indent" mode="indent-stuff"/>

  <!-- check @indent to see if a particular element should be indented -->
  <xsl:function name="mine:is-indented" as="xs:boolean">
    <xsl:param name="node" as="node()*"/>
    <xsl:apply-templates select="$node" mode="is-indented"/>  <!-- provide an accessor function for predicate conditions -->
  </xsl:function>
  <xsl:template match="node()" mode="is-indented">
    <xsl:sequence select="false()"/>  <!-- default indent status is false -->
  </xsl:template>
  <!-- the priority values below are not functionally meaningful; they simply avoid ambiguous match messages when debugging -->
  <xsl:template match="*[contains-token(@indent, 'self')]" mode="is-indented" priority="1">
    <xsl:sequence select="true()"/>  <!-- true if self is indented -->
  </xsl:template>
  <xsl:template match="*[../*[contains-token(@indent, 'siblings')]]" mode="is-indented" priority="2">
    <xsl:sequence select="true()"/>  <!-- true if any sibling is indented -->
  </xsl:template>
  <xsl:template match="*[parent::*[contains-token(@indent, 'children')]]" mode="is-indented" priority="3">
    <xsl:sequence select="true()"/>  <!-- true if the parent's children are indented -->
  </xsl:template>
  <xsl:template match="*[ancestor::*[contains-token(@indent, 'deep')]]" mode="is-indented" priority="4">
    <xsl:sequence select="true()"/>  <!-- true if an ancestor is deep-indented -->
  </xsl:template>
  <xsl:template match="*[(
        preceding-sibling::node()[not(self::text()[not(normalize-space(.))])][1][self::*],
        following-sibling::node()[not(self::text()[not(normalize-space(.))])][1][self::*]
      )[contains-token(@indent, 'adjacent-siblings')]]" mode="is-indented" priority="5">
    <xsl:sequence select="true()"/>  <!-- true if a directly adjacent sibling is indented -->
  </xsl:template>

  <!-- return whether a node's outer tag type is 'block', 'text', or '' (unknown)
       (for performance reasons, we do not call mine:inner-tag-type() or mine:outer-tag-type() to recursively evaluate context) -->
  <xsl:function name="mine:outer-tag-type" as="xs:string*">
    <xsl:param name="node" as="node()*"/>
    <xsl:choose>
      <!-- text nodes do not participate in indentation -->
      <xsl:when test="$node[self::text()]">
        <xsl:sequence select="''"/>
      </xsl:when>

      <!-- handle some context-specific special cases -->
      <xsl:when test="$node[self::uicontrol][parent::menucascade]">
        <xsl:sequence select="'block'"/>  <!-- to match Oxygen editor -->
      </xsl:when>
      <xsl:when test="$node[@placement = 'break']">
        <xsl:sequence select="'block'"/>
      </xsl:when>

      <!-- if this element has a fixed outer tag type, return it -->
      <xsl:when test="$outer-tag-type(local-name($node))">
        <xsl:sequence select="$outer-tag-type(local-name($node))"/>
      </xsl:when>

      <!-- if the parent element has a fixed inner tag type, return it as our outer tag type -->
      <xsl:when test="$inner-tag-type(local-name($node/..))">
        <xsl:sequence select="$inner-tag-type(local-name($node/..))"/>
      </xsl:when>

      <!-- if a sibling element has a fixed outer tag type, return it
           ('block' takes precedence over 'text') -->
      <xsl:when test="$node/../*[$outer-tag-type(local-name(.)) = 'block']">
        <xsl:sequence select="'block'"/>
      </xsl:when>
      <xsl:when test="$node/../*[$outer-tag-type(local-name(.)) = 'text']">
        <xsl:sequence select="'text'"/>
      </xsl:when>

      <!-- if there are non-whitespace text node siblings, return a 'text' outer tag type -->
      <xsl:when test="$node/../text()[matches(., '\S')]">
        <xsl:sequence select="'text'"/>
      </xsl:when>

      <!-- as a last resort, if a child element has a fixed outer tag type, propagate it upward as ours
           ('block' takes precedence over 'text') -->
      <xsl:when test="$node/*[$outer-tag-type(local-name(.)) = 'block']">
        <xsl:sequence select="'block'"/>
      </xsl:when>
      <xsl:when test="$node/*[$outer-tag-type(local-name(.)) = 'text']">
        <xsl:sequence select="'text'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

  <!-- return whether a node's inner tag type is 'block', 'text', or '' (unknown)
       (for performance reasons, we do not call mine:inner-tag-type() or mine:outer-tag-type() to recursively evaluate context) -->
  <xsl:function name="mine:inner-tag-type" as="xs:string*">
    <xsl:param name="node" as="node()*"/>
    <xsl:choose>
      <!-- if this element has a fixed inner tag type, return it -->
      <xsl:when test="$inner-tag-type(local-name($node))">
        <xsl:sequence select="$inner-tag-type(local-name($node))"/>
      </xsl:when>

      <!-- if a child element has a fixed outer tag type, return it as our inner tag type
           ('block' takes precedence over 'text') -->
      <xsl:when test="$node/*/$outer-tag-type(local-name(.)) = 'block'">
        <xsl:sequence select="'block'"/>
      </xsl:when>
      <xsl:when test="$node/*/$outer-tag-type(local-name(.)) = 'text'">
        <xsl:sequence select="'text'"/>
      </xsl:when>
      <xsl:when test="$node/*/*[$outer-tag-type(local-name(.)) = 'block']">
        <xsl:sequence select="'block'"/>
      </xsl:when>
      <xsl:when test="$node/*/*[$outer-tag-type(local-name(.)) = 'text']">
        <xsl:sequence select="'text'"/>
      </xsl:when>

      <!-- if there are non-whitespace text node children, return a 'text' inner tag type -->
      <xsl:when test="$node/text()[matches(., '\S')]">
        <xsl:sequence select="'text'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>

