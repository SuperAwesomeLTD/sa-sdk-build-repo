//
//  KWSError.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import <UIKit/UIKit.h>
#import "SAJsonParser.h"

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
