<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="*[contains(@class, ' topic/prolog ')]">
        <!-- create a special div which displays all labels, with a link on each label -->
        <xsl:if test=".//keyword[@outputclass = 'label']">
            <div class="label inPage">
                <xsl:apply-templates select=".//keyword[@outputclass = 'label']"/>
            </div>
        </xsl:if>
        <xsl:next-match/>
    </xsl:template>
    
    <!-- Match a label keyword and display it as a span -->
    <xsl:template match="keyword[@outputclass = 'label']">
        <a
            href="{concat('../search.html?searchQuery=label_', normalize-space(translate(text(), ' ', '_')))}">
            <span><xsl:value-of select="text()"/></span>
        </a>
    </xsl:template>
    
    <!-- Add specific HTML meta elements for each label -->
    <xsl:template match="*" mode="gen-keywords-metadata">
        <xsl:next-match/>
        <xsl:variable name="keywords-content">
            <!-- for each label -->
            <xsl:for-each select="//keyword[@outputclass = 'label']">
                <xsl:value-of
                    select="concat('label_', normalize-space(translate(text(), ' ', '_')))"/>
                <xsl:if test="position() &lt; last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:if test="string-length($keywords-content) > 0">
            <meta name="keywords" content="{$keywords-content}"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>