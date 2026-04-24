/*
 * ==========================================================================
 * banner.js
 * ==========================================================================
 *
 * @description Renders a top-of-page environment banner (DEV / QA / TRAIN)
 *              that mimics the APEX Builder environment banner look.
 *              Designed to be shipped inside a Dynamic Action plug-in that
 *              calls `master.envBanner.initialize(label, color)` on page
 *              load.
 * @author      Angel Flores (Consultant)
 * @created     April 2026
 * @version     3.0
 */

var master = master || {};

master.envBanner = (function(master, $, undefined) {
  'use strict';

  /* ================================================================ */
  /* CONSTANTS & CONFIG                                               */
  /* ================================================================ */
  var MODULE_NAME = 'EnvBanner';

  var CONFIG = {
    BANNER_ID:    'cw-env-banner'
    , BANNER_CLS: 'cw-env-banner'
    , LABEL_CLS:  'cw-env-banner-label'
    , BODY_FLAG:  'cw-has-env-banner'
  };

  /* ================================================================ */
  /* LOGGER                                                           */
  /* ================================================================ */
  var _PREFIX = '[' + MODULE_NAME + ']';
  var logger = {
    log:       function(msg, data) { console.log(_PREFIX, msg, data || ''); }
    , warning: function(msg, data) { console.warn(_PREFIX, msg, data || ''); }
    , error:   function(msg, data) { console.error(_PREFIX, msg, data || ''); }
  };

  /* ================================================================ */
  /* PRIVATE FUNCTIONS                                                */
  /* ================================================================ */

  /**
   * Universal Theme sets {@code t-Dialog-page} on modal / non-modal dialog
   * pages and {@code t-Drawer-page} on drawer pages. Those URLs are also
   * rendered in an iframe, so nested frames skip the banner if a custom
   * template omits the class.
   *
   * @return {boolean} true if the banner must not run on this document
   */
  var _shouldSkipBanner = function() {
    var body = document.body;
    if (body) {
      if (body.classList.contains('t-Dialog-page')
          || body.classList.contains('t-Drawer-page')) {
        return true;
      }
    }
    try {
      return window.self !== window.top;
    } catch (e) {
      return true;
    }
  };

  /**
   * Build the banner DOM and push the theme content down.
   * @param {string} label Text to display inside the banner
   * @param {string} color CSS color for the banner background
   */
  var _renderBanner = function(label, color) {
    if (document.getElementById(CONFIG.BANNER_ID)) {
      logger.warning('Banner already rendered, skipping');
      return;
    }

    var banner        = document.createElement('div');
    banner.id         = CONFIG.BANNER_ID;
    banner.className  = CONFIG.BANNER_CLS;
    banner.setAttribute('role', 'region');
    banner.setAttribute('aria-label', label);

    if (color) {
      banner.style.backgroundColor = color;
    }

    var labelEl         = document.createElement('span');
    labelEl.className   = CONFIG.LABEL_CLS;
    labelEl.textContent = label;
    banner.appendChild(labelEl);

    document.body.insertBefore(banner, document.body.firstChild);
    document.body.classList.add(CONFIG.BODY_FLAG);
  };

  /* ================================================================ */
  /* PUBLIC FUNCTIONS                                                 */
  /* ================================================================ */

  /**
   * Initialize the environment banner.
   * @param {string} label Banner text (empty string skips rendering)
   * @param {string} color Banner background color (CSS color value)
   */
  var initialize = function(label, color) {
    if (!label) {
      logger.log('No label provided, banner not rendered');
      return;
    }

    if (_shouldSkipBanner()) {
      logger.log('Dialog, drawer, or embedded page — banner not rendered');
      return;
    }

    logger.log('Rendering banner', { label: label, color: color });
    _renderBanner(label, color);
  };

  /* ================================================================ */
  /* Return public API                                                */
  /* ================================================================ */
  return {
    initialize: initialize
  };

})(master, apex.jQuery);
