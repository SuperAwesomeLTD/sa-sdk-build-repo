/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <Foundation/Foundation.h>

// method definition that helps with iterating over an array
typedef id (^SAArrayIterator)(id item);

/** 
 * A series of extension methods over NSArray that bring the same functionality
 * as defined in the SAJsonParser.h protocols
 */
@interface NSArray (SAJson)

/**
 * Function that creates the dictionary (NSArray of dictionaries) representation
 * of an array of different objects
 *
 * @return an array of dictionaries or values
 */
- (NSArray*) dictionaryRepresentation;

/**
 * Function that creates the pretty string representation of an array of
 * complex objects or values
 *
 * @return a json string (pretty)
 */
- (NSString*) jsonPrettyStringRepresentation;

/**
 * Function that creates the compact string representation of an array of
 * complex objects or values
 *
 * @return a json string (compact)
 */
- (NSString*) jsonCompactStringRepresentation;

/**
 * Function that creates the nsdata json representation of an array of
 * complex objects or values
 *
 * @return an array as nsdata
 */
- (NSData*) jsonDataRepresentation;

/**
 * Init function that initialized an array from an array of dictionaries
 *
 * @param array     array of dictionaries (or values)
 * @param iterator  iterator instance
 * @return          a new object
 */
- (id) initWithJsonArray:(NSArray*)array andIterator:(SAArrayIterator)iterator;

/**
 * Factory function that inits an array with another array and iterator
 *
 * @param array     array of dictionaries or values
 * @param iterator  iterator instance
 * @return          a new array
 */
+ (NSArray*) arrayWithJsonArray:(NSArray*)array andIterator:(SAArrayIterator)iterator;

/**
 * Init function that inits an array from a json string
 *
 * @param json      json string of array of dictionaries (or values)
 * @param iterator  iterator instance
 * @return          a new object
 */
- (id) initWithJsonString:(NSString*)json andIterator:(SAArrayIterator)iterator;

/**
 * Factory function that inits an array with a json string and iterator
 *
 * @param json      json string of array of dictionaries (or values)
 * @param iterator  iterator instance
 * @return          a new array
 */
+ (NSArray*) arrayWithJsonString:(NSString*)json andIterator:(SAArrayIterator)iterator;

/**
 * Init function that inits an array from json data
 *
 * @param json      json as nsdata
 * @param iterator  iterator instance
 * @return          a new object
 */
- (id) initWithJsonData:(NSData*)json andIterator:(SAArrayIterator)iterator;

/**
 * Factory function that inits an array with a json data object and iterator
 *
 * @param json      json as nsdata
 * @param iterator  iterator instnce
 * @return          a new array
 */
+ (NSArray*) arrayWithJsonData:(NSData*)json andIterator:(SAArrayIterator)iterator;

@end
