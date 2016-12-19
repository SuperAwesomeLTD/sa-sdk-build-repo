//
//  SAResponse.h
//  Pods
//
//  Created by Gabriel Coman on 27/09/2016.
//
//

#import <Foundation/Foundation.h>

// forward declaration of SAAd
@class SAAd;

// guarded import
#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

// local import
#import "SACreative.h"

@interface SAResponse : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) SACreativeFormat format;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray<SAAd*> *ads;

@end
