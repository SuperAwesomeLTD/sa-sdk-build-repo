/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAXMLParser.h"

@implementation SAXMLElement

- (NSString*) getName {
    return _name;
}

- (NSString*) getValue {
    return _value;
}

- (NSString*) getAttribute:(NSString *)name {
    if (_attributes) {
        return [_attributes objectForKey:name];
    }
    return NULL;
}

@end

@interface SAXMLParser ()  <NSXMLParserDelegate>

// internal members variables needed to parse the dictionary
@property (nonatomic, strong) NSMutableDictionary *stackDict;
@property (nonatomic, assign) NSInteger           indent;
@property (nonatomic, strong) NSMutableString     *textInProgress;

@end

@implementation SAXMLParser

- (SAXMLElement*) parseXMLData:(NSData *)xml {
    return [self objectWithData:xml];
}

- (SAXMLElement*) parseXMLString:(NSString *)xml {
    return [self parseXMLData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 * This method is the actual parsing method, that tries to parse a 
 * given XML block and return the post-hoc results
 *
 * @param data a NSData object containing XML
 * @return     the root XML element, as a SAXMLElement object
 */
- (SAXMLElement*) objectWithData:(NSData *)data {
    
    // the text being parsed
    _textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    _stackDict = [[NSMutableDictionary alloc] init];
    _indent = 0;
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // post process the XML
    if (success && !_errorResult) {
        
        // fort all keys in the stack dictionary (N .... 0 levels, ordered)
        NSArray *descendingKeys = [_stackDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([(NSNumber*)obj1 integerValue] > [(NSNumber*)obj2 integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        
        // now go through all the levels from bottom to top and assign
        // children for each level
        for (NSNumber *key in descendingKeys) {
            NSInteger level = [key integerValue];
            NSInteger uplevel = [key integerValue] - 1;
            
            BOOL hasLevel = [_stackDict objectForKey:@(level)] != NULL;
            BOOL hasUpLevel = [_stackDict objectForKey:@(uplevel)] != NULL;
            
            NSArray *elements = (hasLevel ? [_stackDict objectForKey:@(level)] : @[]);
            NSArray *upelements = (hasUpLevel ? [_stackDict objectForKey:@(uplevel)] : @[]);
            
            for (SAXMLElement *element in elements) {
                
                for (SAXMLElement *upelement in upelements) {
                    if (element.parent == upelement) {
                        if (!upelement.children) upelement.children = [[NSMutableArray alloc] init];
                        [upelement.children addObject:element];
                    }
                }
            }
        }
        
        // now destroy the parent reference now
        for (NSNumber *key in descendingKeys) {
            NSArray *elements = [_stackDict objectForKey:key];
            for (SAXMLElement *element in elements) {
                element.parent = NULL;
            }
        }
        
        // create the new root element
        SAXMLElement *root = [[SAXMLElement alloc] init];
        root.name = @"SAXMLRoot";
        root.children = [_stackDict objectForKey:@(0)];
        return root;
    }
    
    NSLog(@"Error parsing!");
    return nil;
}

/**
 * Overridden NSXMLParserDelegate method that signals the start of parsing
 * for a new XML element.
 * 
 * @param parser        the current parser instance
 * @param elementName   the current XML element name
 * @param namespaceURI  the namespace URI
 * @param qName         the fully qualified XML element name
 * @param attributeDict a dictionary with attributes for the XML element
 *
 */
- (void) parser:(NSXMLParser*) parser
didStartElement:(NSString*) elementName
   namespaceURI:(NSString*) namespaceURI
  qualifiedName:(NSString*) qName
     attributes:(NSDictionary*) attributeDict {
    
    // create current element
    SAXMLElement *current = [[SAXMLElement alloc] init];
    current.name = elementName;
    current.attributes = attributeDict;
    
    // check to see
    BOOL hasLevel = [_stackDict objectForKey:@(_indent)] != NULL;
    
    NSMutableArray *levelArray = nil;
    if (!hasLevel) {
        levelArray = [[NSMutableArray alloc] init];
    } else {
        levelArray = [_stackDict objectForKey:@(_indent)];
    }
    
    // add object
    [levelArray addObject:current];
    [_stackDict setObject:levelArray forKey:@(_indent)];
    
    // increment indent
    _indent++;
}

/**
 * Overridden NSXMLParserDelegate method that signals characters were found
 * associated with a XML element (basically it's content)
 *
 * @param parser the current parser instance
 * @param string the string that's been found
 */
- (void) parser:(NSXMLParser*) parser
foundCharacters:(NSString*) string {
    // Build the text value
    [_textInProgress appendString:string];
}

/**
 * Overridden NSXMLParserDelegate method that signals the end of parsing for 
 * the current XML element.
 *
 * @param parser        the current parser instance
 * @param elementName   the current XML element name
 * @param namespaceURI  the namespace URI
 * @param qName         the fully qualified XML element name
 */
- (void) parser:(NSXMLParser*) parser
  didEndElement:(NSString*) elementName
   namespaceURI:(NSString*) namespaceURI
  qualifiedName:(NSString*) qName {
    
    // get correct indent for writing end
    NSInteger cindent = _indent - 1;
    
    // check to see
    BOOL hasLevel = [_stackDict objectForKey:@(cindent)] != NULL;
    
    // set new object
    if (hasLevel) {
        NSMutableArray *levelArray = (NSMutableArray*)[_stackDict objectForKey:@(cindent)];
        SAXMLElement *current = (SAXMLElement*)[levelArray lastObject];
        current.value = [[_textInProgress stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // set parent
        BOOL hasPrevLevel = [_stackDict objectForKey:@((cindent-1))] != NULL;
        
        if (hasPrevLevel) {
            NSMutableArray *prevLevelArray = (NSMutableArray*)[_stackDict objectForKey:@((cindent-1))];
            SAXMLElement *parent = (SAXMLElement*)[prevLevelArray lastObject];
            current.parent = parent;
        }
        
        [levelArray removeLastObject];
        [levelArray addObject:current];
        [_stackDict setObject:levelArray forKey:@(cindent)];
    }
    
    // reset text
    _textInProgress = nil;
    _textInProgress = [[NSMutableString alloc] init];
    
    // decrease indes
    _indent--;
}

/**
 * Overridden NSXMLParserDelegate method that signals an error was encountered
 * while parsing the current XML element
 * 
 * @param parser     the current parser instance
 * @param parseError the error (as a NSError object)
 */
- (void) parser:(NSXMLParser*) parser
parseErrorOccurred:(NSError*) parseError {
    // Set the error pointer to the parser's error object
    _errorResult = parseError;
}

@end

@implementation SAXMLParser (SAStaticFunctions)

+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                             forName:(NSString*) name
                                into:(NSMutableArray*) array {
    
    // explore the whole XML document tree and add matching elements
    // into the array
    for (SAXMLElement *child in element.children) {
        if ([child.name isEqualToString:name]){
            [array addObject:child];
        }
        
        [self searchSiblingsAndChildrenOf:child forName:name into:array];
    }
}

+ (NSMutableArray*) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                                        forName:(NSString*) name {
    // init container
    NSMutableArray *array = [@[] mutableCopy];
    
    // call the above function to fill the array
    [self searchSiblingsAndChildrenOf:element
                              forName:name
                                 into:array];
    
    // return the container
    return array;
}

+ (SAXMLElement*) findFirstIntanceInSiblingsAndChildrenOf:(SAXMLElement*) element
                                                  forName:(NSString*) name {
    
    // get the array of elements
    NSMutableArray *array = [self searchSiblingsAndChildrenOf:element
                                                      forName:name];
    
    // return either the first one or nil
    return array.count >= 1 ? [array firstObject] : nil;
}

+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                             forName:(NSString*) name
                         andInterate:(saDidFindXMLElement) block {
    
    
    // get an array of matching elements
    NSMutableArray *array = [self searchSiblingsAndChildrenOf:element
                                                      forName:name];
    
    // iterate over it and call the block
    for (SAXMLElement *element in array) {
        block(element);
    }
}

+ (BOOL) checkSiblingsAndChildrenOf:(SAXMLElement*) element
                            forName:(NSString*) name {
    
    // get an array of matching elements
    NSMutableArray *array = [self searchSiblingsAndChildrenOf:element
                                                          forName:name];
    
    // return whether at least one element was found
    return [array count] > 0;
}

@end
