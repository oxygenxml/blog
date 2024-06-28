<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc">

    <!-- Artifically impose content to the what's new topic. -->
    <xsl:template match="/">
        <xsl:next-match/>
        
        <xsl:result-document href="{resolve-uri('mainpage/content.html', base-uri())}">
            <div class="row">
                <div class="mb_index col-lg-9">
                    <div class="mb_index_bg">
                        <div class="entry">
                            <div class="title">Welcome to the Oxygen XML Blog!</div>
                            <div>
                                If you have been searching for useful articles and tutorials covering the various aspects of editing, developing, and publishing using Oxygen XML Author or Editor with various XML technologies, you arrived at the right place!
                            </div>
                            <div class="col-md-4" id="quick_links">
                                <button type="button" class="btn get-started">Get Started</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="banner stripe-latest-posts">                         
                        <h3>Latest Posts</h3>
                        <xsl:for-each
                            select="//topicref[@href][not(@format) or @format = 'dita'][doc-available(resolve-uri(@href, base-uri()))][(document(resolve-uri(@href, base-uri()))//prolog)[1]/critdates/created/@date]">
                            <xsl:sort select="(document(resolve-uri(@href, base-uri()))//prolog)[1]/critdates/created/@date" order="descending"/>
                            <!-- Present only the first 10 topics -->
                            <xsl:if test="position() &lt; 10">
                                <xsl:variable name="doc" select="document(resolve-uri(@href, base-uri()))"/>
                                <xsl:variable name="cd" select="($doc//prolog)[1]/critdates/created/@date"/>
                                <div class="entry">
                                    <xsl:variable name="prolog" select="($doc//prolog)[1]"/>
                                    <xsl:variable name="avatar-author" select="replace($prolog/author,' ','_')"/>
                                    <div class="author {$avatar-author}"><a href="topics/contributors.html"><xsl:value-of select="$prolog/author"/></a></div>
                                    <xsl:variable name="label" select="$prolog/metadata/keywords/keyword[@outputclass = 'label']"/>
                                    <xsl:variable name="fileUrl" select="replace(@href, '\.dita$', '.html')"/>
                                    <xsl:variable name="fileContent" select="$doc/*"/>
                                    <xsl:variable name="x" select="normalize-space($fileContent)"/>
                                	<xsl:variable name="y" select="translate($x, ' ', '')" />
                                    <xsl:variable name="fileCountWords" select="string-length($x) - string-length($y) +1"/>
                                    <xsl:variable name="readMin" select="format-number($fileCountWords div 100, '0')"/>
                                    
                                    <a class="title" href="{$fileUrl}">
                                        <xsl:value-of select="($doc//title)[1]"/>
                                    </a>
                                    <div class="date">
                                        <xsl:value-of select="format-date(xs:date($cd),'[D] [MNn,3-3] [Y0001]')"/></div>
                                    <div class="label">
                                        <xsl:if test="$label!= ''"><xsl:value-of select="$label"/> |</xsl:if> <xsl:value-of select="$readMin"/> MIN READ</div>
                                </div>       
                            </xsl:if>
                        </xsl:for-each>
                        
                    </div>
                    
                    
                </div>   
                  
                <div class="col-lg-3 top-rated"> 
                    <div class="entry">
                        <h3>Top Rated</h3>
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/migrateWordToDita.html">
                            How to Migrate from Word to DITA
                        </a>
                        <!--<div class="date">17 May 2022</div>--><div><div class="label">MIGRATE | 5 MIN READ</div></div>
                        
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/learnDita.html">
                            Resources for learning DITA with Oxygen
                        </a>
                        <!--<div class="date">17 May 2022</div>--><div><div class="label">LEARN DITA | 4 MIN READ</div></div>
                        
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/migrating_to_dita.html">
                            Migrating Various Document Formats to DITA
                        </a>
                        <!--<div class="date">17 May 2022</div>--><div><div class="label">MIGRATE | 7 MIN READ</div></div>
                        
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/dita_for_small_teams.html">
                            DITA For Small Technical Documentation Teams
                            
                        </a>
                        <div class="date">21 Jan 2020</div><div><div class="label">LEARN DITA | 12 MIN READ</div></div>
                    </div>
                                        
                    <xsl:copy-of select="document('../html-fragments/follow-it.html')/div/div"/>
                    
                    
                    <div class="entry" id="quick_links">
                        <!--<h3>Follow us</h3>-->
                        <h3 class="followit">Follow us</h3>
                        
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
                    </div>
                    
                    
                </div>
                
              
            </div>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
