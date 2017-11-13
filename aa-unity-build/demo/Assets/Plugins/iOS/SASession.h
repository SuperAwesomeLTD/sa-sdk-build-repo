/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * This enum holds the two possible ad server configurations the 
 * SDK should respond to:
 *  - PRODUCTION
 *  - STAGING
 */
typedef NS_ENUM(NSInteger, SAConfiguration) {
    PRODUCTION  = 0,
    STAGING     = 1
};

/**
 * This external static method is used to init the SAConfiguration enum
 * starting from an integer value.
 *
 * @param configuration an int that will get translated to an enum
 * @return              a new SAConfiguration var. If configuration == 0
 *                      then return PRODUCTION value, else return STAGING
 */
static inline SAConfiguration getConfigurationFromInt (int configuration) {
    return configuration == 0 ? PRODUCTION : STAGING;
}

/**
 * Class that manages an AwesomeAds session, containing all variables 
 * needed to setup loading for a certain ad
 */
@interface SASession : NSObject

/**
 * Explicit configuration setup, which also sets the base session URL
 *
 * @param configuration a new configuration enum
 */
- (void) setConfiguration:(SAConfiguration) configuration;

/**
 * Implicit production setter
 */
- (void) setConfigurationProduction;

/**
 * Implicit staging setter
 */
- (void) setConfigurationStaging;

/**
 * Explicit test setup
 *
 * @param testEnabled the new setup, as a bool
 */
- (void) setTestMode:(BOOL) testEnabled;

/**
 * Implicit test enabled setter
 */
- (void) enableTestMode;

/**
 * Implicit test disabled setter
 */
- (void) disableTestMode;

/**
 * Setter for the DAU ID value
 *
 * @param dauId the new DAU ID integer
 */
- (void) setDauId:(NSUInteger)dauId;

/**
 * Version setter
 *
 * @param version new version string
 */
- (void) setVersion:(NSString *)version;

/**
 * Getter for the base url
 *
 * @return the current base URL
 */
- (NSString*) getBaseUrl;

/**
 * Getter for the test model
 *
 * @return the current testEnabled variable
 */
- (BOOL) getTestMode;

/**
 * Getter for the DAU ID
 *
 * @return the current dauId variable
 */
- (NSUInteger) getDauId;

/**
 * Getter for the version
 *
 * @return the current version variable
 */
- (NSString*) getVersion;

/**
 * Getter for the configuration
 *
 * @return the current configuration variable
 */
- (SAConfiguration) getConfiguration;

/**
 * Getter for the cache buster
 *
 * @return a random int
 */
- (NSInteger) getCachebuster;

/**
 * Getter for the bundle id
 *
 * @return the current bundle name
 */
- (NSString*) getBundleId;

/**
 * Getter for the app name
 *
 * @return the current app name
 */
- (NSString*) getAppName;

/**
 * Getter for the connection type
 *
 * @return the current connection type enum
 */
- (NSInteger) getConnectivityType;

/**
 * Getter for the current language
 *
 * @return the current lang variable (as en_US)
 */
- (NSString*) getLang;

/**
 * Getter for the current device
 *
 * @return the current device variable ("phone" or "tablet")
 */
- (NSString*) getDevice;

/**
 * Getter for the current user agent
 *
 * @return the current userAgent variable
 */
- (NSString*) getUserAgent;

@end
