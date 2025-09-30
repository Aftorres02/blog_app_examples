# Methods to Convert HTML to PDF in Oracle APEX

Converting HTML content to PDF is a common requirement in web applications. This blog post demonstrates three different approaches to achieve this in Oracle APEX applications, each with its own advantages and use cases.

**🔗 [Live Demo](https://oracleapex.com/ords/f?p=32431:1210:102704750023317:::::)**

## Overview of Methods

- **Method 1: jsPDF with Fixed Dimensions** - Simple, predictable PDF generation with predefined page sizes
- **Method 2: jsPDF with Dynamic Scaling** - Intelligent content adaptation with automatic orientation and scaling
- **Method 3: Browser Print Method** - Leverages browser's native PDF generation capabilities

## Database Setup

First, create the table to store HTML documents. For the complete DDL script, see [html_tmp_table.sql](html_tmp_table.sql).

## Required Libraries

Add these libraries to your APEX page (Page > JavaScript > File URLs):

```
https://github.com/Aftorres02/blog_app_examples/tree/master/post_2025/18_tmp_html_to_pdf_dow/libs
```

**Library References:**
- **jsPDF Documentation**: [https://github.com/parallax/jsPDF](https://github.com/parallax/jsPDF)
- **html2canvas Documentation**: [https://github.com/niklasvh/html2canvas](https://github.com/niklasvh/html2canvas)
- **Oracle APEX Documentation**: [https://docs.oracle.com/en/database/oracle/application-express/](https://docs.oracle.com/en/database/oracle/application-express/)

## APEX Process

Create an AJAX process named `GET_HTML_CONTENT`:

```sql
declare
    l_html_content clob;
    l_document_id number;
begin
    l_document_id := apex_application.g_x01;
    
    select html_content, document_name
    into l_html_content, :P1210_DOCUMENT_NAME
    from html_documents
    where id = l_document_id
    and active_yn = 'Y';
    
    apex_json.open_object;
    apex_json.write('html_content', l_html_content);
    apex_json.write('document_name', :P1210_DOCUMENT_NAME);
    apex_json.close_object;
    
exception
    when no_data_found then
        apex_json.open_object;
        apex_json.write('error', 'Document not found');
        apex_json.close_object;
end;
```

## Method 1: jsPDF with Fixed Dimensions

**What it does:** Creates a PDF with predefined dimensions (900x630 points) and converts HTML content directly to PDF format. This method provides good control over page size but may not automatically adjust to content dimensions.

```javascript
apex.server.process(
  "GET_HTML_CONTENT",
  {
    x01: apex.item("P1210_DOCUMENT_ID").getValue(),
  },
  {
    success: function (data) {
      var doc = new jspdf.jsPDF("p", "pt", [900, 630]);

      doc.html(data.html_content, {
        callback: function (doc) {
          if (doc.getNumberOfPages() >= 2) {
            doc.deletePage(2);
          }
          var filename = data.document_name;
          doc.save(filename + ".pdf");
        },

        // Set the rendering starting point and size
        x: 0,
        y: 0,
        margin: 20,
        width: 590, // FULL width of the page in points
        windowWidth: 590, // Optional: helps html2canvas understand layout

        html2canvas: {
          useCORS: true,
          allowTaint: true,
          scale: 1, // Adjust this for quality vs performance
        },
      });
    },
    error: function () {
      alert("Error loading document content");
    },
  }
);
```

## Method 2: jsPDF with Dynamic Orientation and Scaling

**What it does:** Automatically detects content dimensions and chooses the best orientation (portrait/landscape) and scaling factor to fit the content perfectly within the PDF page. This method provides the most intelligent content adaptation.

```javascript
apex.server.process(
  "GET_HTML_CONTENT",
  {
    x01: apex.item("P1210_DOCUMENT_ID").getValue(),
  },
  {
    success: function (data) {
      // Create a hidden container dynamically
      let tempContainer = document.createElement("div");
      tempContainer.id = "htmlContentHidden";
      document.body.appendChild(tempContainer);

      // Insert HTML content
      tempContainer.innerHTML = data.html_content;

      // Measure content dimensions
      const contentWidth = tempContainer.scrollWidth;
      const contentHeight = tempContainer.scrollHeight;

      // Decide orientation based on aspect ratio
      let orientation = contentWidth > contentHeight ? "l" : "p";

      // Init jsPDF with dynamic orientation
      const { jsPDF } = window.jspdf;
      let doc = new jsPDF(orientation, "pt", "a4");

      // Get actual page dimensions from jsPDF
      const pageWidth = doc.internal.pageSize.getWidth();
      const pageHeight = doc.internal.pageSize.getHeight();

      // Calculate scale so content fits into page width (max = 1)
      const scaleFactor = Math.min((pageWidth - 40) / contentWidth, 1);

      // Generate PDF
      doc.html(tempContainer, {
        callback: function (doc) {
          doc.save("dynamic_fit.pdf");
          // Clean up
          document.body.removeChild(tempContainer);
        },
        x: 20,
        y: 20,
        width: pageWidth - 40, // usable width with margins
        windowWidth: contentWidth, // original HTML width
        html2canvas: {
          scale: scaleFactor,
          useCORS: true,
          allowTaint: true,
        },
      });
    },
    error: function () {
      alert("Error loading document content");
    },
  }
);
```

## Method 3: Browser Print Method

**What it does:** Opens the HTML content in a new browser window and triggers the browser's native print dialog, allowing users to save as PDF using their browser's built-in PDF functionality. This method leverages the browser's native PDF generation capabilities.

```javascript
apex.server.process(
  "GET_HTML_CONTENT",
  {
    x01: apex.item("P1210_DOCUMENT_ID").getValue(),
  },
  {
    success: function (data) {
      var printWindow = window.open('', '_blank', 'width=800,height=600');
      printWindow.document.write('<!DOCTYPE html>');
      printWindow.document.write('<html><head><title>Document</title>');
      printWindow.document.write('<style>body{font-family:Arial,sans-serif;margin:20px;}</style>');
      printWindow.document.write('</head><body>');
      printWindow.document.write(data.html_content);
      printWindow.document.write('</body></html>');
      printWindow.document.close();

      setTimeout(function() {
          printWindow.print();
          setTimeout(function() {
              printWindow.close();
          }, 1000);
      }, 500);
    },
    error: function () {
      alert("Error loading document content");
    },
  }
);
```

## Comparison of Methods

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| **Method 1: Fixed Dimensions** | Simple, predictable output | May not fit all content | Standard documents |
| **Method 2: Dynamic Scaling** | Intelligent content adaptation | More complex code | Variable content sizes |
| **Method 3: Browser Print** | No external libraries needed | Requires user interaction | Simple implementations |

---
