<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    xmlns:whc="http://www.oxygenxml.com/webhelp/components"
    exclude-result-prefixes="xs whc"
    version="2.0">
    
    <xsl:import href="move-search-in-header.xsl" />
    
    <xsl:param name="TOC_XML_FILEPATH"></xsl:param>
    <xsl:template match="*:div[contains(@class,'wh_content_flex_container')]" mode="copy_template">
        <div class="container-fluid">  
            <xsl:variable name="tempDirPath" select="substring-before($TOC_XML_FILEPATH,'toc.xml')"/>
            <xsl:variable name="mainpageContentFilePath" select="concat($tempDirPath,'/mainpage/content.html')"/>
            <xsl:variable name="contentURL" select="iri-to-uri(concat('file:///', replace($mainpageContentFilePath, '\\', '/')))"/>
            <xsl:call-template name="includeCustomHTMLContent">
                <xsl:with-param name="hrefURL" select="$contentURL"></xsl:with-param>
            </xsl:call-template>
        </div>
        
        <xsl:next-match/>
    </xsl:template>
   
</xsl:stylesheet>