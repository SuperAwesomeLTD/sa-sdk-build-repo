/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SABaseObject.h"

@implementation SABaseObject
@end

@implementation SABaseObject (SAJson)

/**
 * Default implementation of the "initWithJsonDictionary" method
 *
 * @param jsonDictionary   the json dictionary to try to perform parsing from
 * @return                 an instance of the object
 */
- (id) initWithJsonDictionary:(NSDictionary*) jsonDictionary {
    
    // guard
    if (jsonDictionary == NULL) return NULL;
    if ([jsonDictionary isKindOfClass:[NSNull class]]) return NULL;
    
    // regular init
    if (self = [self init]){
        
    }
    return self;
}

/**
 * Default implementation of the "initWithJsonString" method
 *
 * @param jsonString   a json string
 * @return             an instance of the object
 */
- (id) initWithJsonString:(NSString*) jsonString {
    // jsonDictionary here *should* never be null
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithJsonString:jsonString];
    
    if (self = [self initWithJsonDictionary:jsonDictionary]) {
        
    }
    return self;
}

/**
 * Default implementation of the "initWithJsonData" method
 *
 * @param jsonData  json as NSData
 * @return          an instance of the object
 */
- (id) initWithJsonData:(NSData*) jsonData {
    // jsonDictionary here *should* never be null
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithJsonData:jsonData];
    
    if (self = [self initWithJsonDictionary:jsonDictionary]) {
        
    }
    return self;
}

/**
 * Default implementation of the "isValid" method
 *
 * @return true or false
 */
- (BOOL) isValid {
    return true;
}

/**
 * Default implementation of the "dictionaryRepresentation" method
 *
 * @return a dictionary
 */
- (NSDictionary*) dictionaryRepresentation {
    // @warn: must return nil or else arrays of strings or other objects won't
    // be represented correctly
    return nil;
}

/**
 * Default implementation of the "jsonPreetyStringRepresentation" method
 *
 * @return a json string (classy)
 */
- (NSString*) jsonPreetyStringRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return nil;
}

/**
 * Default implementation of the "jsonCompactStringRepresentation" method
 *
 * @return a json string (compact)
 */
- (NSString*) jsonCompactStringRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return nil;
}

/**
 * Default implementation of the "jsonDataRepresentation" method
 *
 * @return a NSData object containing the string
 */
- (NSData*) jsonDataRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        return [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
    }
    return nil;
}

@end
