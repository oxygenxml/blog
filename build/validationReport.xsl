<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0" xmlns:rp="http://www.oxygenxml.com/ns/report">
    <xsl:output method="text"/>
    <xsl:param name="BRANCH_NAME" select="'master'"/>
    <xsl:template match="/"># Validate and check for completenss Results
<xsl:for-each select="//rp:incident">
## Incident    
**Severity**: <xsl:value-of select="rp:severity"/>
    
**Description**: <xsl:call-template name="replace-string">
    <xsl:with-param name="text" select="rp:description"/>
    <xsl:with-param name="replace" select="'/home/runner/work/blog/blog/'" />
        <xsl:with-param name="with" select="''"/>
    </xsl:call-template>
    
<xsl:variable name="url">
    <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="rp:systemID"/>
        <xsl:with-param name="replace" select="'/home/runner/work/blog/blog/'" />
        <xsl:with-param name="with" select="''"/>
    </xsl:call-template>
</xsl:variable>
    <xsl:variable name="base" select="'gitgh%3A%2F%2Fhttps%253A%252F%252Fgithub.com%252Foxygenxml%252Fblog%2F'"/>
<!-- https://www.oxygenxml.com/oxygen-xml-web-author/app/oxygen.html?url=gitgh%3A%2F%2Fhttps%253A%252F%252Fgithub.com%252Foxygenxml%252Fblog%2FtestBranch2%2Ftopics%2F10_things_i_enjoy_about_the_new_oxygen_json_editor.dita -->
**Location**: [<xsl:value-of select="$url"/>](<xsl:value-of select="concat('https://www.oxygenxml.com/oxygen-xml-web-author/app/oxygen.html?url=', $base, $BRANCH_NAME, '%2F', $url)"/>)
    
</xsl:for-each>
    </xsl:template>
    
    <xsl:template name="replace-string">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="with"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$with"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="with" select="$with"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>