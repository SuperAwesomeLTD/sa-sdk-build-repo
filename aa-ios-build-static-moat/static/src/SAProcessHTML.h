/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;

/**
 * Class that formats a specific HTML "website" for each type of ad that needs displaying.
 *  - For image ads a document with mostly an <img/> tag
 *  - For rich media ads a document with an <iframe> to load the content in
 *  - For external tags a div to write the tag in
 */
@interface SAProcessHTML : NSObject

/**
 * Method that loads a special HTML file and parse & format it so that later
 * on web views will be able to use it to display proper image data
 *
 * @param ad    ad data (as an SAAd object)
 * @return      the formatted HTML string to be used by a WebView
 */
+ (NSString*) formatCreativeIntoImageHTML:(SAAd*) ad;

/**
 * Method that loads a special HTML file and parse & format it so that later
 * on web views will be able to use it to display proper rich media data
 *
 * @param ad    ad data (as an SAAd object)
 * @return      the formatted HTML string to be used by a WebView
 */
+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*) ad;

/**
 * Method that loads a special HTML file and parse & format it so that later
 * on web views will be able to use it to display proper tag data
 * @param ad    ad data (as an SAAd object)
 * @return      the formatted HTML string to be used by a WebView
 */
+ (NSString*) formatCreativeIntoTagHTML:(SAAd*) ad;

@end
