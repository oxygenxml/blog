# AI Context Instructions for Oxygen XML Blog Project

## Project Overview

This is the **Oxygen XML Blog** - a technical blog about XML editing, DITA XML documentation, and the Oxygen XML Editor ecosystem. The blog is stored as DITA XML content in a GitHub repository and published as WebHelp Responsive, PDF, and EPUB outputs using the DITA Open Toolkit.

**Main DITA Map**: `oxygen_xml_blog.ditamap`  
**Project File**: `blog-project.xml` (DITA-OT project format)  
**Framework**: DITA 1.3 with custom extension (`frameworks/dita-extension/dita-blog.exf`)

## Content Architecture

### Topic Organization
- **Primary topics location**: `topics/` directory
- **Submaps**: Organized in `maps/` directory (e.g., `dita-articles.ditamap`, `sdk-development-plugins-frameworks-map.ditamap`)
- **Reusable content**: `reuse/` directory
- **Images**: `images/` directory
- **Key definitions**: `maps/key_definitions.ditamap`
- **Classification**: Subject scheme maps in `classification/` directory

### Topic Types
Standard DITA topic types are used:
- **Topic** (general articles)
- **Concept** (explanatory content)
- **Task** (procedural content)
- **Reference** (reference information)

### Naming Conventions
- **File names**: Use lowercase with underscores (e.g., `ai_positron.dita`, `customizing_ai_positron_for_your_dita_xml_project.dita`)
- **Topic IDs**: Match the filename without extension (e.g., `id="ai_positron"`)
- **Descriptive names**: File names should clearly indicate content (e.g., `migrating_word_to_dita_bdc/preparing_word_document_for_migration.dita`)

## Required Metadata Structure

Every new topic MUST include a `<prolog>` section with:

```xml
<prolog>
    <author>Author Name</author>
    <critdates>
        <created date="YYYY-MM-DD"/>
    </critdates>
</prolog>
```

**Optional but recommended metadata**:
- `<shortdesc>` - Brief description (1-2 sentences) immediately after `<title>`
- `<metadata><keywords><indexterm>` - For search indexing
- `<metadata><keywords><keyword>` - For tagging and classification

**Example**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">
<topic id="topic_id">
    <title>Topic Title</title>
    <shortdesc>Brief description of the topic content.</shortdesc>
    <prolog>
        <author>Radu Coravu</author>
        <critdates>
            <created date="2024-05-31"/>
        </critdates>
        <metadata>
            <keywords>
                <indexterm>Main term<indexterm>Sub-term</indexterm></indexterm>
                <keyword>Related keyword</keyword>
            </keywords>
        </metadata>
    </prolog>
    <body>
        <!-- Content here -->
    </body>
