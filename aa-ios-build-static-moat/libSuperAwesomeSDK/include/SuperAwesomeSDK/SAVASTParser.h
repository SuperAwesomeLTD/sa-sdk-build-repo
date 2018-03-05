/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAVASTAd;
@class SAVASTMedia;
@class SAXMLElement;

// method callback
typedef void (^saDidParseVAST)(SAVASTAd *ad);

/**
 * Class that abstracts away the complexities of parsing a VAST XML response
 */
@interface SAVASTParser : NSObject

/**
 * Method that starts the VAST parsing by calling the internal 
 * recursive parsing method
 *
 * @param url       the initial VAST url to call
 * @param response  a copy of the saDidParseVAST callback block
 */
- (void) parseVAST:(NSString*) url
      withResponse:(saDidParseVAST) response;

/**
 * Method that parses an XML containing a VAST ad into a SAVASTAd object
 *
 * @param element   the XML Element
 * @return          a SAVASTAd object
 */
- (SAVASTAd*) parseAdXML: (SAXMLElement*) element;

/**
 * Method that parses a VAST XML media element and returns a SAVASTMedia object
 *
 * @param element   the source XML element
 * @return          a SAMedia object
 */
- (SAVASTMedia*) parseMediaXML: (SAXMLElement*) element;

@end
