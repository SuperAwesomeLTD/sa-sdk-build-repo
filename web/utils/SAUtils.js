/** Collection of utility functions */
var SAUtils = (function(){

  /** empty constructor */
  var SAUtils = function () {}

  /**
   * Function that executes an async GET
   * @param endpoint - the endpoint to which to send the request to
   * @param success - the callback that gets called in case of request OK
   * @param error - the callback in case of error
   */
  SAUtils.sendAsyncGET = function(endpoint, success, error) {

    var isOldIE = window.XDomainRequest ? true : false;
    var invocation = isOldIE ? new window.XDomainRequest() : new XMLHttpRequest ();

		function parseXML(val) {
			var xmlDoc;
			if (document.implementation && document.implementation.createDocument) {
	      xmlDoc = new DOMParser().parseFromString(val, 'text/xml');
      }
      else if (window.ActiveXObject) {
	      xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
      	xmlDoc.loadXML(val);
      }
			return xmlDoc;
    }

		if (isOldIE) {
			invocation.onload = function () {
				var response = invocation.responseXML;
				if (!response) {
					response = parseXML (invocation.responseText);
				}
				if (!response) {
					response = parseXML (invocation.response);
				}
				if (response) {
					if (success) success(response);
				} else {
					if (error) error ();
				}
			};
      invocation.open("GET", endpoint, true);
      invocation.send();
		} else {
			invocation.open("GET", endpoint, true);
      invocation.onreadystatechange = function (evtXHR) {
				if (invocation.readyState === 4 && invocation.status === 200) {
					var response = invocation.responseXML;
					if (!response) {
						response = parseXML (invocation.responseText);
					}
					if (!response) {
						response = parseXML (invocation.response);
					}
					if (response) {
						if (success) success(response);
					} else {
						if (error) error ();
					}
	      } else {
	        if (error) error ();
	      }
			}
			invocation.onerror = function (evtXHR) {
				if (error) error ();
			}
      invocation.send();
		}
  }

  /**
   * Function that sends an event to a specified endpoint
   * @param a String endpoint
   */
  SAUtils.sendEvent = function(endpoint) {
    var script;
    var callback_key = "jsonp_callback_"+ ~~(Math.random()*10000000);
    window[callback_key] = function(data){
      script.parentNode.removeChild(script);
      console.info('[AA :: Info] Send Event to: ' + endpoint);
    }

    script = document.createElement('script');
    script.src = endpoint;
    document.getElementsByTagName('head')[0].appendChild(script);
  }

  SAUtils.generateClickEvent = function (ad) {
      var rnd = ~~(Math.random()*100000000);
      var evt = window['awesomeads_host'];
      evt += "/v2/event_click";
      evt += "?placement=" + ad.placement_id;
      evt += "&rnd=" + rnd;
      evt += "&line_item=" + ad.line_item_id;
      evt += "&creative=" + ad.creative.id;
      evt += "&sdkVersion=" + window['aa_sdkVersion'];
      return evt;
  }

  SAUtils.generateCPIClick = function (ad) {
      var androidCpiQuery = "referrer=";
      var referrer = "utm_source=";
      referrer += "" + window['awesomeads_host'].indexOf('staging') != -1 ? 1 : 0;
      referrer += "&utm_campaign=" + ad.campaign_id;
      referrer += "&utm_term=" + ad.line_item_id;
      referrer += "&utm_content=" + ad.creative.id;
      referrer += "&utm_medium=" + ad.placement_id;
      referrer = referrer.replace(new RegExp('&', 'g'), "%26");
      referrer = referrer.replace(new RegExp('=', 'g'), "%3D");
      return ad.creative.click_url + "&referrer=" + referrer;
  }

  /** final return */
  return SAUtils;
}).call();
