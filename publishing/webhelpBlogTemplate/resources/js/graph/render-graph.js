define([ "jquery",
"./vis-network.min"], function ($, vis) {
    var container = document.getElementById("mynetwork");
    if (container != null) {
        
        
        
        var nodes = new vis.DataSet([ {
            id: 1, label: "Welcome to the Oxygen XML Editor Blog !"
        }, {
            id: 2, label: "Resources for learning DITA with Oxygen"
        }, {
            id: 3, label: "Using DITA to Document a Software Product"
        }, {
            id: 4, label: "Guided DITA Authoring Solution Overview"
        }, {
            id: 5, label: "Maintaining a Healthy DITA Project"
        }, {
            id: 6, label: "DITA Linking Strategies"
        }, {
            id: 7, label: "DITA 1.3 Branch Filtering - Next Generation of Reuse"
        }, {
            id: 8, label: "DITA 1.3 Key Scopes - Next Generation of Reuse"
        }, {
            id: 9, label: "DITA Reuse Strategies"
        }, {
            id: 10, label: "Introduction"
        }, {
            id: 11, label: "Version Control and Reuse"
        }, {
            id: 12, label: "Converting XML content to various output formats"
        }, {
            id: 13, label: "Create larger publications from existing ones"
        }, {
            id: 14, label: "Reuse content for similar products"
        }, {
            id: 15, label: "Reuse fragments of content"
        }, {
            id: 16, label: "Content References"
        }, {
            id: 17, label: "Content Key References"
        }, {
            id: 18, label: "Content Reference Ranges"
        }, {
            id: 19, label: "Content Reuse Tips and Tricks"
        }, {
            id: 20, label: "Pushing Content"
        }, {
            id: 21, label: "Key References (Variables)"
        }, {
            id: 22, label: "DITA 1.3 Contributions to Reuse"
        }, {
            id: 23, label: "Reuse with Key Scopes"
        }, {
            id: 24, label: "Reuse with Branch Filtering"
        }, {
            id: 25, label: "Reuse non-DITA resources"
        }, {
            id: 26, label: "Conclusions"
        }, {
            id: 27, label: "DITA to Confluence"
        }, {
            id: 28, label: "Generating a list of changes between releases"
        }, {
            id: 29, label: "Migrating DITA Open Toolkit PDF Customizations"
        }, {
            id: 30, label: "DITA Publishing Customization Overview"
        }, {
            id: 31, label: "DITA Open Toolkit Frequently Asked Questions (FAQ)"
        }, {
            id: 32, label: "Enhancing DITA Publishing With Plugins"
        }, {
            id: 33, label: "Possibilities to obtain PDF from DITA"
        }, {
            id: 34, label: "DITA PDF publishing - Force page breaks between two block elements"
        }, {
            id: 35, label: "Adding support for embedding LaTeX equations in DITA content"
        }, {
            id: 36, label: "Useful DITA OT Plugins"
        }, {
            id: 37, label: "DITA OT PDF Customization - Table with Alternate Row Background Colors"
        }, {
            id: 38, label: "Creating a simple DITA Open Toolkit plugin to customize published HTML and PDF content"
        }, {
            id: 39, label: "Using Git client-side hooks to run DITA publishing pipelines"
        }, {
            id: 40, label: "Startup DITA Project"
        }, {
            id: 41, label: "Customizing the DITA Visual Editing Experience"
        }, {
            id: 42, label: "Customizing the DITA Framework Using a Framework Extension Script"
        }, {
            id: 43, label: "Controlled Attribute Values for your DITA Project"
        }, {
            id: 44, label: "Controlled Attribute Values (Part 2 - Advanced)"
        }, {
            id: 45, label: "Converting Subject Scheme Map Values to a DITAVAL"
        }, {
            id: 46, label: "DITA For Small Technical Documentation Teams"
        }, {
            id: 47, label: "Oxygen XML Editor DITA Editing solution strong points."
        }, {
            id: 48, label: "DITA 1.3 Support in Upcoming Oxygen XML Editor 17.1"
        }, {
            id: 49, label: "Oxygen XML Editor - DITA Oriented Tips And Tricks"
        }, {
            id: 50, label: "DITA Project Enhancements"
        }, {
            id: 51, label: "Small Problems with the DITA Standard"
        }, {
            id: 52, label: "DITA Linking Usage Survey"
        }, {
            id: 53, label: "DITA Inheritance Hierarchy"
        }, {
            id: 54, label: "DITA Usage Survey"
        }, {
            id: 55, label: "Replacing Direct Image References with Key References in a DITA Project."
        }, {
            id: 56, label: "Translating your DITA Project"
        }, {
            id: 57, label: "DITA Map Validate and Check for Completeness Overview"
        }, {
            id: 58, label: "Schematron Checks to help Technical Writing"
        }, {
            id: 59, label: "Implementing your own Style Guide"
        }, {
            id: 60, label: "Sorting Glossary Lists in a DITA Bookmap"
        }, {
            id: 61, label: "Embedding Diagrams in DITA topics using PlantUML"
        }, {
            id: 62, label: "Migrating to a Structured Standards-based Documentation Solution"
        }, {
            id: 63, label: "Migrating Various Document Formats to DITA"
        }, {
            id: 64, label: "How to Migrate from Word to DITA"
        }, {
            id: 65, label: "Batch converting HTML to XHTML"
        }, {
            id: 66, label: "Customizing Oxygen XML Editor (Overview)"
        }, {
            id: 67, label: "Document Type Extension Sharing"
        }, {
            id: 68, label: "Sharing Schematron Validation Rules"
        }, {
            id: 69, label: "Public hosted Oxygen Plugin and Framework Projects"
        }, {
            id: 70, label: "Sharing New Custom File Templates for a Specific Vocabulary"
        }, {
            id: 71, label: "Composing Author Actions"
        }, {
            id: 72, label: "Implementing a Custom Author Action to Split a Table"
        }, {
            id: 73, label: "Adding a Custom Author Action to the Content Completion Window"
        }, {
            id: 74, label: "How Special Paste works in Oxygen"
        }, {
            id: 75, label: "The Oxygen SDK (Part 1: Plugins)"
        }, {
            id: 76, label: "The Oxygen SDK (Part 2: Frameworks)"
        }, {
            id: 77, label: "Your First Oxygen Add-on"
        }, {
            id: 78, label: "Oxygen Add-ons Overview"
        }, {
            id: 79, label: "Adding CALS-table related functionality to your custom Oxygen framework"
        }, {
            id: 80, label: "Convert Code Templates to External Author Actions"
        }, {
            id: 81, label: "Tips And Tricks"
        }, {
            id: 82, label: "Checking Terminology with Oxygen XML Editor"
        }, {
            id: 83, label: "Opinions about using Oxygen"
        }, {
            id: 84, label: "A set of rules for providing great tech support"
        }, {
            id: 85, label: "A Short Story of Reuse"
        }, {
            id: 86, label: "Sharing Application Settings"
        }, {
            id: 87, label: "Collaboration for Documenting a Software Product using DITA"
        }, {
            id: 88, label: "Collaboration (Teams working on a common XML project)"
        }, {
            id: 89, label: "Enable massive contributions with oXygen XML Web Author and GitHub"
        }, {
            id: 90, label: "All About Editor Variables"
        }, {
            id: 91, label: "XSLT Training"
        },]);
        
        var edges = new vis.DataSet([ {
            from: 2, to: 1, arrows: "to"
        }, {
            from: 5, to: 1, arrows: "to"
        }, {
            from: 46, to: 1, arrows: "to"
        }, {
            from: 4, to: 2, arrows: "to"
        }, {
            from: 46, to: 2, arrows: "to"
        }, {
            from: 47, to: 4, arrows: "to"
        }, {
            from: 5, to: 6, arrows: "to"
        }, {
            from: 24, to: 7, arrows: "to"
        }, {
            from: 6, to: 8, arrows: "to"
        }, {
            from: 23, to: 8, arrows: "to"
        }, {
            from: 5, to: 9, arrows: "to"
        }, {
            from: 6, to: 9, arrows: "to"
        }, {
            from: 62, to: 9, arrows: "to"
        }, {
            from: 2, to: 33, arrows: "to"
        }, {
            from: 31, to: 33, arrows: "to"
        }, {
            from: 54, to: 33, arrows: "to"
        }, {
            from: 62, to: 33, arrows: "to"
        }, {
            from: 30, to: 36, arrows: "to"
        }, {
            from: 30, to: 38, arrows: "to"
        }, {
            from: 31, to: 38, arrows: "to"
        }, {
            from: 37, to: 38, arrows: "to"
        }, {
            from: 4, to: 41, arrows: "to"
        }, {
            from: 40, to: 41, arrows: "to"
        }, {
            from: 49, to: 41, arrows: "to"
        }, {
            from: 66, to: 41, arrows: "to"
        }, {
            from: 71, to: 41, arrows: "to"
        }, {
            from: 72, to: 41, arrows: "to"
        }, {
            from: 73, to: 41, arrows: "to"
        }, {
            from: 4, to: 43, arrows: "to"
        }, {
            from: 44, to: 43, arrows: "to"
        }, {
            from: 45, to: 43, arrows: "to"
        }, {
            from: 57, to: 43, arrows: "to"
        }, {
            from: 59, to: 43, arrows: "to"
        }, {
            from: 46, to: 49, arrows: "to"
        }, {
            from: 5, to: 56, arrows: "to"
        }, {
            from: 46, to: 56, arrows: "to"
        }, {
            from: 4, to: 57, arrows: "to"
        }, {
            from: 4, to: 58, arrows: "to"
        }, {
            from: 5, to: 58, arrows: "to"
        }, {
            from: 40, to: 58, arrows: "to"
        }, {
            from: 47, to: 58, arrows: "to"
        }, {
            from: 57, to: 58, arrows: "to"
        }, {
            from: 59, to: 58, arrows: "to"
        }, {
            from: 62, to: 58, arrows: "to"
        }, {
            from: 68, to: 58, arrows: "to"
        }, {
            from: 4, to: 59, arrows: "to"
        }, {
            from: 4, to: 62, arrows: "to"
        }, {
            from: 4, to: 64, arrows: "to"
        }, {
            from: 36, to: 64, arrows: "to"
        }, {
            from: 4, to: 67, arrows: "to"
        }, {
            from: 41, to: 67, arrows: "to"
        }, {
            from: 59, to: 67, arrows: "to"
        }, {
            from: 66, to: 67, arrows: "to"
        }, {
            from: 68, to: 67, arrows: "to"
        }, {
            from: 70, to: 67, arrows: "to"
        }, {
            from: 77, to: 67, arrows: "to"
        }, {
            from: 86, to: 67, arrows: "to"
        }, {
            from: 4, to: 68, arrows: "to"
        }, {
            from: 46, to: 68, arrows: "to"
        }, {
            from: 66, to: 68, arrows: "to"
        }, {
            from: 77, to: 69, arrows: "to"
        }, {
            from: 78, to: 69, arrows: "to"
        }, {
            from: 4, to: 70, arrows: "to"
        }, {
            from: 49, to: 70, arrows: "to"
        }, {
            from: 66, to: 70, arrows: "to"
        }, {
            from: 68, to: 70, arrows: "to"
        }, {
            from: 81, to: 70, arrows: "to"
        }, {
            from: 90, to: 70, arrows: "to"
        }, {
            from: 46, to: 72, arrows: "to"
        }, {
            from: 73, to: 72, arrows: "to"
        }, {
            from: 90, to: 72, arrows: "to"
        }, {
            from: 64, to: 74, arrows: "to"
        }, {
            from: 66, to: 75, arrows: "to"
        }, {
            from: 76, to: 75, arrows: "to"
        }, {
            from: 77, to: 75, arrows: "to"
        }, {
            from: 4, to: 76, arrows: "to"
        }, {
            from: 41, to: 76, arrows: "to"
        }, {
            from: 42, to: 76, arrows: "to"
        }, {
            from: 66, to: 76, arrows: "to"
        }, {
            from: 68, to: 76, arrows: "to"
        }, {
            from: 74, to: 76, arrows: "to"
        }, {
            from: 78, to: 77, arrows: "to"
        }, {
            from: 5, to: 82, arrows: "to"
        }, {
            from: 46, to: 82, arrows: "to"
        }, {
            from: 12, to: 85, arrows: "to"
        }, {
            from: 4, to: 86, arrows: "to"
        }, {
            from: 66, to: 86, arrows: "to"
        }, {
            from: 4, to: 87, arrows: "to"
        }, {
            from: 30, to: 87, arrows: "to"
        }, {
            from: 58, to: 87, arrows: "to"
        }, {
            from: 62, to: 87, arrows: "to"
        }, {
            from: 4, to: 88, arrows: "to"
        }, {
            from: 46, to: 90, arrows: "to"
        }, {
            from: 73, to: 90, arrows: "to"
        }, {
            from: 81, to: 90, arrows: "to"
        },]);
        // create a network
        
        var data = {
            nodes: nodes,
            edges: edges,
        };
        var options = {
            nodes: {
                shape: 'box',
                widthConstraint: 200,
            }
        };
        var network = new vis.Network(container, data, options);
    }
});