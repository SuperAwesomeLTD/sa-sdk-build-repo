/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * This protocol describes the functions that should be implemented by a class
 * in order to conform to deserialization
 */
@protocol SADeserializationProtocol <NSObject>

@required

/**
 * Standard init function with a Dictionary
 *
 * @param jsonDictionary   the json dictionary to try to perform parsing from
 * @return                 an instance of the object
 */
- (_Nullable id) initWithJsonDictionary:(NSDictionary* _Nullable) jsonDictionary;

@optional

/**
 * Init with JSON String; has default implementation
 *
 * @param jsonString   a json string
 * @return             an instance of the object
 */
- (_Nullable id) initWithJsonString:(NSString* _Nullable) jsonString;

/**
 * Init with JSON NSData object; has default implementation
 *
 * @param jsonData  json as NSData
 * @return          an instance of the object
 */
- (_Nullable id) initWithJsonData:(NSData* _Nullable) jsonData;

@required

/**
 * This function is used to validate that a model has been correctly
 * deserialized; Has a default implementation
 *
 * @return true or false
 */
- (BOOL) isValid;

@end

/**
 * This protocol describes the functions that must be implemented by a class in
 * order to serialize correctly using the SA method
 */
@protocol SASerializationProtocol <NSObject>

@required

/**
 * This function provides the dictionary representation of a model object;
 * Does not have a default implementation and is the only function that **must**
 * be implemented by a user
 *
 * @return a dictionary
 */
- (NSDictionary* _Nullable) dictionaryRepresentation;

@optional

/**
 * This function provides the json preety string representation of a model
 * object; It has a default implementation
 *
 * @return a JSON string
 */
- (NSString* _Nullable) jsonPreetyStringRepresentation;

/**
 * This function provides the json compact string representation of a model
 * object; It has a default implementation
 *
 * @return a JSON string
 */
- (NSString* _Nullable) jsonCompactStringRepresentation;

/**
 * This funciton provides the json NSData representation of a model object;
 * It has a default implementation
 *
 * @return a NSData object
 */
- (NSData* _Nullable) jsonDataRepresentation;

@end
