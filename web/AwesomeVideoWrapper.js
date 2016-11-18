var AwesomeVideoWrapper = (function(){

  // the SuperAwesome constant
  var SA_CONST = "superawesome.tv/v2/adwrapper.js";

  var AwesomeVideoWrapper = function (placement_id){
    var av = this;

    // find out the 'good' script - the one that has something to do with AA
    // and contains the same placement id as this one
    av.goodScript = [];
    av.scripts = document.getElementsByTagName("script");

    for (var i = 0; i < av.scripts.length; i++){
      if (av.scripts[i].src.indexOf(SA_CONST) !== -1 && av.scripts[i].src.indexOf(""+placement_id+"") !== -1){
        av.goodScript.push(av.scripts[i]);
      }
    }

    // something happened - return error
    if (!av.goodScript.length){
      console.error('[AA :: ERROR] Could not find a valid placement ID in your script tag');
      return;
    }

    for (var i = 0; i < av.goodScript.length; i++) {
      // now we can start loading stuff
      av.movId = av.goodScript[i].getAttribute('data-post-ad-container');
      av.test = (av.goodScript[i].getAttribute('data-test-enabled') === "true");
      av.smallClick = (av.goodScript[i].getAttribute('data-has-small-click') === "true");
      av.isSkippable = (av.goodScript[i].getAttribute('data-is-skippable') === "true");
      av.mov = document.getElementById(av.movId);

      if (av.mov) break;
    }

    /** check for invalid dom element */
    if (!av.mov) {
      console.error('[AA :: ERROR] Did not find a DOM element with the specified id ' + av.movId);
      return;
    }

    av.childrenDisplays = [];
    av.children = av.mov.children;
    for (var i = 0; i < av.children.length; i++){
      av.childrenDisplays.push(av.children[i].style.display);
      av.children[i].style.display = "none";
    }

    // create new element for the video part
    av.prerollHolder = document.createElement("div");
    av.prerollHolder.id = "prerollHolder_"+ ~~(Math.random()*10000000);
    av.prerollHolder.style.width = "100%";
    av.prerollHolder.style.height = "100%";
    av.mov.appendChild(av.prerollHolder);

		var options = {};
		options.test = av.test;

		// first load the ad
		AwesomeAdManager.get_ad(placement_id, options, function(err, ad_response){
			if(err){
				console.error(err);
				return;
			}

			// load the awesome video ad
	    av.videoAd = new AwesomeVideo(placement_id, av.test, av.prerollHolder, av.isSkippable, av.smallClick, ad_response);
	    av.videoAd.writePreloaded();
	    av.videoAd.onFinished(function (){

	      // when all ends - return the original content to its initial display state
	      for (var i = 0; i < av.children.length; i++){
	        av.children[i].style.display = av.childrenDisplays[i];
	      }

				if (av.prerollHolder.parentNode) {
					av.prerollHolder.parentNode.removeChild(av.prerollHolder);
				}
	    });
	    av.videoAd.onError(function(){
	      // on error - just display the original content
	      for (var i = 0; i < av.children.length; i++){
	        av.children[i].style.display = av.childrenDisplays[i];
	      }

				if (av.prerollHolder.parentNode) {
					av.prerollHolder.parentNode.removeChild(av.prerollHolder);
				}

	      console.error('[AA :: ERROR] - Client encountered error when playing preroll - switching to content');
	    });
	    av.videoAd.onEmpty(function(){
	      // on empty - just display the original content
	      for (var i = 0; i < av.children.length; i++){
	        av.children[i].style.display = av.childrenDisplays[i];
	      }

				if (av.prerollHolder.parentNode) {
					av.prerollHolder.parentNode.removeChild(av.prerollHolder);
				}

	      console.error('[AA :: ERROR] - Client encountered empty ad - switching to content');
	    });
		});

    return av;
  }

  return AwesomeVideoWrapper;

}).call();
