<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="*[contains(@class, ' topic/xref ') or contains(@class, ' topic/link ')][@href]">
            <sch:report test="@href = text()">
                Should have link text different than link target.
            </sch:report>
        </sch:rule>
        <sch:rule context="*[contains(@class, ' topic/xref ') or contains(@class, ' topic/link ')][contains(@href, 'blog.oxygenxml.com')]">
            <sch:assert test="@href = 'https://blog.oxygenxml.com/'">
                There should be no direct links to blog posts, link directly to DITA topics.
            </sch:assert>
        </sch:rule>
        <sch:rule context="*[contains(@class, ' topic/xref ') or contains(@class, ' topic/link ')][contains(@href, 'www.oxygenxml.com/doc/')]">
            <sch:assert test="not(contains(@href, 'doc/versions/'))">
                All links to the user's guide must be to the latest version, so the version number must not be included in the link.
            </sch:assert>
            <sch:assert test="not(contains(@href, 'http:'))">
                All links to the user's guide must be using the https protocol.
            </sch:assert>
        </sch:rule>
        <sch:rule context="*[contains(@class, ' topic/image ')]">
            <sch:assert test="not(@scope = 'external'  and not(contains(@href, 'www.oxygenxml.com')))">
                Should refer only to internal images
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>