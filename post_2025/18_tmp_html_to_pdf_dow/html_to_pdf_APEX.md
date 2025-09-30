    // Get HTML content via AJAX y capturar
    apex.server.process('GET_HTML_CONTENT', {
        x01: documentId
    }, {
        success: function(data) {
            // Mostrar HTML en región
            document.getElementById('htmlContent').innerHTML = data.html_content;
            
            // Capturar y descargar
            captureAndDownloadHTML();
        },
        error: function() {
            alert('Error loading document content');
        }
    });

// CAPTURA DE HTML Y DESCARGA COMO IMAGEN
function captureAndDownloadHTML() {
    const htmlElement = document.getElementById('htmlContent');
    
    html2canvas(htmlElement).then(function(canvas) {
        // Descarga directa como imagen PNG
        const link = document.createElement('a');
        link.download = 'html_capture_' + new Date().getTime() + '.png';
        link.href = canvas.toDataURL();
        link.click();
    });
}

// OPCIÓN 1: PDF NATIVO CON WINDOW.PRINT()
function captureAndDownloadPDF_Print() {
    const htmlElement = document.getElementById('htmlContent');
    
    html2canvas(htmlElement).then(function(canvas) {
        const imgData = canvas.toDataURL('image/png');
        
        const printWindow = window.open('', '_blank');
        printWindow.document.write(`
            <html>
                <head>
                    <title>PDF Export</title>
                    <style>
                        @media print {
                            @page { margin: 0; }
                            body { margin: 0; }
                            img { width: 100%; height: auto; }
                        }
                    </style>
                </head>
                <body>
                    <img src="${imgData}" alt="HTML Content">
                </body>
            </html>
        `);
        
        printWindow.document.close();
        printWindow.focus();
        
        setTimeout(() => {
            printWindow.print();
            printWindow.close();
        }, 250);
    });
}

// OPCIÓN 2: PDF NATIVO CON BLOB Y DOWNLOAD
function captureAndDownloadPDF_Blob() {
    const htmlElement = document.getElementById('htmlContent');
    
    html2canvas(htmlElement).then(function(canvas) {
        const imgData = canvas.toDataURL('image/png');
        
        // Crear HTML con imagen
        const htmlContent = `
            <html>
                <head>
                    <title>PDF Export</title>
                    <style>
                        @page { margin: 0; }
                        body { margin: 0; }
                        img { width: 100%; height: auto; }
                    </style>
                </head>
                <body>
                    <img src="${imgData}" alt="HTML Content">
                </body>
            </html>
        `;
        
        // Crear blob con HTML
        const blob = new Blob([htmlContent], { type: 'text/html' });
        const url = URL.createObjectURL(blob);
        
        // Abrir en nueva ventana para imprimir
        const newWindow = window.open(url, '_blank');
        newWindow.onload = function() {
            newWindow.print();
        };
    });
}

// OPCIÓN 3: PDF NATIVO CON IFRAME OCULTO
function captureAndDownloadPDF_Iframe() {
    const htmlElement = document.getElementById('htmlContent');
    
    html2canvas(htmlElement).then(function(canvas) {
        const imgData = canvas.toDataURL('image/png');
        
        // Crear iframe oculto
        const iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        document.body.appendChild(iframe);
        
        iframe.contentDocument.write(`
            <html>
                <head>
                    <title>PDF Export</title>
                    <style>
                        @media print {
                            @page { margin: 0; }
                            body { margin: 0; }
                            img { width: 100%; height: auto; }
                        }
                    </style>
                </head>
                <body>
                    <img src="${imgData}" alt="HTML Content">
                </body>
            </html>
        `);
        
        iframe.contentDocument.close();
        
        // Imprimir
        setTimeout(() => {
            iframe.contentWindow.print();
            document.body.removeChild(iframe);
        }, 250);
    });
}

// OPCIÓN 4: jsPDF - DESCARGA AUTOMÁTICA
function captureAndDownloadPDF_jsPDF() {
    const htmlElement = document.getElementById('htmlContent');
    
    html2canvas(htmlElement).then(function(canvas) {
        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF();
        const imgData = canvas.toDataURL('image/png');
        
        const imgWidth = 210; // A4 width in mm
        const pageHeight = 295; // A4 height in mm
        const imgHeight = (canvas.height * imgWidth) / canvas.width;
        let heightLeft = imgHeight;
        
        let position = 0;
        pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
        
        while (heightLeft >= 0) {
            position = heightLeft - imgHeight;
            pdf.addPage();
            pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
        }
        
        // DESCARGA AUTOMÁTICA - SIN PASOS ADICIONALES
        pdf.save('html_capture_' + new Date().getTime() + '.pdf');
    });
}

 select html_content, document_name from html_documents

-- REGIÓN HTML EN APEX (vacía, se llena con AJAX)
<div id="htmlContent" style="border: 1px solid #ccc; padding: 20px; background: white; min-height: 200px;">
    <!-- El contenido HTML se carga aquí via AJAX -->
</div>

-- BOTONES PARA CAPTURAR
<button onclick="apex.server.process('GET_HTML_CONTENT', {x01: documentId}, {success: function(data) {document.getElementById('htmlContent').innerHTML = data.html_content; captureAndDownloadHTML();}})">Descargar como Imagen PNG</button>

<button onclick="apex.server.process('GET_HTML_CONTENT', {x01: documentId}, {success: function(data) {document.getElementById('htmlContent').innerHTML = data.html_content; captureAndDownloadPDF_jsPDF();}})">Descargar PDF Automático (jsPDF)</button>

-- LIBRERÍAS NECESARIAS (Agregar en HTML Header de APEX)
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

## CUADRO COMPARATIVO - SERVICIOS WEB HTML TO PDF

| Servicio | Licencia | Precio | Calidad | API | Límites | Recomendación |
|----------|----------|--------|---------|-----|---------|---------------|
| **jsPDF** | Gratuita | $0 | Media | ❌ | Sin límites | ✅ Para uso básico |
| **PDFShift** | Comercial | $9/mes | Alta | ✅ | 1000 PDFs/mes | ✅ Para producción |
| **DocRaptor** | Comercial | $25/mes | Excelente | ✅ | 1000 PDFs/mes | ✅ Para calidad alta |
| **HTML2PDF** | Gratuita | $0 | Baja | ❌ | Limitada | ⚠️ Solo pruebas |
| **PDFCrowd** | Comercial | $15/mes | Alta | ✅ | 1000 PDFs/mes | ✅ Buena relación calidad/precio |
| **wkhtmltopdf** | Gratuita | $0 | Alta | ❌ | Sin límites | ✅ Para servidor propio |

### RECOMENDACIÓN FINAL:
- **Para desarrollo**: jsPDF (gratuito, descarga automática)
- **Para producción**: PDFShift o PDFCrowd (buena calidad/precio)
- **Para máxima calidad**: DocRaptor (usa PrinceXML)