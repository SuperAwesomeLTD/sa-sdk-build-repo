/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "NSArray+SAJson.h"

@implementation NSArray (SAJson)

- (NSArray*) dictionaryRepresentation {
    
    // get an empty array
    NSMutableArray *array = [@[] mutableCopy];
    
    // add objects in the original array that might respond to
    // the selector "dictionaryRepresentation"
    // the end goal is to transform an array of different objects
    // (strings, complex objects, etc) to an array of simple objects and
    // dictionaries or arrays of dictionaries
    for (id item in self){
        if ([item respondsToSelector:@selector(dictionaryRepresentation)]) {
            NSDictionary *result = [item dictionaryRepresentation];
            if (result != NULL && ![result isEqualToDictionary:@{}]) {
                [array addObject:result];
            }
        } else {
            [array addObject:item];
        }
    }
    
    if ([array count] > 0) return array;
    return self;
}

- (NSString*) jsonPrettyStringRepresentation {
    
    // get a dictionary representation of the array
    NSArray *array = (NSArray*)[self dictionaryRepresentation];
    
    // try to transform it into a valid string
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    
    // or return nil if that can't be done
    return nil;
}

- (NSString*) jsonCompactStringRepresentation {
    
    // get a dictionary representation of the array
    NSArray *array = (NSArray*)[self dictionaryRepresentation];
    
    // try to transform it into a valid string
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }

    // or return nil if that can't be done
    return nil;
}

- (NSData*) jsonDataRepresentation {
    
    // get a dictionary representation of the array
    NSArray *array = (NSArray*)[self dictionaryRepresentation];
    
    // try to transform it into a valid nsdata object
    if ([NSJSONSerialization isValidJSONObject:array]) {
        return [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    // or return nil if that can't be done
    return nil;
}

- (id) initWithJsonArray:(NSArray*)array andIterator:(SAArrayIterator)iterator {
    if (self = [self init]) {
        NSMutableArray *mutableSelf = [@[] mutableCopy];
        if (array != NULL) {
            for (id item in array) {
                [mutableSelf addObject:iterator(item)];
            }
        }
        self = mutableSelf;
    }
    
    return self;
}

+ (NSArray*) arrayWithJsonArray:(NSArray*)array andIterator:(SAArrayIterator)iterator {
    return [[NSArray alloc] initWithJsonArray:array andIterator:iterator];
}

- (id) initWithJsonString:(NSString*)json andIterator:(SAArrayIterator)iterator {
    
    // case when the json is utterly invalid (nill, null, etc)
    // just return an empty array
    if (json == nil || [json isEqual:[NSNull null]]) {
        if (self = [self init]) {
            
        }
    }
    // case when json is decent enough and can actually form an array
    else {
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        if (self = [self initWithJsonData:data andIterator:iterator]) {
            
        }
    }
    
    return self;
}

+ (NSArray*) arrayWithJsonString:(NSString *)json andIterator:(SAArrayIterator)iterator {
    return [[NSArray alloc] initWithJsonString:json andIterator:iterator];
}

- (id) initWithJsonData:(NSData*)json andIterator:(SAArrayIterator)iterator {
    
    id result = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
    
    // case when result actually is an array
    if ([result isKindOfClass:[NSArray class]]) {
        if (self = [self initWithJsonArray:result andIterator:iterator]){
            
        }
    }
    // case when result is not array
    else {
        if (self = [self init]) {
            
        }
    }
    return self;
}

+ (NSArray*) arrayWithJsonData:(NSData *)json andIterator:(SAArrayIterator)iterator {
    return [[NSArray alloc] initWithJsonData:json andIterator:iterator];
}

@end
