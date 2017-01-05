//
//  KWSTokenResponse.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

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

@interface KWSAccessToken : SABaseObject <SASerializationProtocol, SADeserializationProtocol, NSCoding>
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, assign) NSInteger expires_in;
@end
