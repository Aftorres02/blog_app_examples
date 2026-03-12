-- =============================================================================
-- invg_invoice_api - Invoice Generator API (spec)
-- =============================================================================
-- get_invoices, get_invoice, delete_invoice, get_next_invoice_number.
-- Insert/update handled by APEX native DML.
-- =============================================================================

create or replace package invg_invoice_api
as

  /**
   * Renders a full invoice as an HTML document fragment ready for display
   * in an APEX region and for printing via window.print().
   *
   * @author Angel Flores (Consultant)
   * @created Wednesday, 11/Mar/2026
   *
   * @param p_invoice_id invg_invoice_id
   * @return clob HTML string (div.invoice-doc with all sections)
   */
  function render_invoice_html(
    p_invoice_id in invg_invoices.invg_invoice_id%type
  )
  return clob;

end invg_invoice_api;
/
