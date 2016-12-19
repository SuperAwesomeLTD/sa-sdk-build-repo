//
//  KWSError.h
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

@class KWSInvalid;

/**
 *  Object representing a KWS error object that mostly represents the "invalid"
 *  type of error reported by KWS
 */
@interface KWSError : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

// error code
@property (nonatomic, assign) NSInteger code;

// error meaning
@property (nonatomic, strong) NSString *codeMeaning;

// more descriptive message
@property (nonatomic, strong) NSString *errorMessage;

// a KWSInvalid object that details the kind of "invalid" error 
@property (nonatomic, strong) KWSInvalid *invalid;
@end
