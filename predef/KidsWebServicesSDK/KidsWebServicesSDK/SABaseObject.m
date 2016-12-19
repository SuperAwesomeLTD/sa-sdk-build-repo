//
//  SABaseObject.m
//  Pods
//
//  Created by Gabriel Coman on 12/06/2016.
//
//

#import "SABaseObject.h"

@implementation SABaseObject
@end

@implementation SABaseObject (SAJson)

// default implementation (that should be overridden)
- (id) initWithJsonDictionary:(NSDictionary*)jsonDictionary {
    
    // guard
    if (jsonDictionary == NULL) return NULL;
    if ([jsonDictionary isKindOfClass:[NSNull class]]) return NULL;
    
    // regular init
    if (self = [self init]){
        
    }
    return self;
}

// default implementation - should be left as it is
- (id) initWithJsonString:(NSString*)jsonString {
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithJsonString:jsonString];
    if (self = [self initWithJsonDictionary:jsonDictionary]) {
        
    }
    return self;
}

// default implementation - should be left as it is
- (id) initWithJsonData:(NSData*)jsonData {
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithJsonData:jsonData];
    if (self = [self initWithJsonDictionary:jsonDictionary]) {
        
    }
    return self;
}

// default implementation - should be left as it is
- (BOOL) isValid {
    return true;
}

// serialization

// default implementation that should be overriden
- (NSDictionary*) dictionaryRepresentation {
    // @warn: must return nil or else arrays of strings or other objects won't
    // be represented correctly
    return nil;
}

// default implementation - should be left as it is
- (NSString*) jsonPreetyStringRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return nil;
}

// default implementation - should be left as it is
- (NSString*) jsonCompactStringRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return nil;
}

// default implementation - should be left as it is
- (NSData*) jsonDataRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        return [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
    }
    return nil;
}

@end
