/* eslint-disable no-var, semi */

window.archive_analytics = (function defineArchiveAnalytics() {
  var archive_analytics;
  var startTime = new Date();

  /**
   * Performs an arithmetic calculation on a string with a number and unit, while maintaining
   * the unit.
   *
   * @param {String} original value to modify, with a unit
   * @param {Function} doOperation accepts one Number parameter, returns a Number
   * @returns {String}
   */
  function computeWithUnit(original, doOperation) {
    var number = parseFloat(original, 10);
    var unit = original.replace(/(\d*\.\d+)|\d+/, '');

    return doOperation(number) + unit;
  }

  /**
   * Computes the default font size of the browser.
   *
   * @returns {String|null} computed font-size with units (typically pixels), null if it cannot be computed
   */
  function getDefaultFontSize() {
    var fontSizeStr;

    if (!('getComputedStyle' in window))
      return null;

    fontSizeStr = window.getComputedStyle(document.documentElement).fontSize;

    // Don't modify the value if tracking book reader.
    if (document.documentElement.classList.contains('BookReaderRoot'))
      return fontSizeStr;

    return computeWithUnit(fontSizeStr, function(number) {
      // Undo the 62.5% size applied in the Bootstrap CSS.
      return number * 1.6;
    });
  }

  archive_analytics = {
    values: {},


    // 2nd param: [optional] callback to invoke once ping to analytics server is done
    // 3rd param: [optional] logical truthy -- set to true/1 to add some archive.org site-specific values
    send_ping: function(values, onload_callback, augment_for_ao_site) {
      var img_src = "//analytics.archive.org/0.gif";

      var format_ping = function(values) {
        var ret = [];
        var count = 2;
        var version = 2;

        for (var data in values) {
          ret.push(encodeURIComponent(data) + "=" + encodeURIComponent(values[data]));
          count = count + 1;
        }

        ret.push('version=' + version);
        ret.push('count=' + count);
        return ret.join("&");
      };


      if (augment_for_ao_site  &&  !values['service'])
        values['service'] = 'ao_2';

      var string = format_ping(values);

      var loadtime_img = new Image(100,25);
      if (onload_callback  &&  typeof(onload_callback)=='function')
        loadtime_img.onload = onload_callback;
      loadtime_img.src = img_src + "?" + string;
    },
    send_scroll_fetch_event: function(page) {
      var endTime = new Date();
      archive_analytics.send_ping({
        'service':'ao_2',
        'kind':'event',
        'ec':'page_action',
        'ea':'scroll_fetch',
        'el':location.pathname,
        'ev':page,//int
        'loadtime':(endTime.getTime() - startTime.getTime()),
        'cache_bust':Math.random()
      });
    },
    send_scroll_fetch_base_event: function() {
      var endTime = new Date();
      archive_analytics.send_ping({
        'service':'ao_2',
        'kind':'event',
        'ec':'page_action',
        'ea':'scroll_fetch_base',
        'el':location.pathname,
        'loadtime':(endTime.getTime() - startTime.getTime()),
        'cache_bust':Math.random()
      });
    },

    /**
     * @param {Object} options
     * @param {String} options.mediaType
     */
    send_pageview: function send_pageview(options) {
      var endTime;
      var mediaType = options.mediaType
      var defaultFontSize;

      /**
       * @return {String}
       */
      function get_locale() {
        if (navigator) {
          if (navigator.language)
            return navigator.language;

          else if (navigator.browserLanguage)
            return navigator.browserLanguage;

          else if (navigator.systemLanguage)
            return navigator.systemLanguage;

          else if (navigator.userLanguage)
            return navigator.userLanguage;
        }
        return '';
      }

      endTime = new Date();
      defaultFontSize = getDefaultFontSize();

      // Set field values
      archive_analytics.values.kind     = 'pageview';
      archive_analytics.values.loadtime = endTime.getTime() - startTime.getTime();
      archive_analytics.values.timediff = (new Date().getTimezoneOffset()/60)*(-1); // *timezone* diff from UTC
      archive_analytics.values.locale   = get_locale();
      archive_analytics.values.referrer = (document.referrer == '' ? '-' : document.referrer);

      if (defaultFontSize)
        archive_analytics.values.ga_cd1 = defaultFontSize;

      if ('devicePixelRatio' in window)
        archive_analytics.values.ga_cd2 = window.devicePixelRatio;

      if (mediaType)
        archive_analytics.values.ga_cd3 = mediaType;

      archive_analytics.send_ping(archive_analytics.values);
    },
  };

  archive_analytics.get_data_packets = function () {
    return [archive_analytics.values];
  };

  return archive_analytics;
}());
