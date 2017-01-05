//
//  KWSInvalid.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import <UIKit/UIKit.h>

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

@class KWSParentEmailError;

/**
 *  Object representing an Invalid parent email
 */
@interface KWSInvalid : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

// Object representing an invalid parent email error
@property (nonatomic, strong) KWSParentEmailError *parentEmail;

@end
