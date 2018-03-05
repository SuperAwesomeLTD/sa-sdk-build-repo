/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SACreative;
@class SADetails;
@class SAMedia;

#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/SABaseObject.h>)
#import <SAJsonParser/SABaseObject.h>
#else
#import "SABaseObject.h"
#endif
#endif

/**
 * Enum that defines the overall types of acceptable  campaigns in AwesomeAds
 *  - CPM campaigns, where cost is done "per thousand impressions"
 *  - CMI campaigns, where cost is done "per thousand installs"
 */
typedef NS_ENUM (NSInteger, SACampaignType) {
    SA_CPM = 0,
    SA_CPI = 1
};

/**
 * This external static method is used to init the SACampaignType enum
 * starting from an integer value.
 *
 * @param campaign  an int that will get translated to an enum
 * @return          a new SACampaignType variable.
 *                  - if format == 1 -> then CPI campaign
 *                  - else CMP campaign
 */
static inline SACampaignType getSACampaignTypeFromInt (NSInteger campaign) {
    return campaign == 1 ? SA_CPI : SA_CPM;
}

/**
 * Main class that contains all the information needed to play an ad and send all relevant
 * events back to our ad server.
 *  - error (not really used)
 *  - advertiser, publisher, app, line item, campaign, placement IDs
 *  - campaign type (CPM or CPI)
 *  - moat - a float value that tells the SDK when to fire Moat tracking (if available); This value
 *    is compared to a randomly generated int between 0 and 1; if the int is less than the moat
 *    value, then the whole additional tracking happens
 *  - test, is fallback, is fill, is house, safe ad approved, show padlock - flags that determine
 *    whether the SDK should show the "Safe Ad Padlock" over an ad or not
 *  - device
 *  - a SACreative object
 */
@interface SAAd : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger      error;

@property (nonatomic, assign) NSInteger      advertiserId;
@property (nonatomic, assign) NSInteger      publisherId;
@property (nonatomic, assign) NSInteger      appId;
@property (nonatomic, assign) NSInteger      lineItemId;
@property (nonatomic, assign) NSInteger      campaignId;
@property (nonatomic, assign) NSInteger      placementId;

@property (nonatomic, assign) SACampaignType campaignType;

@property (nonatomic, assign) CGFloat        moat;

@property (nonatomic, assign) BOOL           isTest;
@property (nonatomic, assign) BOOL           isFallback;
@property (nonatomic, assign) BOOL           isFill;
@property (nonatomic, assign) BOOL           isHouse;
@property (nonatomic, assign) BOOL           isSafeAdApproved;
@property (nonatomic, assign) BOOL           isPadlockVisible;

@property (nonatomic, strong) NSString       *device;

@property (nonatomic, strong) SACreative     *creative;

@property (nonatomic, assign) NSInteger      loadTime;

/**
 * Custom init with placement and json dictionary
 * 
 * @param placementId       to copy inside the model
 * @param jsonDictionary    with data about the ad
 */
- (id) initWithPlacementId: (NSInteger) placementId
         andJsonDictionary: (NSDictionary*) jsonDictionary;

@end
