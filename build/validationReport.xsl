<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0" xmlns:rp="http://www.oxygenxml.com/ns/report">
    <xsl:output method="text"/>
    <xsl:template match="/">
# Validate and check for completenss Results
<xsl:for-each select="//rp:incident">
## Incident    
**Severity**:<xsl:value-of select="rp:severity"/>
    
**Description**:<xsl:value-of select="rp:description"/>
    
</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>