//
//  KWSTokenResponse.h
//  Pods
//
//  Created by Gabriel Coman on 10/10/2016.
//
//

#import "SAJsonParser.h"

@interface KWSAccessToken : SABaseObject <SASerializationProtocol, SADeserializationProtocol, NSCoding>
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, assign) NSInteger expires_in;
@end
