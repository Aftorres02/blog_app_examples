/*
 * Environment banner: strips, badge, and navbar styles (init via Dynamic Action).
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
    , BODY_BASE:  'cw-has-env-banner'
    , BODY_STRIP: 'cw-has-env-banner--strip'
    , BODY_BADGE: 'cw-has-env-banner--badge'
    , BODY_NAV:   'cw-has-env-banner--navbar'
  };

  var STRIP_STYLES = [
    'STRIP_CLASSIC'
    , 'STRIP_CORPORATE'
    , 'STRIP_ECO'
    , 'STRIP_CLEAN'
    , 'STRIP_FUTURE'
    , 'STRIP_ICONS'
  ];

  var HEIGHT_CLASS = {
    STRIP_CLASSIC:   'cw-env-strip-h--classic'
    , STRIP_CORPORATE: 'cw-env-strip-h--corporate'
    , STRIP_ECO:     'cw-env-strip-h--eco'
    , STRIP_CLEAN:   'cw-env-strip-h--clean'
    , STRIP_FUTURE:  'cw-env-strip-h--future'
    , STRIP_ICONS:   'cw-env-strip-h--icons'
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
  /* PRIVATE                                                          */
  /* ================================================================ */

  var _normalizeStyle = function(style) {
    var s = (style || 'STRIP_CLASSIC').toString().trim().toUpperCase();
    if (s === 'CLASSIC' || s === 'STRIP') {
      return 'STRIP_CLASSIC';
    }
    return s;
  };

  var _stripThemeClass = function(style) {
    return 'cw-env-banner--' + style.toLowerCase().replace(/_/g, '-');
  };

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

  var _badgeShortLabel = function(label) {
    var parts = label.split(/\s+/);
    return (parts[0] || label).substring(0, 24);
  };

  var _renderStripInner = function(label, style) {
    if (style === 'STRIP_FUTURE') {
      var notch = document.createElement('div');
      notch.className = 'cw-env-banner-notch';
      var lab = document.createElement('span');
      lab.className = CONFIG.LABEL_CLS;
      lab.textContent = label;
      notch.appendChild(lab);
      return notch;
    }

    if (style === 'STRIP_ICONS') {
      var inner = document.createElement('div');
      inner.className = 'cw-env-banner-row';

      var iconsL = document.createElement('span');
      iconsL.className = 'cw-env-banner-icons cw-env-banner-icons--left';
      iconsL.setAttribute('aria-hidden', 'true');
      iconsL.textContent = '\u2302 \u25A4 \u2699';

      var lab = document.createElement('span');
      lab.className = CONFIG.LABEL_CLS;
      lab.textContent = label;

      var iconsR = document.createElement('span');
      iconsR.className = 'cw-env-banner-icons cw-env-banner-icons--right';
      iconsR.setAttribute('aria-hidden', 'true');
      iconsR.textContent = '\u2248 \u2666 \u25CB';

      inner.appendChild(iconsL);
      inner.appendChild(lab);
      inner.appendChild(iconsR);
      return inner;
    }

    var lab = document.createElement('span');
    lab.className = CONFIG.LABEL_CLS;
    lab.textContent = label;
    return lab;
  };

  var _normalizePlacement = function(pos) {
    var p = (pos || 'TOP').toString().trim().toUpperCase();
    return p === 'LEFT' ? 'LEFT' : 'TOP';
  };

  var _renderStrip = function(label, color, style, position) {
    if (document.getElementById(CONFIG.BANNER_ID)) {
      logger.warning('Banner already rendered, skipping');
      return;
    }

    var placement = _normalizePlacement(position);
    var isLeft = placement === 'LEFT';

    var banner = document.createElement('div');
    banner.id = CONFIG.BANNER_ID;
    banner.className = [
      CONFIG.BANNER_CLS
      , _stripThemeClass(style)
    ].join(' ');
    if (isLeft) {
      banner.classList.add('cw-env-banner--position-left');
    }
    banner.setAttribute('role', 'region');
    banner.setAttribute('aria-label', label);

    if (color) {
      banner.style.setProperty('--cw-env-user-color', color);
    }

    banner.appendChild(_renderStripInner(label, style));

    document.body.insertBefore(banner, document.body.firstChild);

    document.body.classList.add(CONFIG.BODY_BASE, CONFIG.BODY_STRIP);
    if (isLeft) {
      document.body.classList.add('cw-has-env-banner--strip-left');
    }
    var hCls = HEIGHT_CLASS[style];
    if (hCls) {
      document.body.classList.add(hCls);
    }
  };

  var _renderBadge = function(label, color) {
    if (document.querySelector('.cw-env-badge')) {
      logger.warning('Badge already rendered, skipping');
      return;
    }
    var branding = document.querySelector('.t-Header-branding');
    if (!branding) {
      logger.warning('.t-Header-branding not found; badge not rendered');
      return;
    }

    var badge = document.createElement('span');
    badge.className = 'cw-env-badge';
    badge.textContent = _badgeShortLabel(label);
    badge.setAttribute('title', label);
    badge.setAttribute('aria-label', label);
    if (color) {
      badge.style.backgroundColor = color;
    }

    branding.appendChild(badge);
    document.body.classList.add(CONFIG.BODY_BASE, CONFIG.BODY_BADGE);
  };

  var _applyNavbarTint = function(label, color) {
    var c = color || '#377E55';
    document.documentElement.style.setProperty('--cw-env-navbar-bg', c);
    document.body.classList.add(CONFIG.BODY_BASE, CONFIG.BODY_NAV);

    var logo = document.querySelector('.t-Header-logo');
    if (logo && !logo.querySelector('.cw-env-navbar-suffix')) {
      var sfx = document.createElement('span');
      sfx.className = 'cw-env-navbar-suffix';
      sfx.textContent = ' / ' + label;
      logo.appendChild(sfx);
    }
  };

  /* ================================================================ */
  /* PUBLIC                                                           */
  /* ================================================================ */

  /**
   * @param {string} label  Environment label text
   * @param {string} color  Accent / background color (hex or CSS)
   * @param {string} style  STRIP_* | BADGE | NAVBAR_COLOR
   * @param {string} position  TOP (default) or LEFT; strip layouts only (badge/navbar ignore)
   */
  var initialize = function(label, color, style, position) {
    if (!label) {
      logger.log('No label provided, banner not rendered');
      return;
    }

    if (_shouldSkipBanner()) {
      logger.log('Dialog, drawer, or embedded page — not rendered');
      return;
    }

    var st = _normalizeStyle(style);
    var pos = _normalizePlacement(position);

    logger.log('Rendering env indicator', { label: label, color: color, style: st, position: pos });

    if (st === 'BADGE') {
      _renderBadge(label, color);
      return;
    }

    if (st === 'NAVBAR_COLOR') {
      _applyNavbarTint(label, color);
      return;
    }

    if (STRIP_STYLES.indexOf(st) >= 0) {
      _renderStrip(label, color, st, pos);
      return;
    }

    logger.warning('Unknown style, using STRIP_CLASSIC', st);
    _renderStrip(label, color, 'STRIP_CLASSIC', pos);
  };

  return {
    initialize: initialize
  };

})(master, apex.jQuery);
