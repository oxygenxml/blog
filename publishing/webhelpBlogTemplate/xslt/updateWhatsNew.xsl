<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs toc blog" version="2.0"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
    xmlns:blog="http://www.oxygenxml.com/blog">

    <xsl:function name="blog:category" as="xs:string">
        <xsl:param name="topicref" as="element()"/>
        <xsl:variable name="outerHead" select="$topicref/ancestor::topichead[last()]"/>
        <xsl:variable name="raw" as="xs:string">
            <xsl:choose>
                <xsl:when test="$outerHead/@navtitle">
                    <xsl:value-of select="string($outerHead/@navtitle)"/>
                </xsl:when>
                <xsl:when test="$outerHead/topicmeta/navtitle">
                    <xsl:value-of select="normalize-space(string($outerHead/topicmeta/navtitle))"/>
                </xsl:when>
                <xsl:when test="$topicref/ancestor-or-self::topicref[@keys = 'migrate']">Migrate</xsl:when>
                <xsl:when test="$topicref/ancestor-or-self::topicref[@keys = 'sdk']">SDK</xsl:when>
                <xsl:when test="$topicref/ancestor-or-self::topicref[@keys = 'learning']">DITA</xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="mapTitle"
                        select="normalize-space(string(($topicref/topicmeta/navtitle, $topicref/topicmeta/linktext)[1]))"/>
                    <xsl:choose>
                        <xsl:when test="$mapTitle != ''">
                            <xsl:value-of select="$mapTitle"/>
                        </xsl:when>
                        <xsl:when test="not($topicref/ancestor::topichead | $topicref/ancestor::topicref[@href])">
                            <xsl:value-of select="normalize-space(string((document(resolve-uri($topicref/@href, base-uri($topicref)))//title)[1]))"/>
                        </xsl:when>
                        <xsl:otherwise>Miscellaneous</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence
            select="if (contains($raw, 'Artificial intelligence')) then 'AI'
                    else if ($raw = 'DITA Articles') then 'DITA'
                    else $raw"/>
    </xsl:function>

    <xsl:function name="blog:slug" as="xs:string">
        <xsl:param name="label" as="xs:string"/>
        <xsl:sequence
            select="lower-case(replace(replace(normalize-space($label), '[^A-Za-z0-9]+', '-'), '^-|-$', ''))"/>
    </xsl:function>

    <xsl:template name="render-post-entry">
        <xsl:variable name="doc" select="document(resolve-uri(@href, base-uri()))"/>
        <xsl:variable name="cd" select="($doc//prolog)[1]/critdates/created/@date"/>
        <xsl:variable name="prolog" select="($doc//prolog)[1]"/>
        <xsl:variable name="avatar-author" select="replace($prolog/author, ' ', '_')"/>
        <xsl:variable name="label" select="$prolog/metadata/keywords/keyword[@outputclass = 'label']"/>
        <xsl:variable name="fileUrl" select="replace(@href, '\.dita$', '.html')"/>
        <xsl:variable name="fileContent" select="$doc/*"/>
        <xsl:variable name="x" select="normalize-space($fileContent)"/>
        <xsl:variable name="y" select="translate($x, ' ', '')"/>
        <xsl:variable name="fileCountWords" select="string-length($x) - string-length($y) + 1"/>
        <xsl:variable name="readMin" select="format-number($fileCountWords div 100, '0')"/>
        <xsl:variable name="category" select="blog:category(.)"/>
        <div class="entry" data-topic="{blog:slug($category)}" data-topic-label="{$category}">
            <div class="author {$avatar-author}">
                <a href="topics/contributors.html">
                    <xsl:value-of select="$prolog/author"/>
                </a>
            </div>
            <a class="title" href="{$fileUrl}">
                <xsl:value-of select="($doc//title)[1]"/>
            </a>
            <div class="date">
                <xsl:value-of select="format-date(xs:date($cd), '[D] [MNn,3-3] [Y0001]')"/>
            </div>
            <div class="label">
                <xsl:if test="$label != ''">
                    <xsl:value-of select="$label"/>
                    <xsl:text> |</xsl:text>
                </xsl:if>
                <xsl:value-of select="$readMin"/>
                <xsl:text> MIN READ</xsl:text>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="/">
        <xsl:next-match/>

        <xsl:variable name="postRefs" as="element()*">
            <xsl:for-each-group
                select="//topicref[@href]
                    [not(ancestor::reltable)]
                    [not(@processing-role = 'resource-only')]
                    [not(@format) or @format = 'dita']
                    [not(contains(@href, 'contributors.dita'))]
                    [doc-available(resolve-uri(@href, base-uri()))]
                    [(document(resolve-uri(@href, base-uri()))//prolog)[1]/critdates/created/@date]"
                group-by="@href">
                <xsl:sequence select="."/>
            </xsl:for-each-group>
        </xsl:variable>

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

                    <div class="browse-by-topics" id="browse-by-topics">
                        <h3>Browse by Topics</h3>
                        <div class="topic-pills" role="tablist" aria-label="Browse by topics">
                            <button type="button" class="topic-pill is-active" data-topic="all" role="tab" aria-selected="true">All Posts</button>
                            <xsl:for-each-group select="$postRefs" group-by="blog:category(.)">
                                <button type="button" class="topic-pill" data-topic="{blog:slug(current-grouping-key())}" role="tab" aria-selected="false">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </button>
                            </xsl:for-each-group>
                        </div>
                    </div>

                    <div class="banner stripe-latest-posts stripe-all-posts posts-pending" id="all-posts">
                        <h3 class="all-posts-heading">All Posts</h3>
                        <div class="all-posts-grid">
                            <xsl:for-each select="$postRefs">
                                <xsl:sort
                                    select="(document(resolve-uri(@href, base-uri()))//prolog)[1]/critdates/created/@date"
                                    order="descending"/>
                                <xsl:call-template name="render-post-entry"/>
                            </xsl:for-each>
                        </div>
                        <nav class="posts-pagination" aria-label="Posts pagination"/>
                    </div>
                </div>

                <div class="col-lg-3 top-rated">
                    <div class="entry">
                        <h3>Top Rated</h3>
                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/migrateWordToDita.html">
                            How to Migrate from Word to DITA
                        </a>
                        <div><div class="label">MIGRATE | 5 MIN READ</div></div>

                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/learnDita.html">
                            Resources for learning DITA with Oxygen
                        </a>
                        <div><div class="label">LEARN DITA | 4 MIN READ</div></div>

                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/migrating_to_dita.html">
                            Migrating Various Document Formats to DITA
                        </a>
                        <div><div class="label">MIGRATE | 7 MIN READ</div></div>

                        <div class="author Radu_Coravu"><a href="topics/contributors.html">Radu Coravu</a></div>
                        <a class="title" href="/topics/dita_for_small_teams.html">
                            DITA For Small Technical Documentation Teams
                        </a>
                        <div class="date">21 Jan 2020</div><div><div class="label">LEARN DITA | 12 MIN READ</div></div>
                    </div>

                    <xsl:copy-of select="document('../html-fragments/follow-it.html')/div/div"/>

                    <div class="entry" id="quick_links">
                        <h3 class="followit">Follow us</h3>

                        <div>Quick question, are you following us on our socials? We are constantly sharing product news and promotions on our social media, click the links below to follow your favourites!</div>
                        <div>
                            <a href="https://www.facebook.com/syncrosoftsrl" class="lk-facebook" title="Facebook" target="_blank">
                                <img src="./oxygen-webhelp/template/resources/images/facebook.png"/>
                            </a>
                            <a href="https://www.youtube.com/user/oxygenxml" class="lk-youtube" title="Youtube Channel" target="_blank">
                                <img src="./oxygen-webhelp/template/resources/images/youtube.png"/>
                            </a>
                            <a href="http://twitter.com/oxygenxml" class="lk-twitter" title="Twitter" target="_blank">
                                <img src="./oxygen-webhelp/template/resources/images/twitter.png"/>
                            </a>
                            <a href="https://www.linkedin.com/company/syncro-soft" class="lk-linkedin" title="Linkedin" target="_blank">
                                <img src="./oxygen-webhelp/template/resources/images/linkedin.png"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
