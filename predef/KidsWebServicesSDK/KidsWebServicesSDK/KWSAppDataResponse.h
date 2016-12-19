//
//  KWSAppDataResponse.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "SAJsonParser.h"
#import "KWSAppData.h"

@interface KWSAppDataResponse : SABaseObject <SADeserializationProtocol, SASerializationProtocol>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSArray<KWSAppData*> *results;
@end
