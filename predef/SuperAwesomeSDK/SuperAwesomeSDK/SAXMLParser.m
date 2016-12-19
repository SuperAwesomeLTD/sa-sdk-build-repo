//
//  SAXMLParser.m
//  SAXMLParser
//
//  Created by Gabriel Coman on 18/04/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "SAXMLParser.h"

//
// The SAXMLElement object
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

//
// The SAXMLParser object
// That does the actual XML parsing
@interface SAXMLParser ()  <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *stackDict;
@property (nonatomic, assign) NSInteger indent;
@property (nonatomic, strong) NSMutableString *textInProgress;

@end

@implementation SAXMLParser

#pragma mark -
#pragma mark Public methods

- (SAXMLElement*) parseXMLData:(NSData *)xml
{
    return [self objectWithData:xml];
}

- (SAXMLElement*) parseXMLString:(NSString *)xml
{
    return [self parseXMLData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark -
#pragma mark Parsing

- (SAXMLElement*) objectWithData:(NSData *)data
{
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

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
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

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [_textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
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

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    _errorResult = parseError;
}

- (void) printLevels {
    
    // fort all keys in the stack dictionary (N .... 0 levels, ordered)
    NSArray *ascendingKeys = [_stackDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([(NSNumber*)obj1 integerValue] < [(NSNumber*)obj2 integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    // now print
    for (NSNumber *key in ascendingKeys) {
        NSArray *elements = [_stackDict objectForKey:key];
        for (SAXMLElement *element in elements){
            NSLog(@"%ld | %@ > %ld", (long)[key integerValue], element.name, (long)element.children.count);
        }
    }
    
}

#pragma mark -
#pragma mark Getters and Setters

- (NSError*) getError {
    return _errorResult;
}

@end

// static functions over the parser
@implementation SAXMLParser (SAStaticFunctions)

+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*)element
                             forName:(NSString*)name
                                into:(NSMutableArray*)container
{
    for (SAXMLElement *child in element.children) {
        if ([child.name isEqualToString:name]){
            [container addObject:child];
        }
        
        [self searchSiblingsAndChildrenOf:child forName:name into:container];
    }
}

+ (NSMutableArray*) searchSiblingsAndChildrenOf:(SAXMLElement*)element
                                        forName:(NSString*)name
{
    // init container
    NSMutableArray *container = [@[] mutableCopy];
    
    // call the above function to fill the array
    [self searchSiblingsAndChildrenOf:element forName:name into:container];
    return container;
}

+ (SAXMLElement*) findFirstIntanceInSiblingsAndChildrenOf:(SAXMLElement*)element
                                                  forName:(NSString*)name
{
    NSMutableArray *container = [self searchSiblingsAndChildrenOf:element forName:name];
    if (container.count >= 1) {
        return [container firstObject];
    }
    return NULL;
}

+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*)element
                             forName:(NSString*)name
                         andInterate:(SAXMLIterateBlock)block
{
    NSMutableArray *container = [self searchSiblingsAndChildrenOf:element forName:name];
    for (SAXMLElement *element in container) {
        block(element);
    }
}

+ (BOOL) checkSiblingsAndChildrenOf:(SAXMLElement*)element
                            forName:(NSString*)name {
    NSMutableArray *container = [self searchSiblingsAndChildrenOf:element forName:name];
    return [container count] > 0;
}

@end
