<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="*[contains(@class, ' topic/prolog ')]">
        <!-- Display the author name -->
        <xsl:variable name="avatar-author" select="replace(*[contains(@class, ' topic/author ')],' ','_')"/>
        <div class="author inPage {$avatar-author}">
            <a href="/topics/contributors.html">
                <xsl:value-of select="*[contains(@class, ' topic/author ')]"/>
            </a>
        </div>
        <!-- Display the creation date -->
        <xsl:if test="exists(.//*[contains(@class, ' topic/created ')]/@date)">  
            <div class="date inPage">
                <xsl:variable name="cd" select=".//*[contains(@class, ' topic/created ')]/@date"/>
                <xsl:value-of select="format-date(xs:date($cd), 
                    '[D] [MNn,3-3] [Y0001]')"/>
            </div>
        </xsl:if>
        <!-- Display the number of minutes it takes to read the article -->
        <div style="color: gray;">
            <xsl:variable name="fileContent" select="/"/>
            <xsl:variable name="text" select="normalize-space($fileContent)"/> 
            <xsl:variable name="textWithoutSpaces" select="translate($fileContent, ' ', '')" /> 
            <xsl:variable name="fileCountWords" select="string-length($text) - string-length($textWithoutSpaces) +1"/>
            <xsl:variable name="readMin" select="format-number($fileCountWords div 50, '0')"/>
            Read time: <xsl:value-of select="$readMin"/> minute(s)
        </div>
        <xsl:next-match/>
    </xsl:template>
</xsl:stylesheet>
