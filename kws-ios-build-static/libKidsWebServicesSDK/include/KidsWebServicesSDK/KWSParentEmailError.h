//
//  KWSParentEmailError.h
//  Pods
//
//  Created by Gabriel Coman on 27/05/2016.
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

/**
 *  Error object describing an invalid error; It has much in common with the
 *  KWSError object
 */
@interface KWSParentEmailError : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

// error code
@property (nonatomic, assign) NSInteger code;

// error meaning
@property (nonatomic, strong) NSString *codeMeaning;

// error message
@property (nonatomic, strong) NSString *errorMessage;

@end
