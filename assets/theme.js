/**
 * Theme manager — "Precision Instrument"
 * Handles: init from localStorage/system, toggle UI injection, persistence.
 *
 * Include this script at the end of <body>.
 * Also include this inline in <head> to prevent flash:
 *   <script>(function(){var t=localStorage.getItem('theme')||(matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
 */

(function () {
  'use strict';

  const STORAGE_KEY = 'storage-learn-theme';

  function getPreferredTheme() {
    var stored = localStorage.getItem(STORAGE_KEY);
    if (stored === 'dark' || stored === 'light') return stored;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem(STORAGE_KEY, theme);
    updateToggleLabel(theme);
  }

  function updateToggleLabel(theme) {
    var icon = document.getElementById('theme-toggle-icon');
    var label = document.getElementById('theme-toggle-label');
    if (!icon || !label) return;
    if (theme === 'dark') {
      icon.textContent = '☾'; // moon
      label.textContent = 'Dark';
    } else {
      icon.textContent = '☀'; // sun
      label.textContent = 'Light';
    }
  }

  function createToggle() {
    var btn = document.createElement('button');
    btn.className = 'theme-toggle';
    btn.setAttribute('aria-label', 'Switch color theme');
    btn.title = 'Toggle light / dark mode';
    btn.innerHTML =
      '<span class="theme-toggle-knob"></span>' +
      '<span class="theme-toggle-icon" id="theme-toggle-icon"></span>' +
      '<span id="theme-toggle-label"></span>';

    btn.addEventListener('click', function () {
      var current = document.documentElement.getAttribute('data-theme');
      var next = current === 'dark' ? 'light' : 'dark';
      applyTheme(next);
    });

    document.body.appendChild(btn);
  }

  // --- Init ---
  // If data-theme wasn't set by inline script, set it now
  if (!document.documentElement.hasAttribute('data-theme')) {
    document.documentElement.setAttribute('data-theme', getPreferredTheme());
  }

  // Wait for DOM, then inject toggle
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      createToggle();
      updateToggleLabel(document.documentElement.getAttribute('data-theme'));
    });
  } else {
    createToggle();
    updateToggleLabel(document.documentElement.getAttribute('data-theme'));
  }

  // Listen for system preference changes (only if user hasn't set a preference)
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
    if (localStorage.getItem(STORAGE_KEY)) return; // user has explicit preference
    applyTheme(e.matches ? 'dark' : 'light');
  });
})();
