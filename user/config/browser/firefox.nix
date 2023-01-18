# vim:fdm=marker
{ config, pkgs, ... }:

{
  enable = true;
  profiles."main" = {
    id = 0;
    isDefault = true;
    search.default = "DuckDuckGo";
    settings = {
      # about:preferences {{{
      # Startup
      "browser.startup.page" = 3; # Open previous windows and tabs
      "browser.shell.checkDefaultBrowser" = false; # Always check if Firefox is your default browser
      # Language
      "layout.spellcheckDefault" = 0; # Check your spelling as you type
      # Digital Rights Management (DRM) Content
      "media.eme.enabled" = true; # Play DRM-controlled content
      # Browsing
      "general.smoothScroll" = false; # Use smooth scrolling
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # Recommend extensions as your browse
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # Recommend features as your browse
      # New Windows and Tabs
      "browser.startup.homepage" = "about:blank"; # Homepage and new windows
      "browser.newtabpage.enabled" = false; # New tabs
      # Firefox Home Content
      "browser.newtabpage.activity-stream.showSearch" = false; # Web Search
      "browser.newtabpage.activity-stream.feeds.topsites" = false; # Shortcuts
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Recommended by Pocket
      # Default Search Engine
      # NOTE can no longer be set in about:config for security reasons
      # Search Suggestions
      "browser.search.suggest.enabled" = false; # Provide search suggestions
      # Enhanced Tracking Protection
      "privacy.donottrackheader.enabled" = true; # Always send websites a "Do Not Track" signal that you don't want to be tracked
      # Cookies and Site Data
      # NOTE these settings delete cookies and site data when Firefox is closed
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.formdata" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.offlineApps" = true;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.history.custom" = true;
      "privacy.sanitize.pending" = "[{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\"],\"options\":{}}]";
      "privacy.sanitize.sanitizeOnShutdown" = true;
      # Logins and Passwords
      "signon.rememberSignons" = false; # Ask to save logins and passwords for websites
      "signon.management.page.breach-alerts.enabled" = false; # Show alerts about passwords for breached websites
      # Forms and Autofill
      "extensions.formautofill.addresses.enabled" = false; # Autofill addresses
      "extensions.formautofill.creditCards.enabled" = false; # Autofill credit cards
      # History
      "places.history.enabled" = false; # Remember browsing and download history
      "browser.formfill.enable" = false; # Remember search and form history
      # Address Bar - Firefox Suggest
      # Choose the type of suggestions that appear in the address bar:
      "browser.urlbar.suggest.history" = false; # Browsing history
      "browser.urlbar.suggest.bookmark" = false; # Bookmarks
      "browser.urlbar.suggest.openpage" = false; # Open tabs
      "browser.urlbar.suggest.topsites" = false; # Shortcuts
      "browser.urlbar.suggest.engines" = false; # Search engines
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false; # Suggestions from the web
      "browser.urlbar.suggest.quicksuggest.sponsored" = false; # Suggestions from sponsors
      # Firefox Data Collection and Use
      "datareporting.healthreport.uploadEnabled" = false; # Allow Firefox to send technical and interaction data to Mozilla
      "app.shield.optoutstudies.enabled" = false; # Allow Firefox to install and run studies
      # Deceptive Content and Dangerous Software Protection
      "browser.safebrowsing.malware.enabled" = false; # Block dangerous aand deceptive content (1)
      "browser.safebrowsing.phishing.enabled" = false; # Block dangerous aand deceptive content (2)
      # HTTPS-Only Mode
      "dom.security.https_only_mode" = true; # Enable HTTPS-Only Mode in all windows (1)
      "dom.security.https_only_mode_ever_enabled" = true; # Enable HTTPS-Only Mode in all windows (2)
      # }}}

      # telemetry and privacy {{{
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "browser.urlbar.eventTelemetry.enabled" = false;
      "dom.security.unexpected_system_load_telemetry_enabled" = false;
      "network.trr.confirmation_telemetry_enabled" = false;
      "privacy.trackingprotection.origin_telemetry.enabled" = false;
      "security.app_menu.recordEventTelemetry" = false;
      "security.certerrors.recordEventTelemetry" = false;
      "security.identitypopup.recordEventTelemetry" = false;
      "security.protectionspopup.recordEventTelemetry" = false;
      "telemetry.origin_telemetry_test_mode.enabled" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.pioneer-new-studies-available" = false;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabledFirstSession" = false;
      "toolkit.telemetry.testing.overrideProductsCheck" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.cachedClientID" = "";
      # }}}

      # miscellaneous {{{
      "devtools.toolbox.host" = "right"; # open devtools to the right of the window
      "media.autoplay.enabled" = false; # do not autoplay media/videos
      "browser.download.autohideButton" = false; # never hide download icon in bar
      "full-screen-api.warning.timeout" = 0; # hide fullscreen warning
      "browser.urlbar.placeholderName" = "Firefox";
      "browser.urlbar.placeholderName.private" = "Firefox";
      "gfx.webrender.all" = true; # enable OpenGL
      "layers.acceleration.force-enabled" = true; # force hardware acceleration for performance
      "browser.sessionstore.max_tabs_undo" = 5; # only undo up to 5 tabs to reduce memory footprint
      "browser.sessionhistory.max_entries" = 5; # only 5 history entries to reduce memory footprint
      # move Firefox disk cache completely to RAM
      "browser.cache.disk.enable" = false;
      "browser.cache.memory.enable" = true;
      "dom.input.fallbackUploadDir" = "~/Downloads"; # set upload directory to help gtk find dirs
      # }}}

    };
    userChrome = "";
    userContent = "";
  };
}
