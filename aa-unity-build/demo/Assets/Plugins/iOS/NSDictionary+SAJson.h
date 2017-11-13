/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAJsonParser.h"

/**
 *  Extension to NSDictionary to add serializaiton and deserializaiton functions
 */
@interface NSDictionary (SAJson) <SASerializationProtocol, SADeserializationProtocol>
@end
