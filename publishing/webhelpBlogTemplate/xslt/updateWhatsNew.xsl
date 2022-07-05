<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc">

    <!-- Artifically impose content to the what's new topic. -->
    <xsl:template match="/">
        <xsl:next-match/>
        
        <xsl:result-document href="{resolve-uri('mainpage/content.html', base-uri())}">
            <xsl:processing-instruction name="workdir-uri"><xsl:value-of select="replace(resolve-uri('topics/what_s_new.dita', base-uri()), 'what_s_new.dita', '')"/></xsl:processing-instruction>
            <xsl:processing-instruction name="path2project-uri">../</xsl:processing-instruction>
            <xsl:processing-instruction name="path2rootmap-uri">../</xsl:processing-instruction>
            <div class="row">
                  
                <div class="mb_index col-lg-8">
                    <div class="mb_index_bg">
                        
                        <div class="entry">
                            <div class="title">Welcome to our Blog!</div>
                            <div>
                                If you have been searching for useful articles and tutorials covering the various aspects of editing, developing, and publishing using Oxygen XML Editor with various XML technologies, you arrived at the right place!
                            </div>
                            <div class="col-md-4" id="quick_links">
                                
                                <button type="button" class="btn get-started">Get Started</button>
                            </div>
                        </div>
                    </div>
                    
                </div>   
                  
                <div class="col-lg-4 top-rated"> 
                    <div class="entry">
                        <h3>Top Rated</h3>
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/migrateWordToDita.html">
                            How to Migrate from Word to DITA
                        </a>
                        <!--<div class="date">17 May 2022</div>--><div><div class="label">MIGRATE | 5 MIN READ</div></div>
                    </div>
                </div>
                
                <div class="banner stripe-latest-posts col-lg-12"> 
                    <div class="row">  
                        <div class="col-lg-8">
                            <h3>Latest Posts</h3>
                            <xsl:for-each
                                select="//topicref[@href][not(@format) or @format = 'dita'][doc-available(resolve-uri(@href, base-uri()))][document(resolve-uri(@href, base-uri()))/*/prolog/critdates/created/@date]">
                                <xsl:sort select="document(resolve-uri(@href, base-uri()))/*/prolog/critdates/created/@date" order="descending"/>
                                <!-- Present only the first 10 topics -->
                                <xsl:if test="position() &gt; 0 and position() &lt; 10">
                                    <xsl:variable name="doc" select="document(resolve-uri(@href, base-uri()))"/>
                                    <xsl:variable name="cd" select="$doc/*/prolog/critdates/created/@date"/>
                                    
                                        
                                            <!--<div class="mb_index">
                                                <div class="mb_index_bg container">
                                                    
                                                    <div class="entry">
                                                        <div class="author radu"><a href="topics/contributors.html"><xsl:value-of select="$doc/*/prolog/author"/></a></div>
                                                       -\-<xsl:value-of select="@href"/>-\-
                                                        <a class="title" href="{replace(@href, '.dita', '.html')}"><xsl:value-of select="$doc/*/title"/></a>
                                                        <xsl:variable name="cd" select="$doc/*/prolog/critdates/created/@date"/>
                                                        <div class="date"><xsl:value-of select="format-date(xs:date($cd), '[D] [MNn,3-3] [Y0001]')"/></div>
                                                        <div class="label">DITA, Google | 7 MIN READ</div>
                                                    </div>
                                                </div>
                                            </div>-->
                                        
                                       
                                            <div class="entry">
                                                <xsl:variable name="avatar-author" select="replace($doc/*/prolog/author,' ','_')"/>
                                                <div class="author {$avatar-author}"><a href="topics/contributors.html"><xsl:value-of select="$doc/*/prolog/author"/></a></div>
                                                <xsl:variable name="label" select="$doc/*/prolog/metadata/keywords/keyword[@outputclass = 'label']">
                                                  <!--  <xsl:if test="$doc/*/prolog/keyword[@outputclass = 'label']">
                                                        <xsl:value-of select="."/>
                                                    </xsl:if>-->
                                                </xsl:variable>
                                                <xsl:variable name="fileUrl" select="replace(@href, '\.dita$', '.html')"/>
                                                <xsl:variable name="fileContent" select="$doc/*"/>
                                                <!--<xsl:variable name="fileCountWords" select="count(tokenize(concat($fileContent, ''), '\s'))"/>-->
                                                <xsl:variable name="x" select="normalize-space($fileContent)"/> 
                                                <xsl:variable name="y" select="translate($fileContent, ' ', '')" /> 
                                                <xsl:variable name="fileCountWords" select="string-length($x) - string-length($y) +1"/>
                                                <xsl:variable name="readMin" select="format-number($fileCountWords div 50, '0')"/>
                                             
                                                <a class="title" href="{$fileUrl}">
                                                    <xsl:value-of select="$doc/*/title"/>
                                                </a>
                                                <div class="date">
                                                    <xsl:value-of select="format-date(xs:date($cd),'[D] [MNn,3-3] [Y0001]')"/></div>
                                                <div class="label">
                                                    <xsl:if test="$label!= ''"><xsl:value-of select="$label"/> |</xsl:if> <xsl:value-of select="$readMin"/> MIN READ</div>
                                            </div>       
                                </xsl:if>
                            </xsl:for-each>
                        </div>
                        <div class="col-lg-4">
                            <h3>Follow us</h3>
                            <div id="follow-it" class="entry followit--follow-form-container" attr-a="" attr-b="" attr-c="" attr-d="" attr-e="" attr-f="">
                                <form data-v-390679af="" action="https://api.follow.it/subscription-form/TlAwUVBWTnF6UFNwbEN3bVk3K2ZQeVd2bEhrNHZZTGo3VzZnRGt2Q0FiY3BEelVjSWd0NTdBWGV1SG1pOHR3ZkJycUFSRkV0ODlOV0YyY2hiN25CckF0V0E2SjVUbUdpMzRnMTdSQktEc0xJY01EU3I3T1FqQy9rY1Rqcjg1YzF8NmVGWFV0NXNOdDU3T2d4Qnp6d1dLYytWOFRGM2ZYU05nbnpOZ01LaXIzZz0=/8" method="post">
                                    <div data-v-390679af="" class="form-preview">
                                        <div data-v-390679af="" class="preview-heading">
                                            <h3 data-v-390679af="" >Get new posts by email</h3></div> <div data-v-390679af="" class="preview-input-field"><input data-v-390679af="" type="email" name="email" required="required" placeholder="Enter your email" spellcheck="false" style="text-transform: none !important; font-family: Montserrat; font-weight: normal; color: rgb(0, 0, 0); font-size: 14px; text-align: center; background-color: rgb(255, 255, 255);"/></div> <div data-v-390679af="" class="preview-submit-button"><button data-v-390679af="" type="submit" style="text-transform: none !important; font-family: Montserrat; font-weight: bold; color: rgb(255, 255, 255); font-size: 16px; text-align: center; background-color: rgb(0, 0, 0);">Subscribe</button></div></div></form><a href="https://follow.it" class="powered-by-line">Powered by <img src="https://follow.it/static/img/colored-logo.svg" alt="follow.it" height="17px"/></a>
                            </div>
                            <div class="entry" id="quick_links">
                                <!--<h3>Follow us</h3>-->
                                
                                <div>Quick question, are you following us on our socials? We are constantly sharing product news and promotions on our social media, click the links below to follow your favourites!</div>
                                <div>
                                    <a href="https://www.facebook.com/syncrosoftsrl" class="lk-facebook" title="Facebook" target="_blank">
                                        <img src="./oxygen-webhelp/template/resources/images/facebook.png"/>
                                    </a>
                                    <a href="https://www.youtube.com/user/oxygenxml" class="lk-youtube" title="Youtube Channel" target="_blank">  
                                        <img src="./oxygen-webhelp/template/resources/images/you-tube.png"/>
                                    </a>
                                    <a href="http://twitter.com/oxygenxml" class="lk-blog" title="Twitter" target="_blank">  
                                        <img src="./oxygen-webhelp/template/resources/images/twitter.png"/>
                                    </a>
                                    <a href="https://www.linkedin.com/company/syncro-soft" class="lk-blog" title="Linkedin" target="_blank">  
                                        <img src="./oxygen-webhelp/template/resources/images/linkedin.png"/>
                                    </a>
                                </div>
                                <!--<a href="/terms_of_use.html">Terms of Use</a> | <a href="/privacy_policy.html">Privacy Policy
                    </a>-->
                            </div>
                            
                            <div class="entry" id="tags">
                                <h3>The Oxygen XML Blog as a Graph</h3>
                                  
                                <div id="mynetwork"></div>
                                <!--<a href="resources/sampleGraphBlog.html?hl=graph" class="more" target="_blank">See more</a>-->
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                
                
                
            </div>
        </xsl:result-document>
       
       
    </xsl:template>
</xsl:stylesheet>
