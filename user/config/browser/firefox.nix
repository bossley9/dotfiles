# vim:fdm=marker
{ config, pkgs, ... }:

{
  enable = true;
  profiles."main" = {
    id = 0;
    isDefault = true;
    settings = {
      # about:preferences {{{
      # startup
      "browser.startup.page" = 3; # restore previous session
      "browser.shell.checkDefaultBrowser" = false; # always check if Firefox is your default browser
      # tabs
      "browser.ctrlTab.recentlyUsedOrder" = false; # ctrl + tab cycles through tabs in recently used order
      # website appearance
      "layout.css.prefers-color-scheme.content-override" = 0; # choose which color scheme you'd like to use
      # language
      "layout.spellcheckDefault" = 0; # check your spelling as your type
      # DRM content
      "media.eme.enabled" = true; # play DRM-controlled content
      # browsing
      "general.smoothScroll" = false; # use smooth scrolling
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # recommend extensions as your browse
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # recommend features as your browse
      # new windows and tabs
      "browser.startup.homepage" = "about:blank"; # homepage and new windows
      # firefox home content
      "browser.newtabpage.activity-stream.showSearch" = false; # web search
      "browser.newtabpage.activity-stream.feeds.topsites" = false; # shortcuts
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # recommended by pocket
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false; # highlights
      "browser.newtabpage.activity-stream.feeds.snippets" = false; # snippets
      # default search engine
      # NOTE can no longer be set in about:config for security reasons
      # search suggestions
      "browser.search.suggest.enabled" = false;
      # enhanced tracking protection
      "privacy.donottrackheader.enabled" = true; # always send websites a "Do Not Track" signal that you don't want to be tracked
      # cookies and site data
      # NOTE these settings delete cookies and site data once Firefox is closed
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.formdata" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.offlineApps" = true;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.sanitize.pending" = "[{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\"],\"options\":{}}]";
      "privacy.sanitize.sanitizeOnShutdown" = true;
      # logins and passwords
      "signon.rememberSignons" = false; # ask to save logins and passwords for websites
      "signon.autofillForms" = false; # autofill logins and passwords
      "signon.generation.enabled" = false; # suggest and generate strong passwords
      "signon.management.page.breach-alerts.enabled" = false; # show alerts about passwords for breached websites
      # forms and autofill
      "extensions.formautofill.addresses.enabled" = false; # autofill addresses
      "extensions.formautofill.creditCards.enabled" = false; # autofill credit cards
      # history
      "places.history.enabled" = false; # remember browsing and download history
      "browser.formfill.enable" = false; # remember search and form history
      # address bar
      # when using the address bar = suggest
      "browser.urlbar.suggest.history" = false; # browsing history
      "browser.urlbar.suggest.bookmark" = false; # bookmarks
      "browser.urlbar.suggest.openpage" = false; # open tabs
      "browser.urlbar.suggest.topsites" = false; # shortcuts
      "browser.urlbar.suggest.engines" = false; # search engines
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false; # suggestions from the web
      "browser.urlbar.suggest.quicksuggest.sponsored" = false; # suggestions from sponsors
      # firefox data collection and use
      "datareporting.healthreport.uploadEnabled" = false; # allow firefox to send technical and interaction data to mozilla
      "browser.discovery.enabled" = false; # allow firefox to make personalized extension recommendations
      "app.shield.optoutstudies.enabled" = false; # allow firefox to run and install studies
      # deceptive content and dangerous software protection
      "browser.safebrowsing.malware.enabled" = false; # block dangerous aand deceptive content (1)
      "browser.safebrowsing.phishing.enabled" = false; # block dangerous aand deceptive content (2)
      "browser.safebrowsing.downloads.enabled" = false; # block dangerous downloads
      "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false; # warn you about unwanted and uncommon software (1)
      "browser.safebrowsing.downloads.remote.block_uncommon" = false; # warn you about unwanted and uncommon software (2)
      # HTTPS-only mode
      "dom.security.https_only_mode" = true; # enable https-only mode in all windows (1)
      "dom.security.https_only_mode_ever_enabled" = true; # enable https-only mode in all windows (2)
      # }}}

      # telemetry and privacy {{{
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "devtools.onboarding.telemetry.logged" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.hybridContent.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.cachedClientID" = "";
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.sessions.current.clean" = true;
      # turn off syncing
      "services.sync.prefs.sync.app.shield.optoutstudies.enabled" = false;
      "services.sync.prefs.sync.browser.discovery.enabled" = false;
      "services.sync.prefs.sync.browser.formfill.enable" = false;
      "services.sync.engine.passwords" = false;
      # syncing
      "services.sync.declinedEngines" = "passwords,addresses,creditcards";
      # telemetry master
      "app.normandy.enabled" = false;
      "privacy.trackingprotection.enabled" = true;
      "browser.send_pings" = false;
      "browser.send_pings.require_same_host" = true;
      # why are websites reading my battery info tho
      "dom.battery.enabled" = false;
      # cookies
      "network.cookie.alwaysAcceptSessionCookies" = false;
      "network.cookie.cookieBehavior" = 0;
      # sites should not be able to see installed plugins
      "plugins.enumerable_names" = "";
      # disable geolocation
      "geo.enabled" = false;
      "geo.wifi.uri" = "";
      "browser.search.geoip.url" = "";
      # extensions
      "extensions.logging.enabled" = false;
      # }}}

      # miscellaneous {{{
      # meta
      "browser.aboutConfig.showWarning" = false;
      # tabs
      "browser.tabs.warnOnClose" = false;
      "browser.tabs.warnOnCloseOtherTabs" = false;
      # disabling junk Mozilla defaults
      "browser.messaging-system.whatsNewPanel.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      # devtools
      "devtools.toolbox.host" = "right";
      # media playback
      "dom.media.autoplay.autoplay-policy-api" = false;
      "media.autoplay.default" = 1;
      "media.autoplay.enabled" = false;
      "media.block-autoplay-until-in-foreground" = true;
      "media.autoplay.allow-muted" = false;
      # opengl
      "gfx.webrender.all" = true;
      # force acceleration
      "layers.acceleration.force-enabled" = true;
      # downloads
      # display download panel on download
      "browser.download.panel.shown" = true;
      # always display download icon in bar
      "browser.download.autohideButton" = false;
      # performance
      # reducing memory footprint
      "browser.sessionstore.max_tabs_undo" = 5;
      # max urls you can traverse with forward/back
      "browser.sessionhistory.max_entries" = 5;
      # animations
      "browser.tabs.animate" = false;
      "browser.download.animateNotifications" = false;
      "toolkit.cosmeticAnimations.enabled" = false;
      # fullscreen animations
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "ui.prefersReducedMotion" = 1;
      # hide fullscreen warning
      "full-screen-api.warning.timeout" = 0;
      # move Firefox disk cache completely to RAM
      "browser.cache.disk.parent_directory" = "/run/";
      "browser.cache.memory.enable" = true;
      "browser.cache.disk.enable" = false;
      # extensions
      "extensions.update.enabled" = false;
      "extensions.update.autoUpdateEnabled" = false;

      "browser.urlbar.placeholderName" = "Firefox";
      "browser.urlbar.placeholderName.private" = "Firefox";
      # hardcode user agent
      # warning: this can seriously affect the layout of some websites
      # but it's required for certain sites (e.g. zoom = outlook, chase)
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent/Firefox
      # "general.useragent.override" = "Mozilla/5.0 (X11; Linux amd64; rv:95.0) Gecko/20100101 Firefox/95.0";
      # default download directory
      "dom.input.fallbackUploadDir" = "~/Downloads";
      # }}}

    };
    userChrome = "";
    userContent = "";
  };
}
