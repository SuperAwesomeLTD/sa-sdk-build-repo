/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAXMLElement;

// typedef for an iterator block
typedef void (^saDidFindXMLElement)(SAXMLElement *element);


/**
 * Class that represents a XML element, containing
 * the element name, it's internal value, a dictionary of attributes,
 * an array of children as well as a reference to it's parent
 */
@interface SAXMLElement : NSObject

// members variables
@property (nonatomic, strong) NSString       *name;
@property (nonatomic, strong) NSString       *value;
@property (nonatomic, strong) NSDictionary   *attributes;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, weak)   SAXMLElement   *parent;

/**
 * Method that safely gets the name of the XML element
 *
 * @return the XML tag name
 */
- (NSString*) getName;

/**
 * Method that safely gets the internal XML element value
 *
 * @return the value, as a string
 */
- (NSString*) getValue;

/**
 * Method that returns the value of a given XML attribute
 *
 * @param name  the name of the XML attribute
 * @return      the value of the XML attribute, as as string
 */
- (NSString*) getAttribute:(NSString*) name;

@end

/**
 * Class that abstracts away the complexities of XML parsing into a 
 * series of utility methods
 */
@interface SAXMLParser : NSObject

// the error - in case of any
@property (nonatomic, strong) NSError *errorResult;

/**
 * Method that parses a block of XML data as a NSData object
 *
 * @param   xml the XML data object
 * @return  the start (root) XML element, as an SAXMLElement object
 */
- (SAXMLElement*) parseXMLData:(NSData*)xml;

/**
 * Method that parses a block of XML data as string
 *
 * @param   xml the XML data object
 * @return  the start (root) XML element, as an SAXMLElement object
 */
- (SAXMLElement*) parseXMLString:(NSString*)xml;

@end

/**
 * Extension over SAXMLParser that adds static method
 */
@interface SAXMLParser (SAStaticFunctions)

/**
 * Method that makes a search in the current node's siblings and children by a
 * given "name" string parameter.
 * It will return the result into the list of XML elements given as paramter.
 *
 * @param element   the XML parent node
 * @param name      the XML name ot search for
 * @param array     a list of returned Elements
 */
+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                             forName:(NSString*) name
                                into:(NSMutableArray*) array;
/**
 * Method that returns a list of XML elements after performing a thorough 
 * search of all the node parameter's siblings and children, by a given "name".
 *
 * @param element   the parent node
 * @param name      the name to search for
 * @return          a List of XML elements
 */
+ (NSMutableArray*) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                                        forName:(NSString*) name;

/**
 * Method that iterates over each children or sibling of the given XML node paramter.
 * The block is a method with one XML element parameter.
 *
 * @param element   the XML parent node
 * @param name      the name of the XML element
 * @param block     a block of type SAXMLIterator
 */
+ (void) searchSiblingsAndChildrenOf:(SAXMLElement*) element
                             forName:(NSString*) name
                         andInterate:(saDidFindXMLElement) block;

/**
 * Finds only the first instance of a XML element with given name by 
 * searching in all of the node parameter's siblings and children.
 *
 * @param element   the parent node
 * @param name      the name to search for
 * @return          the first element found
 */
+ (SAXMLElement*) findFirstIntanceInSiblingsAndChildrenOf:(SAXMLElement*) element
                                                  forName:(NSString*) name;

/**
 * Method that checks if in all children and siblings of a XML node, 
 * there exists at least one element with given name
 *
 * @param element   parent XML node
 * @param name      name to search for
 * @return          true if found any, false otherwise
 */
+ (BOOL) checkSiblingsAndChildrenOf:(SAXMLElement*) element
                            forName:(NSString*) name;

@end
