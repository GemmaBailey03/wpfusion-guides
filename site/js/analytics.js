(function () {
  var cfg = window.WPF_GUIDES || {};
  var ga4Id = (cfg.ga4MeasurementId || "").trim();

  if (ga4Id) {
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () {
      window.dataLayer.push(arguments);
    };
    window.gtag("js", new Date());
    window.gtag("config", ga4Id);
  }

  document.addEventListener("click", function (event) {
    var link = event.target.closest('a[href*="wpfusion.com/ref/"]');
    if (!link) {
      return;
    }
    if (typeof window.gtag === "function") {
      window.gtag("event", "affiliate_click", {
        link_url: link.href,
        page_path: location.pathname,
        page_title: document.title
      });
    }
  });
})();
