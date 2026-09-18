// allow websites to ask you for your location
user_pref("permissions.default.geo", 0);

// PREF: restore Top Sites on New Tab page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);

// PREF: remove default Top Sites (Facebook, Twitter, etc.)
// This does not block you from adding your own.
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// PREF: remove sponsored content on New Tab page
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // Sponsored shortcuts
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false); // Recommended by Pocket
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // Sponsored Stories

// TODO: https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#alternatives
// start using these

// NOTE: AI disabled by default - https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#alternatives

// NOTE: search engine suggestions disabled by default - https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#search-settings
// PREF: restore search engine suggestions
user_pref("browser.search.suggest.enabled", true);

// TODO: https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#containers
// consider using these
