//
//  NSDictionary+SAJsonExtension.m
//  Pods
//
//  Created by Gabriel Coman on 27/05/2016.
//
//

#import "NSDictionary+SAJson.h"

@implementation NSDictionary (SAJson)

// private common functions

- (NSData*) jsonData:(NSJSONWritingOptions) options {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    }
    return nil;
}

- (NSDictionary*) dictionaryFromData:(NSData*) json {
    
    if (json != nil) {
        NSError *error = nil;
        id temp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
        if (error == nil && [temp isKindOfClass:[NSDictionary class]]) {
            return temp;
        }
    }
    
    return nil;
}

// deserialization

- (NSDictionary*) dictionaryRepresentation {
    return self;
}

- (NSString*) jsonPreetyStringRepresentation {
    NSData *json = [self jsonData:NSJSONWritingPrettyPrinted];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

- (NSString*) jsonCompactStringRepresentation {
    NSData *json = [self jsonData:kNilOptions];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

- (NSData*) jsonDataRepresentation {
    return [self jsonData:kNilOptions];
}

// serialization

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [self initWithDictionary:jsonDictionary]) {
        // this is just the normal init w/ dictionary
    }
    return self;
}

- (id) initWithJsonData:(NSData *)jsonData {
    NSDictionary *temp = [self dictionaryFromData:jsonData];
    
    if (temp) {
        if (self = [self initWithJsonDictionary:temp]) {
            // operation successfull and I could init w/ a valid dict
        }
    } else {
        if (self = [self init]) {
            // operation failed so I revert back to a normal dictionary
        }
    }
    
    return self;
}

- (id) initWithJsonString:(NSString *)jsonString {
    if (jsonString != nil && ![jsonString isEqual:[NSNull null]]) {
        
        // get the json data
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (self = [self initWithJsonData:jsonData]){
            // init w/ json data
        }
    }
    else {
        if (self = [self init]) {
            // make sure that whatever the scenario I return a type of dictionary
            // (even an empty one)
        }
    }
    
    return self;
}

- (BOOL) isValid {
    return true;
}

@end

