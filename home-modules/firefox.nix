{
  pkgs,
  config,
  ...
}: let
  wrappedFF = pkgs.firefox-bin.override {
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];
  };

  settings = {
    # Default to dark theme in DevTools panel
    "devtools.theme" = "dark";
    # Enable ETP for decent security (makes firefox containers and many
    # common security/privacy add-ons redundant).
    "browser.contentblocking.category" = "strict";
    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;
    "privacy.purge_trackers.enabled" = true;
    # Your customized toolbar settings are stored in
    # 'browser.uiCustomization.state'. This tells firefox to sync it between
    # machines. WARNING: This may not work across OSes. Since I use NixOS on
    # all the machines I use Firefox on, this is no concern to me.
    "services.sync.prefs.sync.browser.uiCustomization.state" = true;
    # Enable userContent.css and userChrome.css for our theme modules
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Stop creating ~/Downloads!
    "browser.download.dir" = "/home/jboyens/downloads";
    # Don't use site-specific zoom
    "browser.zoom.siteSpecific" = false;
    # Don't use the built-in password manager. A nixos user is more likely
    # using an external one (you are using one, right?).
    "signon.rememberSignons" = false;
    # Do not check if Firefox is the default browser
    "browser.shell.checkDefaultBrowser" = false;
    # Disable the "new tab page" feature and show a blank tab instead
    # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
    # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
    "browser.newtabpage.enabled" = false;
    "browser.newtab.url" = "about:blank";
    # Disable Activity Stream
    # https://wiki.mozilla.org/Firefox/Activity_Stream
    "browser.newtabpage.activity-stream.enabled" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    # Disable new tab tile ads & preload
    # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
    # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
    # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
    # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
    # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
    "browser.newtabpage.enhanced" = false;
    "browser.newtabpage.introShown" = true;
    "browser.newtab.preload" = false;
    "browser.newtabpage.directory.ping" = "";
    "browser.newtabpage.directory.source" = "data:text/plain,{}";
    # Reduce search engine noise in the urlbar's completion window. The
    # shortcuts and suggestions will still work, but Firefox won't clutter
    # its UI with reminders that they exist.
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.shortcuts.bookmarks" = false;
    "browser.urlbar.shortcuts.history" = false;
    "browser.urlbar.shortcuts.tabs" = false;
    "browser.urlbar.showSearchSuggestionsFirst" = false;
    "browser.urlbar.speculativeConnect.enabled" = false;
    # https://bugzilla.mozilla.org/1642623
    "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
    # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # Show whole URL in address bar
    "browser.urlbar.trimURLs" = false;
    # Disable some not so useful functionality.
    "browser.disableResetPrompt" = true; # "Looks like you haven't started Firefox in a while."
    "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour
    "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.shield-recipe-client.enabled" = false;
    "reader.parse-on-load.enabled" = false; # "reader view"

    # Security-oriented defaults
    "security.family_safety.mode" = 0;
    # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
    "security.pki.sha1_enforcement_level" = 1;
    # https://github.com/tlswg/tls13-spec/issues/1001
    "security.tls.enable_0rtt_data" = false;
    # Use Mozilla geolocation service instead of Google if given permission
    "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    "geo.provider.use_gpsd" = false;
    # https://support.mozilla.org/en-US/kb/extension-recommendations
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.htmlaboutaddons.discover.enabled" = false;
    "extensions.getAddons.showPane" = false; # uses Google Analytics
    "browser.discovery.enabled" = false;
    # Reduce File IO / SSD abuse
    # Otherwise, Firefox bombards the HD with writes. Not so nice for SSDs.
    # This forces it to write every 30 minutes, rather than 15 seconds.
    "browser.sessionstore.interval" = "1800000";
    # Disable battery API
    # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
    "dom.battery.enabled" = false;
    # Disable "beacon" asynchronous HTTP transfers (used for analytics)
    # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
    "beacon.enabled" = false;
    # Disable pinging URIs specified in HTML <a> ping= attributes
    # http://kb.mozillazine.org/Browser.send_pings
    "browser.send_pings" = false;
    # Disable gamepad API to prevent USB device enumeration
    # https://www.w3.org/TR/gamepad/
    # https://trac.torproject.org/projects/tor/ticket/13023
    "dom.gamepad.enabled" = false;
    # Don't try to guess domain names when entering an invalid domain name in URL bar
    # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
    "browser.fixup.alternate.enabled" = false;
    # Disable telemetry
    # https://wiki.mozilla.org/Platform/Features/Telemetry
    # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
    # https://wiki.mozilla.org/Telemetry
    # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
    # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
    # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
    # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
    # https://wiki.mozilla.org/Telemetry/Experiments
    # https://support.mozilla.org/en-US/questions/1197144
    # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "experiments.supported" = false;
    "experiments.enabled" = false;
    "experiments.manifest.uri" = "";
    "browser.ping-centre.telemetry" = false;
    # https://mozilla.github.io/normandy/
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "app.shield.optoutstudies.enabled" = false;
    # Disable health reports (basically more telemetry)
    # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
    # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;

    # Disable DNS-over-HTTPS
    "network.trr.mode" = 5;

    # Disable sponsored top sites
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    # Disable IPv6
    "network.dns.disableIPv6" = true;

    # no initial paint delay
    "nglayout.initialpaint.delay" = 0;

    # force webrender to use Wayland
    "gfx.webrender.compositor.force-enabled" = true;

    # Disable crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

    # Disable Form autofill
    # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
    "browser.formfill.enable" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.available" = "off";
    "extensions.formautofill.creditCards.available" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.heuristics.enabled" = false;
  };
