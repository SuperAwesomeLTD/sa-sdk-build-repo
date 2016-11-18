var AwesomeVideo = (function(){

  /** import function */
	@import("utils/SAUtils.js");
  @import("vast/SAVASTModels.js");
  @import("vast/SAVASTUtils.js");
  @import("vast/SAVASTManager.js");
  @import("vast/SAVASTParser.js");
  @import("vast/SAVASTPlayer.js");

  /** normal constants */
  var host = window['awesomeads_host'];
  var isSkippable = window['awesomeads_skippable'];
  var isHTTPS = window['isHTTPS'];
  var hasSmallClick = window['awesomeads_smallclick'];

	/**
   * Constructor function
   * @param placement_id - the Placement ID of the ad
   * @param test - whether to load the test ad or not
   * @param element - the HTML element to append the video Ad to
	 * @param is_skippable - whether the video, if it's longer than 30s, should be skippable
	 * @param has_small_button - whether the video should have a small click button instead of a full area click
	 * @param ad - the ad, if it's already preloaded and exists
   */
  var AwesomeVideo = function(placement_id, test, element, is_skippable, has_small_button, ad) {
    var av = this;

    // define instance variables
		av.id = null;
    av.ad = ad;
    av.placement_id = placement_id;
    av.options = {};
    av.options.test = test || false;
    av.options.isSkippable = (is_skippable != null ? is_skippable : (isSkippable === 'true'));
    av.options.has_small_button = (has_small_button != null ? has_small_button : (hasSmallClick === 'true'));
    av.element = element;
		av.padlock = null;
    av.manager = null;
    av.player = null;

    // callbacks
    av.onReadyCallback = null;
    av.onEmptyCallback = null;
    av.onErrorCallback = null;
    av.onFinishedCallback = null;
  }

	// classic write method
	AwesomeVideo.prototype.write = function () {
		var av = this;

		// first load the ad
		AwesomeAdManager.get_ad(av.placement_id, av.options, function(err, ad_response){
			av.ad = ad_response;
			av.writePreloaded ();
		});
	}

  // "private" internal load ad function
  AwesomeVideo.prototype.writePreloaded = function() {
    var av = this;

		// apparently I now have to do a check for this ...
		if (av.ad == null || av.ad.creative == null || av.ad.creative.details == null) {
			av.removeAll ();
			if (av.onErrorCallback) {
				av.onErrorCallback ();
			}
			return;
		}

		var is_fallback = (av.ad.is_fallback != null ? av.ad.is_fallback : true);
		var is_house = (av.ad.is_house != null ? av.ad.is_house : false);
		var safe_ad_approved = av.ad.safe_ad_approved;
		var show_padlock = av.ad.show_padlock;
		var device = av.ad.device;
		var campaign_type = av.ad.campaign_type;

		// more complex padlock function
		function shouldShowPadlock () {
				if (is_fallback) return false;
				if (is_house && !safe_ad_approved) return false;
				return true;
		}

		av.id = "aa_video_ad_"+ ~~(Math.random()*10000000);
		av.player = new SAVASTPlayer(av.id, av.ad, av.element, av.options.isSkippable, shouldShowPadlock (), av.options.has_small_button, device);
		av.manager = new SAVASTManager(av.player);

		av.manager.parseVASTURL(av.ad.creative.details.vast);

		av.manager.didParseVASTAndHasAdsResponse = function () {

		};
		av.manager.didParseVASTButDidNotFindAnyAds = function () {
			av.removeAll ();
			av.onEmptyCallback ();
		};
		av.manager.didFindInvalidVASTResponse = function () {
			av.removeAll ();
			av.onErrorCallback ();
		};
		av.manager.didStartAd = function () {
			/** send event */
			if (av.onReadyCallback != null) {
				av.onReadyCallback();
			}
		};
		av.manager.didStartCreative = function () {
			/** Send moat events */
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdPlaying"
			});
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdVideoStart"
			});
		};
		av.manager.didReachFirstQuartileOfCreative = function () {
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdVideoFirstQuartile"
			});
		};
		av.manager.didReachMidpointOfCreative = function () {
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdVideoMidpoint"
			});
		};
		av.manager.didReachThirdQuartileOfCreative = function () {
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdVideoThirdQuartile"
			});
		};
		av.manager.didEndCreative = function () {
			av.player.MoatApiReference.dispatchEvent({
				"adVolume": 1.0,
				"type": "AdVideoComplete"
			});
		};
		av.manager.didEndAd = function () {

		};
		av.manager.didEndAllAds = function () {
			av.removeAll();

			if (av.onFinishedCallback != null) {
				av.onFinishedCallback ();
			}
		};
		av.manager.didFindError = function () {
			av.removeAll();

			if (av.onErrorCallback != null) {
				av.onErrorCallback();
			}
		};
		av.manager.didGoToURL = function (url) {
			if (campaign_type == 1) {
					var click_event = SAUtils.generateClickEvent(av.ad);
					var cpi_click = SAUtils.generateCPIClick(av.ad);
					SAUtils.sendAsyncGET(click_event, function () { console.log('Click event OK: ' + click_event); }, null);
					window.open(cpi_click, "_blank");
			} else {
					window.open(url, "_blank");
			}
		};
		av.manager.didSkipAd = function(){
			av.removeAll();
		}

    return this;
  };

  AwesomeVideo.prototype.removeAll = function () {
    var av = this;

    // remove player
		if (av.player) {
    	av.player.remove();
		}

    // null the ad data */
    av.ad = null;
  }

  AwesomeVideo.prototype.isEmpty = function(obj) {
    for(var prop in obj) {
      if(obj.hasOwnProperty(prop))
        return false;
    }

    return true;
  }

  /** Callbacks */

  AwesomeVideo.prototype.onReady = function(callback){
    var av = this;
    av.onReadyCallback = callback;
  }

  AwesomeVideo.prototype.onFinished = function(callback) {
    var av = this;
    av.onFinishedCallback = callback;
  }

  AwesomeVideo.prototype.onEmpty = function(callback) {
    var av = this;
    av.onEmptyCallback = callback;
  }

  AwesomeVideo.prototype.onError = function(callback) {
    var av = this;
    av.onErrorCallback = callback;
  }

  /** Final return */
  return AwesomeVideo;
}).call();
