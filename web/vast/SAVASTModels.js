/** Define two valid types of ads, and one invalid */
var SAAdType = {
  Invalid : -1,
  InLine : 0,
  Wrapper : 1
}

/** Define a creative type "enum" */
var SAVASTCreativeType = {
  Linear : 0,
  NonLinear : 1,
  CompanionAds : 2
}

/**
 * Object that encompasses VPAID
 */
function SAVASTObject() {
  var m = this;

  /** instance vars */
  m.ads = [];
  m.isVPAID = false;
  m.urlVPAID = null;
}

/**
 * The basic VAST Ad representation in JS
 */
function SAVASTAd() {
  var m = this;

  /** then the rest of the instance vars */
  m.id = null;
  m.type = SAAdType.Invalid;
  m.sequence = null;
  m.errors = [];
  m.impressions = [];
  m.creatives = [];

  SAVASTAd.prototype.sumAd = function (ad){
    m.id = ad.id;
    m.sequence = ad.sequence;
    m.errors = m.errors.concat(ad.errors);
    m.impressions = m.impressions.concat(ad.impressions);
    for (var i = 0; i < m.creatives.length; i++){
      for (var j = 0; j < ad.creatives.length; j++){
        m.creatives[i].sumLinearCreative(ad.creatives[j]);
      }
    }
  }
}

/**
 * The structure of an impression
 */
function SAImpression() {
  var m = this;
  m.isSent = false;
  m.url = null;
}

/**
 * The structure of a linear creative
 */
function SALinearCreative() {
  var m = this;

  /** instance vars */
  m.id = null;
  m.type = SAVASTCreativeType.Linear;
  m.sequence = null;
  m.duration = null;
  m.clickThrough = null;
  m.playableMediaFile = null;
  m.mediaFiles = [];
  m.trackingEvents = [];
  m.clickTracking = [];
  m.customClicks = [];

  SALinearCreative.prototype.sumLinearCreative = function(linear) {
    m.id = linear.id;
    m.sequence = linear.sequence;
    m.duration = linear.duration;

    if (m.clickThrough != null){
      m.clickThrough = m.clickThrough;
    }
    if (linear.clickThrough != null){
      m.clickThrough = linear.clickThrough;
    }

    if (m.playableMediaFile && m.playableMediaFile.url != null){
      m.playableMediaFile.url = m.playableMediaFile.url;
    }
    if (linear.playableMediaFile && linear.playableMediaFile.url != null){
      m.playableMediaFile.url = linear.playableMediaFile.url;
    }

    if (m.playableMediaFile && m.playableMediaFile.type != null){
      m.playableMediaFile.type = m.playableMediaFile.type;
    }
    if (linear.playableMediaFile && linear.playableMediaFile.type != null){
      m.playableMediaFile.type = linear.playableMediaFile.type;
    }

    if (m.playableMediaFile && m.playableMediaFile.apiFramework != null){
      m.playableMediaFile.apiFramework = m.playableMediaFile.apiFramework;
    }
    if (linear.playableMediaFile && linear.playableMediaFile.apiFramework != null){
      m.playableMediaFile.apiFramework = linear.playableMediaFile.apiFramework;
    }

    m.mediaFiles = m.mediaFiles.concat(linear.mediaFiles);
    m.trackingEvents = m.trackingEvents.concat(linear.trackingEvents);
    m.clickTracking = m.clickTracking.concat(linear.clickTracking);
    m.customClicks = m.customClicks.concat(linear.customClicks);
  }
}

function SANonLinearCreative() {
  /** empty implementation */
}

function SACompanionAdsCreative() {
  /** empty implementation */
}

/**
 * A tracking object
 */
function SATracking () {
  var m = this;
  m.event = null;
  m.url = null;
}

/**
 * And the media file object
 */
function SAMediaFile() {
  var m = this;
  m.width = null;
  m.height = null;
  m.type = null;
  m.apiFramework = null;
  m.url = null;
}
