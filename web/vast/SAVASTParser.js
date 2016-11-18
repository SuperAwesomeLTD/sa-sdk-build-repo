var SAVASTParser = (function(){

	@import("../utils/SAUtils.js");
	@import("SAVASTModels.js");
	@import("SAVASTUtils.js");

	var SAVASTParser = function() {}

	SAVASTParser.prototype.parseVAST = function (url, initial, refAd, callback, error) {
		var av = this;

		SAUtils.sendAsyncGET(url, function (root) {

			// sum ads
			var ad = av.parseAdXML (root);
			if (refAd != null) {
				ad.sumAd(refAd);
			}

			// get the VAST wrapper URI, if it exists
			var tagURIElement = SAVASTUtils.findFirstInstanceInSiblingsAndChildren(root, "VASTAdTagURI");

			// for wrappers
			if (tagURIElement) {
				var tagURI = tagURIElement.firstChild.nodeValue;
				av.parseVAST (tagURI, initial, ad, callback, error);
			}
			// for the last inline
			else {
				if (callback != null) {
					var vastobject = av.formVASTObject(ad, initial);
					callback (vastobject);
				}
			}
		});
	}

	/**
   * Function that returns a SAVAST object
   * @param ads - an array of ads
   * @param url - the source URL
   */
  SAVASTParser.prototype.formVASTObject = function(ad, url) {
    var av = this;
    var obj = new SAVASTObject();
    obj.ads = [ ad ];

		for (var i = 0; i < obj.ads.length; i++) {
      var ad = obj.ads[i];
      for (var j = 0; j < ad.creatives.length; j++){
        var creative = ad.creatives[j];
        if (creative.playableMediaFile.apiFramework === 'VPAID') {
            obj.isVPAID = true;
            obj.urlVPAID = url;
        }
      }
    }

    if (obj.isVPAID) {
      obj.ads = null;
    }

    return obj;
  }

	SAVASTParser.prototype.parseAdXML = function(element) {
		var av = this;
    var ad = new SAVASTAd();

		SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "Error", function(errElement){
			if (errElement.firstChild != null) {
	      ad.errors.push(errElement.firstChild.nodeValue);
			}
    });

    SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "Impression", function(impElement){
      var impression = new SAImpression();
      impression.isSent = false;
			if (impElement.firstChild != null) {
      	impression.url = impElement.firstChild.nodeValue;
      	ad.impressions.push(impression);
			}
    });

		SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "Creative", function (creative){
      var linear = av.parseCreativeXML(creative);
      if (linear){
        ad.creatives.push(linear);
      }
    });

		return ad;
	}

	/**
   * Parses a basic JS XML element into a SA VAST Creative Model
   * @warnings This is made to work for linea creatives only at the moment
   * @param element - a XML element
   * @return a SACreative object
   */
  SAVASTParser.prototype.parseCreativeXML = function(element) {
    var isLinear = SAVASTUtils.checkSiblingsAndChildrenOf(element, "Linear");

    var extensions = ["mp4", "flv", "swf"];
    var types = ["video/mp4", "video/x-flv", "application/x-shockwave-flash", "application/javascript"];

    if (isLinear){
      var creative = new SALinearCreative();

      creative.type = SAVASTCreativeType.Linear;
      creative.id = element.getAttribute('id');
      creative.sequence = element.getAttribute('sequence');

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "Duration", function (durElement){
        creative.duration = durElement.nodeValue;
      });

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "ClickThrough", function (clickElement){
        creative.clickThrough = clickElement.firstChild.nodeValue;
      });

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "ClickTracking", function (ctrackElement){
        creative.clickTracking.push(ctrackElement.firstChild.nodeValue);
      });

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "CustomClicks", function (cclickElement){
        creative.customClicks.push(cclickElement.firstChild.nodeValue);
      });

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "Tracking", function (cTrackingElement){
        var tracking = new SATracking();
        tracking.event = cTrackingElement.getAttribute('event');
        tracking.url = cTrackingElement.firstChild.nodeValue;
        creative.trackingEvents.push(tracking);
      });

      SAVASTUtils.searchSiblingsAndChildrenWithIterator(element, "MediaFile", function (cMediaElement){
        var mediaFile = new SAMediaFile();
        mediaFile.width = cMediaElement.getAttribute('width');
        mediaFile.height = cMediaElement.getAttribute('height');
        mediaFile.type = cMediaElement.getAttribute('type');
        mediaFile.apiFramework = cMediaElement.getAttribute('apiFramework');
        mediaFile.url = null;
        if (cMediaElement.firstChild) {
          mediaFile.url = cMediaElement.firstChild.nodeValue;
        } else if (cMediaElement.firstChild.nextSibling) {
          mediaFile.url = cMediaElement.firstChild.nextSibling.nodeValue;
        }

        /** check the current media file has a supported type and extension */
        var hasExt = false, hasType = false;
        var extension = SAVASTUtils.returnExtension(mediaFile.url);

        for (var i = 0; i < extensions.length; i++) {
          if (extension && extension.indexOf(extensions[i]) > -1) {
            hasExt = true;
            break;
          }
        }
        for (var j = 0; j < types.length; j++) {
          if (mediaFile.type.indexOf(types[j]) > -1) {
            hasType = true;
            break;
          }
        }

        if (hasExt || hasType) {
          creative.mediaFiles.push(mediaFile);
        }
      });

      /** get the playable media file */
      if (creative.mediaFiles.length > 0) {

          // search for at least one MP4 file
          for (var t = 0; t < creative.mediaFiles.length; t++) {
              var mediaFile = creative.mediaFiles[t];
              if (mediaFile.type === "video/mp4") {
                  creative.playableMediaFile = mediaFile;
                  break;
              }
          }

          // then search for at least one FLV file
          if  (creative.playableMediaFile == null) {
              for (var k = 0; k < creative.mediaFiles.length; k++) {
                  var mediaFile = creative.mediaFiles[k];
                  if (mediaFile.type === "video/x-flv") {
                      creative.playableMediaFile = mediaFile;
                      break;
                  }
              }
          }

          // if still I can't find an MP4 or FLV, then just get whatever it's there
          if (creative.playableMediaFile == null) {
              creative.playableMediaFile = creative.mediaFiles[0];
          }
      }

      return creative;
    } else {
      return null;
    }
  }

	/** Final return */
	return SAVASTParser;
	}).call();
