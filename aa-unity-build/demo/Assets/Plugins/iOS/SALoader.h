/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class SASession;
@class SAResponse;

// callback used by the SALoader class
typedef void (^saDidLoadAd)(SAResponse *response);

/**
 * This class abstracts away the loading of a SuperAwesome ad server by the server.
 * It tries to handle two major case
 *  - when the ad comes alone, in the case of image, rich media, tag, video
 *  - when the ads come as an array, in the case of app wall
 *
 * Additionally it will try to:
 *  - for image, rich media and tag ads, format the needed HTML to display the ad in a web view
 *  - for video ads, parse the associated VAST tag and get all the events and media files;
 *    also it will try to download the media resource on disk
 *  - for app wall ads, download all the image resources associated with each ad in the wall
 */
@interface SALoader : NSObject

/**
 * Method that creates the standard AwesomeAds base url starting from a
 * session (to know if it's in STAGING or PRODUCTION mode), and a placement Id
 *
 * @param session       current session
 * @param placementId   current placement Id
 * @return              an url of the form
 *                      https://ads.superawesome.tv/v2/ad/7212
 */
- (NSString*) getAwesomeAdsEndpoint: (SASession*) session
                     forPlacementId:(NSInteger) placementId;

/**
 * Method that creates the additional query paramters that will need to
 * be appended to the AwesomeAds endpoint
 *
 * @param session   current session
 * @return          a NSDictionary containing the necessary query params:
 *                  - test mode
 *                  - sdk version
 *                  - cache buster
 *                  - bundle & app name
 *                  - DAU Id for frequency capping
 *                  - connection type as an integer
 *                  - current language as "en_US"
 *                  - type of device as string, "phone" or "tablet"
 */
- (NSDictionary*) getAwesomeAdsQuery: (SASession*) session;

/**
 * Method that creates the Awesome Ads specific header needed for 
 * network requests
 *
 * @param session   current session
 * @return          a NSDictionary with header parameters
 */
- (NSDictionary*) getAwesomeAdsHeader: (SASession*) session;

/**
 * Shorthand method that only takes a placement Id and a session
 *
 * @param placementId the AwesomeAds ID to load an ad for
 * @param session     the current session to load the placement Id for
 * @param result      callback block copy so that the loader can return 
 *                    the response to the library user
 */
- (void) loadAd:(NSInteger) placementId
    withSession:(SASession*) session
      andResult:(saDidLoadAd) result;

/**
 * Method that actually loads the ad
 *
 * @param endpoint      endpoint from where to get an ad resource
 * @param query         additional query parameters
 * @param header        request header
 * @param placementId   placement Id (bc it's not returned by the request)
 * @param session       current session
 * @param result        callback copy so that the loader can return the response to the
 *                      library user
 */
- (void) loadAd:(NSString*) endpoint
      withQuery:(NSDictionary*) query
      andHeader:(NSDictionary*) header
 andPlacementId:(NSInteger) placementId
     andSession:(SASession*) session
      andResult:(saDidLoadAd) result;

- (void) processAd:(NSInteger) placementId
           andData:(NSString*) data
         andStatus:(NSInteger) status
        andSession:(SASession*) session
         andResult:(saDidLoadAd) result;
@end
