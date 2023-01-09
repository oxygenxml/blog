<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:template match="*[contains(@class, ' topic/prolog ')]">
    <xsl:choose>
      <xsl:when test="/*[@outputclass='google-structured-data-steps']">
        <xsl:apply-templates select="/*" mode="google-structured-data-task"/>
      </xsl:when>
      <xsl:when test="/*[@outputclass='google-structured-data-faq']">
        <xsl:apply-templates select="/*" mode="google-structured-data-faq"/>
      </xsl:when>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="*" mode="google-structured-data-faq">
    <script type="application/ld+json">
     {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        <xsl:for-each select="body/section">
          {
            "@type": "Question",
            "name": "<xsl:value-of select="normalize-space(title)"/>",
            "acceptedAnswer": {
            "@type": "Answer",
            "text": "Suggested answer: <xsl:value-of select="normalize-space(string-join(*[not(self::title)], ''))"/>"
            }
          }
          <xsl:if test="position() &lt; last()">,</xsl:if>
        </xsl:for-each>
      ]
     }
    </script>
  </xsl:template>
  
  <xsl:template match="*" mode="google-structured-data-task">
    <script type="application/ld+json">
      {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "<xsl:value-of select="title"/>",
      "step": [
      <xsl:for-each select="taskbody/steps/step">
        {
        "@type": "HowToSection",
        "name": "Step",
        "position": "<xsl:value-of select="position()"/>",
        "itemListElement": [
        {
        "@type": "HowToStep",
        "position": "1",
        "itemListElement": [
        {
        "@type": "HowToDirection",
        "position": "1",
        "text": "Suggested Step: <xsl:value-of select="normalize-space(cmd)"/>"
        }]}]}
        <xsl:if test="position() &lt; last()">,</xsl:if>
      </xsl:for-each>
      ]}
    </script>
  </xsl:template>
</xsl:stylesheet>