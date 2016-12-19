//
//  KWSAppData.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "SAJsonParser.h"

@interface KWSAppData : SABaseObject <SASerializationProtocol, SADeserializationProtocol>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger value;
@end