</topic>
```

## Content Guidelines

### Audience
- **Primary**: Technical writers, documentation specialists, XML developers
- **Secondary**: Content creators, software developers using XML technologies
- **Tone**: Professional, informative, tutorial-oriented
- **Expertise level**: Intermediate to advanced (assumes basic XML/DITA knowledge)

### Writing Style
- Use **active voice** whenever possible
- Keep sentences clear and concise
- Provide practical examples and code samples
- Include links to official documentation when referencing Oxygen features
- Use `<xref>` elements for cross-references with `format="html"` and `scope="external"` for external links

### Common Elements Usage
- **Bold** (`<b>`): Emphasize UI elements, important terms, product names
- **Code** (`<codeph>`): Inline code, element names, attribute names, file names
- **Code blocks** (`<codeblock>`): Multi-line code samples, XML examples
- **UI Control** (`<uicontrol>`): Menu items, button names, dialog box names
- **Cross-references** (`<xref>`): Links to other topics or external resources
- **Key references** (`<ph keyref="oxygen">`): Use for "Oxygen XML Editor" (defined in `maps/key_definitions.ditamap`)

### Link Patterns
External links to Oxygen documentation:
```xml
<xref href="https://www.oxygenxml.com/doc/ug-editor/topics/..." format="html" scope="external">Link text</xref>
```

Internal cross-references:
```xml
<xref href="other_topic.dita"/>
```

### Code Sample Formatting
Use `outputclass="language-xml"` for XML code blocks:
```xml
<codeblock outputclass="language-xml">&lt;element>content&lt;/element></codeblock>
```

## Key Definitions

Use these key references in content:
- `<ph keyref="oxygen"/>` → "Oxygen XML Editor"
- `<ph keyref="webauthor"/>` → "WebAuthor"

## Subject Classification

Topics can be classified using the subject scheme defined in `classification/blog-subject-scheme.ditamap`:
- `blog-dita` - DITA XML topics
  - `blog-dita-learning` - Learning resources
  - `blog-dita-publishing` - Publishing customizations
  - `blog-dita-customizing` - Editing customizations
- `blog-migrate` - Migration topics
- `blog-sdk` - SDK/Plugin/Framework development

## Validation Rules

1. **All topics must be valid DITA 1.3**
2. **Include DOCTYPE declaration**: `<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">`
3. **Prolog with author and created date is mandatory**
4. **Use proper element nesting** according to DITA specification
5. **External links must include `format="html"` and `scope="external"`**
6. **Image references should use relative paths** from the topic location

## Custom Framework Features

The project uses a custom DITA extension framework (`dita-blog.exf`) that includes:
- Custom CSS styling (`frameworks/dita-extension/css/custom.css`)
- Custom Schematron validation rules (`frameworks/dita-extension/schematron/`)
- Custom dictionaries for spell checking (`frameworks/dita-extension/dicts/`)

## Publishing Configuration

- **Output formats**: WebHelp Responsive (primary), PDF, EPUB
- **Publishing template**: `publishing/webhelpBlogTemplate/`
- **Build system**: DITA-OT with Gradle build script
- **Deployment**: GitHub Actions for validation, Netlify for hosting

## AI-Specific Considerations

### When Creating New Topics:
1. Place in `topics/` directory with descriptive filename
2. Include complete prolog with author and date
3. Add shortdesc for better search/navigation
4. Use appropriate topic type (topic, concept, task, reference)
5. Include indexterms for searchability
6. Follow existing naming patterns

### When Editing Existing Topics:
1. Preserve existing structure and metadata
2. Maintain consistent formatting with project style
3. Keep DOCTYPE and topic ID unchanged
4. Update only the content body unless metadata changes are needed

### When Adding Cross-References:
1. Use relative paths for internal links
2. Include proper attributes for external links
3. Verify target topics exist in the project
4. Use key references where defined

## Common Topic Patterns

### AI/Positron Topics
Topics about AI features typically include:
- Installation and licensing overview
- Feature descriptions with examples
- Links to official documentation
- Practical use cases and workflows
- Code samples showing XPath functions or custom actions

### Migration Topics
Migration articles typically include:
- Source format description
- Step-by-step procedures
- Tool recommendations
- Best practices and tips
- Before/after examples

### SDK/Development Topics
Development topics typically include:
- Technical prerequisites
- Code samples (Java, XSLT, XQuery)
- API references
- Framework extension examples
- Plugin development patterns

## File References

When referencing project files in content:
- Use `${pd}` for project directory variable
- Use `${pdu}` for project directory URL variable
- Use relative paths from topic location for images and other resources

## Quality Standards

- **Completeness**: Topics should be self-contained with sufficient context
- **Accuracy**: Verify all technical details and code samples
- **Clarity**: Use clear headings, lists, and structure
- **Examples**: Include practical examples where applicable
- **Links**: Ensure all external links are valid and use HTTPS
- **Consistency**: Follow established patterns from existing topics

---

**Last Updated**: Generated for AI Positron Assistant configuration  
**Project Repository**: https://github.com/oxygenxml/blog
