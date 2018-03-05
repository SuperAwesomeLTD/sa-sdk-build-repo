/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "NSDictionary+SAJson.h"

@implementation NSDictionary (SAJson)

/**
 * Extension method that gets a NSData object out of a NSDictionary object
 */
- (NSData*) jsonData:(NSJSONWritingOptions) options {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    }
    return nil;
}

/**
 * Extension method that gets a NSDictionary object out of a NSData object
 */
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

/**
 * Implementation of SASerialization "dictionaryRepresentation" method 
 * for a dictionary object
 *
 * @return the same dictionary object
 */
- (NSDictionary*) dictionaryRepresentation {
    return self;
}

/**
 * Implementation of SASerialization "jsonPreetyStringRepresentation" method 
 * for a dictionary object
 *
 * @return a valid string containing the fields of the dictionary 
           as a valid JSON string
 */
- (NSString*) jsonPreetyStringRepresentation {
    NSData *json = [self jsonData:NSJSONWritingPrettyPrinted];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

/**
 * Implementation of SASerialization "jsonCompactStringRepresentation" method
 * for a dictionary object
 *
 * @return a valid string containing the fields of the dictionary
 *         as a valid JSON string
 */
- (NSString*) jsonCompactStringRepresentation {
    NSData *json = [self jsonData:kNilOptions];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

/**
 * Implementation of SASerialization "jsonDataRepresentation" method
 * for a dictionary object
 *
 * @return a valid NSData object containing the fields of the dictionary
 *         as a valid JSON string (encoded)
 */
- (NSData*) jsonDataRepresentation {
    return [self jsonData:kNilOptions];
}

/**
 * Implementation of SADeserialization "initWithJsonDictionary" method
 * for a dictionary object
 *
 * @param jsonDictionary    a valid NSDictionary object
 * @return                  a new instance of a NSDictionary object
 */
- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [self initWithDictionary:jsonDictionary]) {
        // this is just the normal init w/ dictionary
    }
    return self;
}

/**
 * Implementation of SADeserialization "initWithJsonData" method
 * for a dictionary object
 *
 * @param jsonData    a NSData object containing JSON data
 * @return            a new instance of a NSDictionary object
 */
- (id) initWithJsonData:(NSData*) jsonData {
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

/**
 * Implementation of SADeserialization "initWithJsonString" method
 * for a dictionary object
 *
 * @param jsonString    a string containing JSON data
 * @return              a new instance of a NSDictionary object
 */
- (id) initWithJsonString:(NSString*) jsonString {
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

/**
 * Implementation of SADeserialization "isValid" method
 * for a dictionary object
 *
 * @return by default, true
 */
- (BOOL) isValid {
    return true;
}

@end

