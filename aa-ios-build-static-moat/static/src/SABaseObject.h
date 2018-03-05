/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "NSArray+SAJson.h"
#import "NSDictionary+SAJson.h"
#import "NSDictionary+SafeHandling.h"

/**
 * This acts as a type of base object for all models that might be used 
 * later on by the SDK.
 * It already contains an implementation for the basic methods that would 
 * need to be implemented by a "Serializable" object
 */
@interface SABaseObject : NSObject
@end

@interface SABaseObject (SAJson) <SADeserializationProtocol, SASerializationProtocol>
@end
