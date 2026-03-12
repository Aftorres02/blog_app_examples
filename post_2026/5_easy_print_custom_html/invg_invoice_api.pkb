-- =============================================================================
-- invg_invoice_api - Invoice Generator API (body)
-- =============================================================================

create or replace package body invg_invoice_api
as

  gc_scope_prefix constant varchar2(31 char) := lower($$plsql_unit) || '.';

  -- ---------------------------------------------------------------------------
  -- render_invoice_html
  -- ---------------------------------------------------------------------------
  function render_invoice_html(
    p_invoice_id in invg_invoices.invg_invoice_id%type
  )
  return clob
  is
    -- l_scope  logger_logs.scope%type := gc_scope_prefix || 'render_invoice_html';
    -- l_params logger.tab_param;

    l_html                  clob;

    l_invoice_number        invg_invoices.invoice_number%type;
    l_issue_date            invg_invoices.issue_date%type;
    l_include_due_date_yn   invg_invoices.include_due_date_yn%type;
    l_due_date              invg_invoices.due_date%type;
    l_payment_terms         invg_invoices.payment_terms%type;
    l_tax_rate              invg_invoices.tax_rate%type;
    l_other_amount          invg_invoices.other_amount%type;
    l_notes                 invg_invoices.notes%type;

    l_client_name           invg_clients.name%type;
    l_client_address        invg_clients.address%type;
    l_client_email          invg_clients.email%type;
    l_client_phone          invg_clients.phone%type;

    l_business_name         invg_businesses.name%type;
    l_business_address      invg_businesses.address%type;
    l_business_email        invg_businesses.email%type;
    l_business_phone        invg_businesses.phone%type;

    l_receiver_name         invg_bank_details.receiver_name%type;
    l_bank_name             invg_bank_details.bank_name%type;
    l_routing_number        invg_bank_details.routing_number%type;
    l_bank_account_number   invg_bank_details.bank_account_number%type;
    l_account_type          invg_bank_details.account_type%type;
    l_bank_address          invg_bank_details.bank_address%type;

    l_subtotal              number := 0;
    l_sales_tax             number := 0;
    l_total                 number := 0;
    l_line_count            number := 0;

    -- -----------------------------------------------------------------
    -- Local helpers
    -- -----------------------------------------------------------------
    function esc(p_text in varchar2) return varchar2
    is
    begin
      return apex_escape.html(p_text);
    end esc;

    function fmt_money(p_amount in number) return varchar2
    is
    begin
      return to_char(nvl(p_amount, 0), 'FM999,999,990.00');
    end fmt_money;

    function fmt_date(p_date in date) return varchar2
    is
    begin
      if p_date is null then
        return '';
      end if;
      return to_char(p_date, 'FMMon DD, YYYY', 'nls_date_language=english');
    end fmt_date;

    function nl2br(p_text in varchar2) return varchar2
    is
    begin
      return replace(esc(p_text), chr(10), '<br>');
    end nl2br;

    function amount_cell(
      p_amount        in number
    , p_dash_if_zero  in boolean default false
    )
    return varchar2
    is
    begin
      if p_dash_if_zero and nvl(p_amount, 0) = 0 then
        return '<span class="currency">$</span>'
            || '<span class="amount-value">-</span>';
      end if;
      return '<span class="currency">$</span>'
          || '<span class="amount-value">' || fmt_money(p_amount) || '</span>';
    end amount_cell;

  begin
    -- logger.append_param(l_params, 'p_invoice_id', p_invoice_id);
    -- logger.log('START', l_scope, null, l_params);

    -- =================================================================
    -- Fetch invoice header with client, business, bank joins
    -- =================================================================
    select lpad(i.invoice_number, 3, '0') as invoice_number
         , i.issue_date
         , i.include_due_date_yn
         , i.due_date
         , i.payment_terms
         , nvl(i.tax_rate, 0)
         , nvl(i.other_amount, 0)
         , i.notes
         , c.name
         , c.address
         , c.email
         , c.phone
         , b.name
         , b.address
         , b.email
         , b.phone
         , bk.receiver_name
         , bk.bank_name
         , bk.routing_number
         , bk.bank_account_number
         , bk.account_type
         , bk.bank_address
      into l_invoice_number
         , l_issue_date
         , l_include_due_date_yn
         , l_due_date
         , l_payment_terms
         , l_tax_rate
         , l_other_amount
         , l_notes
         , l_client_name
         , l_client_address
         , l_client_email
         , l_client_phone
         , l_business_name
         , l_business_address
         , l_business_email
         , l_business_phone
         , l_receiver_name
         , l_bank_name
         , l_routing_number
         , l_bank_account_number
         , l_account_type
         , l_bank_address
      from invg_invoices i
      left join invg_clients c
        on c.invg_client_id = i.invg_client_id
       and c.active_yn = 'Y'
      left join invg_businesses b
        on b.invg_business_id = i.invg_business_id
       and b.active_yn = 'Y'
      left join invg_bank_details bk
        on bk.invg_bank_detail_id = i.invg_bank_detail_id
       and bk.active_yn = 'Y'
     where i.invg_invoice_id = p_invoice_id
       and i.active_yn = 'Y';

    -- =================================================================
    -- Build HTML — same structure as buildInvoiceHtml() in app.js
    -- =================================================================
    l_html := '<div class="invoice-doc">';

    -- Title
    l_html := l_html || '<h1 class="invoice-title">INVOICE</h1>';

    -- Meta (number, dates, terms)
    l_html := l_html || '<div class="invoice-meta">'
           || '<p><strong> 2026-' || esc(l_invoice_number) || '</strong></p>'
           || '<p>Issue date: ' || fmt_date(l_issue_date) || '</p>';

    if l_include_due_date_yn = 'Y' and l_due_date is not null then
      l_html := l_html || '<p>Due date: ' || fmt_date(l_due_date) || '</p>';
    end if;

    if l_payment_terms is not null then
      l_html := l_html
             || '<p>Payment terms: ' || esc(l_payment_terms) || '</p>';
    end if;

    l_html := l_html || '</div>';

    -- Parties (From / To)
    l_html := l_html || '<div class="invoice-parties">';

    l_html := l_html || '<div class="invoice-from">'
           || '<strong>From</strong><br>'
           || esc(l_business_name) || '<br>'
           || nl2br(l_business_address) || '<br>';
    if l_business_email is not null then
      l_html := l_html || esc(l_business_email) || '<br>';
    end if;
    if l_business_phone is not null then
      l_html := l_html || esc(l_business_phone);
    end if;
    l_html := l_html || '</div>';

    l_html := l_html || '<div class="invoice-to">'
           || '<strong>To</strong><br>'
           || esc(l_client_name) || '<br>'
           || nl2br(l_client_address) || '<br>';
    if l_client_email is not null then
      l_html := l_html || esc(l_client_email) || '<br>';
    end if;
    if l_client_phone is not null then
      l_html := l_html || esc(l_client_phone);
    end if;
    l_html := l_html || '</div>';

    l_html := l_html || '</div>';

    -- Services table
    l_html := l_html
           || '<table class="invoice-services">'
           || '<thead><tr><th>DESCRIPTION</th><th>AMOUNT</th></tr></thead>'
           || '<tbody>';

    for rec in (
      select description
           , amount
        from invg_invoice_lines
       where invg_invoice_id = p_invoice_id
         and active_yn = 'Y'
       order by line_number
    ) loop
      l_line_count := l_line_count + 1;
      l_subtotal   := l_subtotal + nvl(rec.amount, 0);
      l_html := l_html
             || '<tr><td>' || esc(rec.description) || '</td>'
             || '<td class="amount">'
             || '<span class="currency">$</span>'
             || '<span class="amount-value">'
             || fmt_money(rec.amount) || '</span>'
             || '</td></tr>';
    end loop;

    if l_line_count = 0 then
      l_html := l_html
             || '<tr><td colspan="2" style="text-align:center;color:#999;'
             || 'padding:1rem;">No service lines found for this invoice.</td></tr>';
    end if;

    l_html := l_html || '</tbody></table>';

    -- Summary (subtotal, tax, other, total)
    l_sales_tax := l_subtotal * (l_tax_rate / 100);
    l_total     := l_subtotal + l_sales_tax + l_other_amount;

    l_html := l_html || '<table class="invoice-summary"><tbody>'
           || '<tr><td class="summary-label">SUBTOTAL</td>'
           || '<td class="amount">' || amount_cell(l_subtotal) || '</td></tr>'
           || '<tr><td class="summary-label">TAX RATE</td>'
           || '<td class="amount"><span class="amount-value">'
           || to_char(l_tax_rate, 'FM990.00') || '%</span></td></tr>'
           || '<tr><td class="summary-label">SALES TAX</td>'
           || '<td class="amount">'
           || amount_cell(l_sales_tax, true) || '</td></tr>'
           || '<tr><td class="summary-label">OTHER</td>'
           || '<td class="amount">'
           || amount_cell(l_other_amount, true) || '</td></tr>'
           || '<tr class="summary-total-row">'
           || '<td class="summary-label">TOTAL</td>'
           || '<td class="amount">' || amount_cell(l_total) || '</td></tr>'
           || '</tbody></table>';

    -- Bank / payment details
    if l_receiver_name   is not null
    or l_bank_name       is not null
    or l_routing_number  is not null
    or l_bank_account_number is not null
    or l_account_type    is not null
    or l_bank_address    is not null
    then
      l_html := l_html
             || '<section class="invoice-bank">'
             || '<h3>Payment details</h3><p>';

      if l_receiver_name is not null then
        l_html := l_html
               || '<strong>Receiver name:</strong> '
               || esc(l_receiver_name) || '<br>';
      end if;
      if l_bank_name is not null then
        l_html := l_html
               || '<strong>Bank name:</strong> '
               || esc(l_bank_name) || '<br>';
      end if;
      if l_bank_address is not null then
        l_html := l_html
               || '<strong>Bank address:</strong> '
               || esc(l_bank_address) || '<br>';
      end if;
      if l_routing_number is not null then
        l_html := l_html
               || '<strong>Routing number:</strong> '
               || esc(l_routing_number) || '<br>';
      end if;
      if l_bank_account_number is not null then
        l_html := l_html
               || '<strong>Account number:</strong> '
               || esc(l_bank_account_number) || '<br>';
      end if;
      if l_account_type is not null then
        l_html := l_html
               || '<strong>Account type:</strong> '
               || esc(l_account_type);
      end if;

      l_html := l_html || '</p></section>';
    end if;

    -- Notes
    if l_notes is not null then
      l_html := l_html
             || '<section class="invoice-notes"><p>'
             || replace(apex_escape.html(
                  dbms_lob.substr(l_notes, 4000)
                ), chr(10), '<br>')
             || '</p></section>';
    end if;

    l_html := l_html || '</div>';

    -- logger.log('END', l_scope, null, l_params);
    return l_html;

  exception
    when no_data_found then
      -- logger.log_error('Invoice not found', l_scope, null, l_params);
      return '<p class="invg-error">Invoice not found.</p>';
    when others then
      -- logger.log_error('Unhandled Exception', l_scope, null, l_params);
      raise;
  end render_invoice_html;

end invg_invoice_api;
/
