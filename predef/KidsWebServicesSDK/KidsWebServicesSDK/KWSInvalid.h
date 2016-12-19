//
//  KWSInvalid.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import <UIKit/UIKit.h>
#import "SAJsonParser.h"

@class KWSParentEmailError;

/**
 *  Object representing an Invalid parent email
 */
@interface KWSInvalid : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

// Object representing an invalid parent email error
@property (nonatomic, strong) KWSParentEmailError *parentEmail;

@end
