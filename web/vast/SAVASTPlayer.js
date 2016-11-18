var SAVASTPlayer = (function(){

	// current host
  var host = window['awesomeads_host'];

  //////////////////////////////////////////////////////////////////////////////
  // Constructor
	//////////////////////////////////////////////////////////////////////////////

  var SAVASTPlayer = function(id, ad, parent, is_skippable, has_padlock, has_small_button, device){
    var av = this;

		// instance vars
		av.parent = parent;
    av.url = null;
		av.ad = ad;
    av.type = null;
    av.isVPAID = false;
		av.MoatApiReference = null;
    av.id = id;
    av.isSkippable = is_skippable;
    av.isMobile = (device === 'phone' || device === 'tablet' ? true : false);
    av.hasPadlock = has_padlock;
    av.has_small_button = (has_small_button != null ? has_small_button : false);
    av.scriptsLoaded = 0;
		av.cMAX_SCRIPTS_LOADED = 4;

		// UI instance vars
		av.div = null;
    av.video = null;
		av.cronographBg = null;
    av.cronograph = null;
    av.clicker = null;
    av.skip = null;
    av.mask = null;
    av.padlock = null;
    av.playbtn = null;

    // callback locks (so I don't call them twice)
    av.isReadyHandled = false;
    av.isStartHandled = false;
    av.isFirstQuartileHandled = false;
    av.isMidpointHandled = false;
    av.isThirdQuartileHandled = false;
    av.isEndHandled = false;
    av.isSkipHandled = false;
    av.isErrorHandled = false;

    // callbacks
    av.didFindPlayerReady = null;
    av.didStartPlayer = null;
    av.didReachFirstQuartile = null;
    av.didReachMidpoint = null;
    av.didReachThirdQuartile = null;
    av.didReachEnd = null;
    av.didReachEndOfVPAID = null;
    av.didPlayWithError = null;
    av.didGoToURL = null;
    av.didSkipAd = null;

    // load scripts
    var videojsscript = document.createElement("script");
    videojsscript.setAttribute("type", "application/javascript");
    videojsscript.setAttribute("src", host + '/videojs/video.min.js');
		videojsscript.onload = videojsscript.onreadystatechange = function () {
      if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") {
				videojsscript.onload = videojsscript.onreadystatechange = null;
				av.scriptsLoaded++;
			}
		};
		document.getElementsByTagName('head')[0].appendChild(videojsscript);

    var vpaidjsscript = document.createElement("script");
    vpaidjsscript.setAttribute("type", "application/javascript");
    vpaidjsscript.setAttribute("src", host + '/videojs/vpaid/videojs_5.vast.vpaid.js');
		vpaidjsscript.onload = vpaidjsscript.onreadystatechange = function () {
			if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") {
				vpaidjsscript.onload = vpaidjsscript.onreadystatechange = null;
				av.scriptsLoaded++;
			}
		};
		document.getElementsByTagName('head')[0].appendChild(vpaidjsscript);

		var moatscript = document.createElement("script")
		moatscript.setAttribute("type", "application/javascript");
		moatscript.setAttribute("src", host + "/moat/moatvideo.js");
		moatscript.onload = moatscript.onreadystatechange = function () {
			if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") {
				moatscript.onload = moatscript.onreadystatechange = null;
				av.scriptsLoaded++;
			}
		};
		document.getElementsByTagName('head')[0].appendChild(moatscript);

		var inlinescript = document.createElement("script");
		inlinescript.setAttribute("type", "application/javascript");
		inlinescript.setAttribute("src", host + "/videojs/inlinevideo.js");
		inlinescript.onload = inlinescript.onreadystatechange = function () {
			if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") {
				inlinescript.onload = inlinescript.onreadystatechange = null;
				av.scriptsLoaded++;
			}
		}
		document.getElementsByTagName('head')[0].appendChild(inlinescript);

    // add css
    var videocss = document.createElement("link");
    videocss.setAttribute("rel", "stylesheet");
    videocss.setAttribute("type", "text/css");
    videocss.setAttribute("href", host + '/videojs/video-js.min.css');
    document.getElementsByTagName('head')[0].appendChild(videocss);

    var vpaidcss = document.createElement("link");
    vpaidcss.setAttribute("rel", "stylesheet");
    vpaidcss.setAttribute("type", "text/css");
    vpaidcss.setAttribute("href", host + "/videojs/vpaid/videojs.vast.vpaid.min.css");
    document.getElementsByTagName('head')[0].appendChild(vpaidcss);
  }

	//////////////////////////////////////////////////////////////////////////////
	// Main playing method
	//////////////////////////////////////////////////////////////////////////////

  SAVASTPlayer.prototype.play = function (url, type, isVPAID){
    var av = this;

    av.url = url;
    av.type = type;
    av.isVPAID = isVPAID;

		// create the UI elements
		av.div = av.createHoldingDiv ();
		av.cronographBg = av.createCronographBackground ();
    av.cronograph = av.createCronograph ();
		av.clicker = av.createClicker ();
    av.mask = av.createMask ();
    av.video = av.isVPAID ? av.createVPAIDVideo () : av.createNormalVideo ();
    av.skip = av.createSkip ();
    av.padlock = av.createPadlock ();
    av.playbtn = av.createPlay ();
		av.div.appendChild(av.video);
		av.parent.appendChild(av.div);

		// wait to actually display & play after all the scripts have been loaded
    var readyInterval = setInterval(function () {
			if (av.scriptsLoaded == av.cMAX_SCRIPTS_LOADED) {
        av.playWithDelay();
        clearInterval(readyInterval);
      }
    }, 250);
  }

  SAVASTPlayer.prototype.playWithDelay = function(){
    var av = this;

    var options = {};
    var ready = function() {}

		// regiter moat events
		av.registerMoatEvents();

		//
		// Normal case (on both mobile & desktop)
		// where the data source is a normal type media file (mp4)
		if (!av.isVPAID) {

			// add a source
			av.video.setAttribute('src', av.url);

			// add UI elements
			av.div.appendChild(av.mask);
			av.div.appendChild(av.cronographBg);
			av.div.appendChild(av.cronograph);
			av.div.appendChild(av.clicker);

			// in case of mobile add a button
			if (av.isMobile) {
				// make the video inline playable on mobile
				makeVideoPlayableInline(av.video);

				// add a play button
				av.div.appendChild(av.playbtn);

				// add a click event associated w/ the play button
	      av.playbtn.addEventListener("click", function(e){
	        av.div.removeChild(av.playbtn);
	        av.playbtn = null;
	        av.video.play();

					// player has just started
					if (av.didStartPlayer != null && !av.isStartHandled){
						av.isStartHandled = true;
						av.didStartPlayer ();
					}
	      }, false);
			}
			// if it's not mobile then start playing
			else {
				av.video.play ();

				// player has just started
				if (av.didStartPlayer != null && !av.isStartHandled){
					av.isStartHandled = true;
					av.didStartPlayer ();
				}
			}

			// if the video's one of ours we add a padlock
			if (av.hasPadlock) {
				av.div.appendChild(av.padlock);
			}

			// add ended events
			av.video.addEventListener('ended', function (e) {
				if (av.didReachEnd != null && !av.isEndHandled){
					av.isEndHandled = true;
					av.didReachEnd();
				}

				if (av.interval) {
					clearInterval(av.interval);
				}

				if (av.cronograph){
					av.cronograph.innerHTML = "Ad: 0";
				}
			} ,false);

			// add error events
			av.video.onerror = function (e) {
				if (av.didPlayWithError != null) {
					av.isErrorHandled = true;
					av.didPlayWithError ();
				}

				// update interface
				if (av.cronograph){
					av.cronograph.innerHTML = "Error";
				}

				return;
			}

			// when we get metadata about player duration we consider it ready
			av.video.addEventListener('durationchange', function() {

				// send player ready events
				if (av.didFindPlayerReady != null && !av.isReadyHandled){
					av.isReadyHandled = true;
					av.didFindPlayerReady ();
				}

				// also set an interval for the timer
				av.interval = setInterval(function(){
					// checks
					if (av.video == null) {
						clearInterval(av.interval);
						return;
					}

					// calc interval
					var cTime = parseInt(av.video.currentTime);
					var mTime = parseInt(av.video.duration);
					var left = parseInt(mTime - cTime);

					// turn into skippable
					if (cTime >= 30 && av.isSkippable) {
						av.div.appendChild(av.skip);
						av.isSkippable = false;
					}

					// callbacks
					if (cTime >= 0.25 * mTime && !av.isFirstQuartileHandled && av.didReachFirstQuartile != null ){
						av.isFirstQuartileHandled = true;
						av.didReachFirstQuartile ();
					}

					if (cTime >= 0.5 * mTime && !av.isMidpointHandled && av.didReachMidpoint != null){
						av.isMidpointHandled = true;
						av.didReachMidpoint ();
					}

					if (cTime >= 0.75 * mTime && !av.isThirdQuartileHandled && av.didReachThirdQuartile != null){
						av.isThirdQuartileHandled = true;
						av.didReachThirdQuartile();
					}

					// update time label
					if (av.cronograph){
						av.cronograph.innerHTML = "Ad: " + left;
					}

					// stop interval
					if (left <= 0){
						clearInterval(av.interval);
					}
				}, 1000);
			});
		}
		//
		// VPAID case (only on desktop)
		else {
			// set flash player
			videojs.options.flash.swf = host + "/videojs/video-js.swf";

			videojs.plugin('ads-setup', function molVastSetup (opts) {
				var player = this;
				var vastAd = player.vastClient ({
					playAdAlways: true,
					adTagUrl: av.url,
					adCancelTimeout: 3000,
					adsEnabled: true,
					vpaidFlashLoaderPath: host + "/VPAIDFlash.swf"
				});

				player.on('vast.adError', function () {
					if (av.didPlayWithError != null) {
						av.isErrorHandled = true;
						av.didPlayWithError ();
					}
				});
				player.on('vast.adsCancel', function () {
					if (av.didPlayWithError != null) {
						av.isErrorHandled = true;
						av.didPlayWithError ();
					}
				});
				player.on('vast.adEnd', function () {
					if (av.didReachEndOfVPAID != null && !av.isEndHandled) {
						av.isEndHandled = true;
						av.didReachEndOfVPAID ();
					}
				});
				player.on('vast.adStart', function () {
					// do nothing
				});
			});

			var video = videojs (av.id, {
				autoplay: !av.isMobile,
				"plugins": {
					"ads-setup":{}
				}
			}).ready(function(){
				var player = this;

				// make the cronograph not have any timer
				av.div.appendChild(av.mask);
				av.div.appendChild(av.cronographBg);
				av.div.appendChild(av.cronograph);

				if (av.didFindPlayerReady != null && !av.isReadyHandled){
					av.isReadyHandled = true;
					av.didFindPlayerReady ();
				}

				// if it's mobile
				if (av.isMobile) {
					// add a play button
					av.div.appendChild(av.playbtn);

					// add a click event associated w/ the play button
		      av.playbtn.addEventListener("click", function(e){
		        av.div.removeChild(av.playbtn);
		        av.playbtn = null;
		        player.play();

						// player has just started
						if (av.didStartPlayer != null && !av.isStartHandled){
							av.isStartHandled = true;
							av.didStartPlayer ();
						}
		      }, false);
				}
				// if it's not a mobile device I'm trying to display VPAID on ...
				else {
					// finally play
					player.play();

					// player has just started
					if (av.didStartPlayer != null && !av.isStartHandled){
						av.isStartHandled = true;
						av.didStartPlayer ();
					}
				}
			});
		}
  }

	SAVASTPlayer.prototype.createHoldingDiv = function () {
		var av = this;
		var div1 = document.createElement('div');
		div1.style.width = "100%";
		div1.style.height = "100%";
		div1.style.position = "relative";
		var div2 = document.createElement('div');
		div2.style.width = "100%";
		div2.style.width = "100%";
		div2.style.position = "absolute";
		div2.style.top = "0";
		div1.appendChild(div2);
		return div1;
	}

  SAVASTPlayer.prototype.createVPAIDVideo = function () {
    var av = this;
    var video = document.createElement('video');
    video.style.width = "100%";
    video.style.height = "100%";
    video.style.backgroundColor = '#000000';
    video.setAttribute('id', av.id);
		video.setAttribute('playsinline', true);
    video.setAttribute('class', 'video-js vjs-default-skin');
    return video;
  }

	SAVASTPlayer.prototype.createNormalVideo = function () {
		var av = this;
		var video = document.createElement('video');
	  video.style.width = "100%";
	  video.style.height = "100%";
		video.style.backgroundColor = '#000000';
	  video.setAttribute('id', av.id);
		video.setAttribute('playsinline', true);
		return video;
	}

	SAVASTPlayer.prototype.createCronographBackground = function () {
		var cronographBg = document.createElement('img');
		cronographBg.style.width = '50px';
		cronographBg.style.height = '20px';
		cronographBg.style.position = 'absolute';
		cronographBg.style.left = '5px';
		cronographBg.style.zIndex = 998;
		cronographBg.setAttribute('src',  host + '/images/sa_cronograph.png');
    cronographBg.style.bottom = '5px';
		return cronographBg;
	}

  SAVASTPlayer.prototype.createCronograph = function () {
    var cronograph = document.createElement('div');
    cronograph.style.width = '50px';
    cronograph.style.height = '20px';
    cronograph.style.position = 'absolute';
    cronograph.style.left = '5px';
    cronograph.style.bottom = '5px';
		cronograph.style.fontFamily = 'Arial';
    cronograph.innerHTML = "Ad";
    cronograph.style.color = 'white';
    cronograph.style.zIndex = 999;
    cronograph.style.fontSize = '10px';
    cronograph.style.lineHeight = '20px';
    cronograph.style.textAlign = 'center';
    return cronograph;
  }

  SAVASTPlayer.prototype.createClicker = function () {
    var av = this;

    var clicker;

    if (av.has_small_button) {
      clicker = document.createElement('div');
      clicker.style.width = '100px';
      clicker.style.height = '20px';
      clicker.style.position = 'absolute';
      clicker.style.left = '60px';
      clicker.style.bottom = '5px';
      clicker.innerHTML = 'Find out more »';
			clicker.style.fontFamily = 'Arial';
      clicker.style.color = 'white';
      clicker.style.zIndex = 999;
      clicker.style.fontSize = '10px';
      clicker.style.background = 'transparent';
      clicker.style.lineHeight = '20px';
      clicker.style.cursor = 'pointer';
    } else {
      clicker = document.createElement('div');
      clicker.style.width = '100%';
      clicker.style.height = '100%';
      clicker.style.left = '0';
      clicker.style.top = '0';
      clicker.style.position = 'absolute';
      clicker.style.background = 'transparent';
      clicker.style.cursor = 'pointer';
    }

    clicker.addEventListener('click', function(event){
      /** go to URL */
      if (av.didGoToURL != null) {
        av.didGoToURL();
      }
    });

    return clicker;
  }

  SAVASTPlayer.prototype.createSkip = function () {
    var av = this;
    var skip = document.createElement('div');
    skip.style.width = '100px';
    skip.style.height = '30px';
    skip.style.position = 'absolute';
    skip.style.right = '0px';
    skip.style.bottom = '25px';
    skip.innerHTML = 'Skip Ad »';
    skip.style.textAlign = "center";
    skip.style.color = 'white';
    skip.style.zIndex = 999;
    skip.style.fontSize = '12px';
    skip.style.background = 'rgba(0, 0, 0, 0.5)';
    skip.style.borderTop = "1px solid #afafaf";
    skip.style.borderBottom = "1px solid #afafaf";
    skip.style.borderLeft = "1px solid #afafaf";
    skip.style.lineHeight = '30px';
    skip.style.cursor = 'pointer';
    skip.addEventListener('click', function(event){
      if (av.didSkipAd != null) {
        av.didSkipAd();
      }
    });
    return skip;
  }

  SAVASTPlayer.prototype.createMask = function () {
    var mask = document.createElement('img');
    mask.src = window['awesomeads_host']+"/v2/images/sa_mark.png";
    mask.style.width = '100%';
    mask.style.height = '30px';
    mask.style.position = 'absolute';
    mask.style.left = '0px';
    mask.style.bottom = '0px';
    return mask;
  }

  SAVASTPlayer.prototype.createPadlock = function () {
    var av = this;
    var padlock = document.createElement("img");
    padlock.src = window['awesomeads_host']+"/v2/images/watermark_67x25.png";
    padlock.style.position = "absolute";
    padlock.style.zIndex = 1000;
    padlock.style.top = "0px";
    padlock.style.left = "0px";
    padlock.addEventListener("click", function (e){
      window.open("http://www.superawesome.tv/en/padlock", "_blank");
    });
    padlock.style.setProperty("width", "67px", "important");
    padlock.style.setProperty("height", "25px", "important");
    return padlock;
  }

  SAVASTPlayer.prototype.createPlay = function () {
    var av = this;

    playBtnBack = document.createElement('div');
    playBtnBack.style.width = '100%';
    playBtnBack.style.height = '100%';
    playBtnBack.style.left = '0';
    playBtnBack.style.top = '0';
    playBtnBack.style.backgroundColor = 'rgba(0, 0, 0, 0.25)';
    playBtnBack.style.zIndex = 1500;
    playBtnBack.style.position = 'absolute';
    playBtnBack.style.cursor = 'pointer';

    var playBtn = document.createElement("img");
    playBtn.src = window['awesomeads_host']+"/v2/images/play_red.png";
    playBtn.style.setProperty("width", "48px", "important");
    playBtn.style.setProperty("height", "48px", "important");
    playBtn.style.position = "absolute";
    playBtn.style.left = "50%";
    playBtn.style.top = "50%";
    playBtn.style.marginLeft = "-24px";
    playBtn.style.marginTop = "-24px";

    playBtnBack.appendChild(playBtn);
    return playBtnBack;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Remove functions
  //////////////////////////////////////////////////////////////////////////////*/

  SAVASTPlayer.prototype.remove = function () {
    var av = this;
		var parent = av.parent;
		var parentNode = av.parentNode;
		if (parent != null && parent.removeChild && av.div != null) {
			parent.removeChild(av.div);
		}
		if (parentNode != null && parentNode.removeChild && av.div != null) {
			parentNode.removeChild(av.div);
		}
  }

	//////////////////////////////////////////////////////////////////////////////
	// Moat functions
  //////////////////////////////////////////////////////////////////////////////

	SAVASTPlayer.prototype.registerMoatEvents = function(){

		// get "this" local instance
		var av = this;

		// designate the Ids
		var ids = {
			"level1": av.ad.advertiserId,
			"level2": av.ad.campaign_id,
			"level3": av.ad.line_item_id,
			"level4": av.ad.creative.id,
			"slicer1": av.ad.app,
			"slicer2": av.ad.placement_id,
			"slicer3": av.ad.publisherId
		};

		// create a moat api reference
		av.MoatApiReference = initMoatTracking(av.video, ids, 30, "superawesomejsvideo335241036558");
  }

  //////////////////////////////////////////////////////////////////////////////
	// Player Callbacks
  //////////////////////////////////////////////////////////////////////////////

  SAVASTPlayer.prototype.setDidFindPlayerReady = function(callback){
    var av = this;
    av.didFindPlayerReady = callback;
  }

  SAVASTPlayer.prototype.setDidStartPlayer = function(callback){
    var av = this;
    av.didStartPlayer = callback;
  }

  SAVASTPlayer.prototype.setDidReachFirstQuartile = function(callback){
    var av = this;
    av.didReachFirstQuartile = callback;
  }

  SAVASTPlayer.prototype.setDidReachMidpoint = function(callback){
    var av = this;
    av.didReachMidpoint = callback;
  }

  SAVASTPlayer.prototype.setDidReachThirdQuartile = function(callback){
    var av = this;
    av.didReachThirdQuartile = callback;
  }

  SAVASTPlayer.prototype.setDidReachEnd = function(callback){
    var av = this;
    av.didReachEnd = callback;
  }

  SAVASTPlayer.prototype.setDidReachEndOfVPAID = function(callback) {
    var av = this;
    av.didReachEndOfVPAID = callback;
  }

  SAVASTPlayer.prototype.setDidPlayWithError = function(callback){
    var av = this;
    av.didPlayWithError = callback;
  }

  SAVASTPlayer.prototype.setDidGoToURL = function(callback){
    var av = this;
    av.didGoToURL = callback;
  }

  SAVASTPlayer.prototype.setDidSkipAd = function(callback) {
    var av = this;
    av.didSkipAd = callback;
  }

  // final return
  return SAVASTPlayer;
}).call();
