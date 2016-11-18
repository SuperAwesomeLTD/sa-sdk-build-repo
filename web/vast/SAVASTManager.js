var SAVASTManager = (function(){

    @import("../utils/SAUtils.js");

  /** instance constructor */
  var SAVASTManager = function (player) {
    var av = this;
    /** get the player reference */
    av.player = player;
    av.addHandlersForPlayer();
    /** init a vast parser object */
    av.parser = new SAVASTParser();

    /** other useful variables */
    av.vastObject = null;
    av.adQueue = [];
    av.currentAdIndex = 0;
    av.currentCreativeIndex = -1;
    av._cAd = null;
    av._cCreative = null;

    /** different callbacks */
    av.didParseVASTAndHasAdsResponse = null;
    av.didParseVASTButDidNotFindAnyAds = null;
    av.didFindInvalidVASTResponse = null;
    av.didStartAd = null;
    av.didStartCreative = null;
    av.didReachFirstQuartileOfCreative = null;
    av.didReachMidpointOfCreative = null;
    av.didReachThirdQuartileOfCreative = null;
    av.didEndCreative = null;
    av.didEndAd = null;
    av.didEndAllAds = null;
    av.didFindError = null;
    av.didGoToURL = null;
    av.didSkipAd = null;
  }

  /**
   * Function to handle callbacks all in one place
   */
  SAVASTManager.prototype.addHandlersForPlayer = function () {
    var av = this;
    av.player.setDidFindPlayerReady(function (){
      /** send impressions */
      if (av._cAd == null) return;
      for (var i = 0; i < av._cAd.impressions.length; i++){
          if (!av._cAd.impressions[i].isSent && av._cAd.impressions[i].url){
              SAUtils.sendEvent(av._cAd.impressions[i].url);
          }
        }
    });
    av.player.setDidStartPlayer(function (){
      /** send events */
      av.sendCurrentCreativeTrackers("start");
      av.sendCurrentCreativeTrackers("creativeView");

      /** callbacks */
      if (av.didStartCreative != null){
        av.didStartCreative();
      }
    });
    av.player.setDidReachFirstQuartile(function(){
      /** send events */
      av.sendCurrentCreativeTrackers("firstQuartile");

      /** callbacks */
      if (av.didReachFirstQuartileOfCreative != null){
        av.didReachFirstQuartileOfCreative();
      }
    });
    av.player.setDidReachMidpoint(function(){
      /** send events */
      av.sendCurrentCreativeTrackers("midpoint");

      /** callbacks */
      if (av.didReachMidpointOfCreative != null){
        av.didReachMidpointOfCreative();
      }
    });
    av.player.setDidReachThirdQuartile(function(){
      /** send events */
      av.sendCurrentCreativeTrackers("thirdQuartile");

      /** callbacks */
      if (av.didReachThirdQuartileOfCreative != null){
        av.didReachThirdQuartileOfCreative();
      }
    });
    av.player.setDidReachEnd(function (){
      /** send events */
      av.sendCurrentCreativeTrackers("complete");
      /** callback */
      if (av.didEndCreative != null) {
        av.didEndCreative();
      }

      /** progress further */
      av.progressThroughAds();
    });
    av.player.setDidReachEndOfVPAID(function(){
      if (av.didEndAllAds != null) {
        av.didEndAllAds();
      }
    });
    av.player.setDidPlayWithError(function (){
      /** send errors */
      if (av._cAd == null) return;
      for (var i = 0; i < av._cAd.errors.length; i++){
          SAUtils.sendEvent(av._cAd.errors[i]);
      }

      /** callback */
      if (av.didFindError != null){
        av.didFindError ();
      }
    });
    av.player.setDidGoToURL(function (){

      /** try getting the correct URL */
      if (av._cCreative == null) return;

      /** click event */
      for (var i = 0; i < av._cCreative.clickTracking.length; i++){
         SAUtils.sendEvent(av._cCreative.clickTracking[i]);
      }

      /** goto URL */
      var url = null;
      if (av._cCreative.clickThrough){
        url = av._cCreative.clickThrough;
      }
        else {
        for (var i = 0; i < av._cCreative.clickTracking.length; i++){
          if (SAVASTUtils.isValidURL(av._cCreative.clickTracking[i])){
            url = av._cCreative.clickTracking[i];
            break;
          }
        }
        }

      /** send callback */
      if(av.didGoToURL != null && url != null) {
        av.didGoToURL(url);
      }

    });
    av.player.setDidSkipAd(function () {

      /** send callback */
      if (av.didSkipAd != null) {
        av.didSkipAd();
      }
    });
  }

  /**
   * For AwesomeVideo2.js, this is the only external interface it'll need
   * to play videos
   */
  SAVASTManager.prototype.parseVASTURL = function(url){
    var av = this;

    av.parser.parseVAST(url, url, null, function success(vastobject){
      /** copy vast object */
      av.vastObject = vastobject;

			/**
       * standard VAST case - when what's been parsed will be manually
       * played and triggered by our own tech (+vide.js for dumb display)
       */
      if (!av.vastObject.isVPAID && av.vastObject.ads.length > 0) {

        /** setup first data */
        av.adQueue = av.vastObject.ads;
        av.currentAdIndex = 0;
        av.currentCreativeIndex = -1;
        av._cAd = av.adQueue[av.currentAdIndex];

        /** send callbacks */
        if (av.didParseVASTAndHasAdsResponse != null){
          av.didParseVASTAndHasAdsResponse();
        }

        if (av.didStartAd != null){
          av.didStartAd ();
        }

        /** start ad progression */
        av.progressThroughAds();
      }
      /**
       * Case when VAST tag serves VPAID, and for the moment we'll depend
       * on the VPAID video.js module supplied by DialyMail
       */
      else if (av.vastObject.isVPAID) {
        av.playWholeAdAsVPAID();
      }
      /**
       * Not one of these two cases? Then we haven't actually found any
       * valid ads
       */
      else {
        if (av.didParseVASTButDidNotFindAnyAds != null){
          av.didParseVASTButDidNotFindAnyAds();
        }
      }
    }, function error(){

      if (av.didFindInvalidVASTResponse != null) {
        av.didParseVASTButDidNotFindAnyAds();
      }
    });
  }

  /**
   * Main "progress through ads" function
   * that applies a "simple" algorithm to go through each ad, each creative
   * in the VAST response that's been parsed
   */
  SAVASTManager.prototype.progressThroughAds = function () {
    /** select the current context and remove any existing player */
    var av = this;

    /** update the current creative count */
    var creativeCount = av.adQueue[av.currentAdIndex].creatives.length;

    /**
     * if we're still in the same batch of creatives from the current ad,
     * then go on and update the current creative index, select a new
     * creative and play it
     */
    if (av.currentCreativeIndex < creativeCount - 1){
      av.currentCreativeIndex++;
      av._cCreative = av._cAd.creatives[av.currentCreativeIndex];
      av.playCurrentAdWithCurrentCreative();
    }
    /**
     * Other case is that we've finished all creatives from this Ad and
     * we're ready to move to the next ad
     */
    else {
      /** send a callback that I did end ad */
      if (av.didEndAd != null){
        av.didEndAd();
      }

      /**
       * now if there are any more ads, reset the creative index,
       * increment the ad index, change the creative and
       * singnal a new ad start
       */
      if (av.currentAdIndex < av.adQueue.length - 1){
        av.currentCreativeIndex = 0;
        av.currentAdIndex++;

        av._cAd = av.adQueue[av.currentAdIndex];
        av._cCreative = av._cAd.creatives[av.currentCreativeIndex];

        if (av.didStartAd != null){
          av.didStartAd ();
        }

        av.playCurrentAdWithCurrentCreative();
      }
      /** all ads have ended */
      else {
        if (av.didEndAllAds != null){
          av.didEndAllAds ();
        }
      }
    }
  }

  /**
   * This function selects the current creative and plays it
   */
  SAVASTManager.prototype.playCurrentAdWithCurrentCreative = function () {
		var av = this;
    var playable = av._cCreative.playableMediaFile;
    av.player.play(playable.url, playable.type, false);
  }

  /**
   * Shorthand function for VPAID
   */
  SAVASTManager.prototype.playWholeAdAsVPAID = function() {
    var av = this;
    av.player.play(av.vastObject.urlVPAID, null, true);
  }
  /**
   */
  SAVASTManager.prototype.sendCurrentCreativeTrackers = function(event) {
    var av = this;
    if (av._cCreative == null) return;
    var allTrackers = av._cCreative.trackingEvents;
    for (var i = 0; i < allTrackers.length; i++){
      if (allTrackers[i].event && allTrackers[i].url && allTrackers[i].event == event) {
        SAUtils.sendEvent(allTrackers[i].url);
      }
    }
  }

  /** final return */
  return SAVASTManager;
}).call();
