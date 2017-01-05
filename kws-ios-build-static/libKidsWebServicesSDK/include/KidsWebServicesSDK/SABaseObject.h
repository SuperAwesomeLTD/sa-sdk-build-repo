//
//  SABaseObject.h
//  Pods
//
//  Created by Gabriel Coman on 12/06/2016.
//
//

#import <Foundation/Foundation.h>

#import "NSArray+SAJson.h"
#import "NSDictionary+SAJson.h"
#import "NSDictionary+SafeHandling.h"

@interface SABaseObject : NSObject
@end

@interface SABaseObject (SAJson) <SADeserializationProtocol, SASerializationProtocol>
@end