in {
  home.sessionVariables = {
    XDG_DESKTOP_DIR = "${config.home.homeDirectory}/";
  };

  programs.firefox = {
    enable = true;
    package = wrappedFF;

    profiles = {
      default = {
        inherit settings;

        path = "jboyens.default";
        isDefault = true;
      };
    };

    # webapps = {
    #   slack = {
    #     url = "https://app.slack.com";
    #     id = 1;
    #     name = "Slack";
    #   };
    # };
  };

  home.file = {
    ".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

    ".config/tridactyl/tridactylrc".text = ''
      " Comment toggler for Reddit, Hacker News, and Lobste.rs
      bind ;c hint -c [class*="expand"],[class="togg"],[class="comment_folder"]

      " GitHub pull request checkout command to clipboard (only works if you're a collaborator or above)
      bind yp composite js document.getElementById("clone-help-step-1").textContent.replace("git checkout -b", "git checkout -B").replace("git pull ", "git fetch ") + "git reset --hard " + document.getElementById("clone-help-step-1").textContent.split(" ")[3].replace("-","/") | yank

      " Git{Hub,Lab} git clone via SSH yank
      bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank

      " Handy multiwindow/multitasking binds
      bind gd tabdetach
      bind gD composite tabduplicate | tabdetach

      " Add helper commands that Mozillians think make Firefox irredeemably insecure
      command fixamo_quiet jsb tri.excmds.setpref("privacy.resistFingerprinting.block_mozAddonManager", "true").then(tri.excmds.setpref("extensions.webextensions.restrictedDomains", '""'))
      command fixamo js tri.excmds.setpref("privacy.resistFingerprinting.block_mozAddonManager", "true").then(tri.excmds.setpref("extensions.webextensions.restrictedDomains", '""').then(tri.excmds.fillcmdline_tmp(3000, "Permissions added to user.js. Please restart Firefox to make them take affect.")))

      " Make Tridactyl work on more sites at the expense of some security
      set csp clobber
      fixamo_quiet

      set newtab about:blank

      " Allow Ctrl-a to select all in the commandline
      unbind --mode=ex <C-a>

      " Allow Ctrl-c to copy in the commandline
      unbind --mode=ex <C-c>

      " Sane hinting mode
      set hintfiltermode vimperator-reflow
      " set hintnames numeric

      bindurl ^https://duckduckgo.com f hint -Jc[data-testid=result]
      bindurl ^https://duckduckgo.com F hint -Jbc[data-testid=result]

      set theme dark

      " Defaults to 300ms but I'm a 'move fast and close the wrong tabs' kinda chap
      set hintdelay 100

      bind J tabnext
      bind K tabprev

      bind O fillcmdline tabopen

      bind zp js window.location.href = 'org-protocol://roam-ref?template=r&ref=' + encodeURIComponent(location.href) + '&title=' + encodeURIComponent(document.title)
    '';
  };
}
