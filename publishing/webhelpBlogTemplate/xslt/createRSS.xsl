<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc" 
    version="2.0">
    
    <xsl:param name="JSON_OUTPUT_DIR_URI"/>
    <xsl:template match="/toc:toc">
        <xsl:next-match/>
        <xsl:apply-templates mode="rss" select="."/>
    </xsl:template>
    
    <xsl:template match="/toc:toc" mode="rss">
        <xsl:result-document href="{concat($JSON_OUTPUT_DIR_URI, '/../../../../rss.xml')}" indent="yes">
            <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
                <channel>
                    <title>&lt;oXygen/&gt; XML Editor Blog</title>
                    <link>https://blog.oxygenxml.com/rss.xml</link>
                    <description>The Latest &lt;oXygen/&gt; XML Editor Blog Updates</description>
                    <language>en-us</language>
                    <atom:link href="https://blog.oxygenxml.com/rss.xml" rel="self" type="application/rss+xml" xmlns:atom="http://www.w3.org/2005/Atom"/>
                    <lastBuildDate><xsl:value-of select="format-dateTime(current-dateTime(),'[F], [D] [M01] [Y] [h] [P] [z]')"/></lastBuildDate>
                    <docs>https://oxygenxmlblog.netlify.com/</docs>
                    <generator> oXygen XML Editor</generator>
                    <managingEditor>support@oxygenxml.com (Oxygen XML Editor Support)</managingEditor>
                    <webMaster>webmaster@oxygenxml.com (Oxygen XML Editor Webmaster)</webMaster>
                    <copyright>Copyright @2022 SyncRO Soft SRL. All rights reserved.</copyright>
                    <category>News</category>
                    <ttl>30</ttl>        
                    <image>
                        <url>http://www.oxygenxml.com/img/oxygenxml.gif</url>
                        <title>&lt;oXygen/&gt; XML Editor Blog</title>
                        <link>/rss.xml</link>
                    </image>
                    <xsl:for-each select="//toc:topic">
                        <xsl:if test="not(@href = 'javascript:void(0)')">
                            <item>
                                <title><xsl:value-of select="toc:title"/></title>
                                <link><xsl:value-of select="concat('https://blog.oxygenxml.com', '/', @href)"/></link>   
                                <guid isPermaLink="false"><xsl:value-of select="@href"/></guid>
                                <xsl:variable name="ref" select="replace(resolve-uri(@href, base-uri()), '\.html', '.dita')"/>
                                <xsl:variable name="date" select="(document($ref)//prolog)[1]/critdates/created/@date"/>
                                <xsl:choose>
                                    <xsl:when test="$date">
                                        <pubDate><xsl:value-of select="
                                            format-date(xs:date($date),
                                            '[F], [D01] [MNn,*-3] [Y] 00:00:00 GMT')"/></pubDate>
                                        <!-- Format like: Thu, 20 Dec 2022 02:46:11 UTC -->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Set some fixed date so that the topic does not appear as new -->
                                        <pubDate> Wed, 1 Jan 2020 02:46:11 GMT</pubDate>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </item>
                        </xsl:if>
                    </xsl:for-each>
                </channel>
            </rss>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>