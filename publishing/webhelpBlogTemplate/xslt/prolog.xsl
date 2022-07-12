<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="*[contains(@class, ' topic/prolog ')]">     
        <xsl:variable name="avatar-author" select="replace(*[contains(@class, ' topic/author ')],' ','_')"/>
        <div class="author inPage {$avatar-author}">
            <a href="/topics/contributors.html">
                <xsl:value-of select="*[contains(@class, ' topic/author ')]"/>
            </a>
        </div>
        <xsl:if test="exists(.//*[contains(@class, ' topic/created ')]/@date)">  
            <div class="date inPage">
                <xsl:variable name="cd" select=".//*[contains(@class, ' topic/created ')]/@date"/>
                <xsl:value-of select="format-date(xs:date($cd), 
                    '[D] [MNn,3-3] [Y0001]')"/>
            </div>
        </xsl:if>
        <xsl:next-match/>
    </xsl:template>
</xsl:stylesheet>
