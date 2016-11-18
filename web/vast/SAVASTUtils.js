/** Collection of utility functions */
var SAVASTUtils = (function(){

  /** empty constructor */
  var SAVASTUtils = function () {}

  /**
   * Function that validates a certain URL
   * @param str - the URL string to check
   */
  SAVASTUtils.isValidURL = function(str) {
    var pattern = new RegExp('(https?:\/\/(?:www\.|(?!www))[^\s\.]+\.[^\s]{2,}|www\.[^\s]+\.[^\s]{2,})');
    if(!pattern.test(str)) {
      return false;
    } else {
      return true;
    }
  }

  /**
   * @param filename - a filename to return an extension for
   * @return either the filename's extension or null, in case there is none
   */
  SAVASTUtils.returnExtension = function(filename) {
    var array = filename.split(".");
    if (array.length > 1) {
      /** return as extension */
      return array.pop();
    }

    return null;
  }

  /**
   * function that returns an array of found elements that correspond to
   * the name given for the search, given that the search starts from the current
   * element and checks all siblings and children
   * @param element - the XML element from where to begin the search
   * @param name - the tag name we're searching for
   * @return an array of XML elements
   */
  SAVASTUtils.searchSiblingsAndChildren = function(element, name) {
    return element.getElementsByTagName(name);
  }

  /**
   * shorthand version of a function that returns the first intance of
   * a TBXMLElement wrapped as a NSValue
   * @param element - the XML element from where to begin the search
   * @param name - the tag name we're searching for
   * @return a single XML element
   */
  SAVASTUtils.findFirstInstanceInSiblingsAndChildren = function(element, name) {
    var results = SAVASTUtils.searchSiblingsAndChildren(element, name);
    return (results.length >= 1 ? results[0] : null);
  }

  /**
   * doing the same thing as the function above, only the result is passed down
   * as an interation block
   * @param element - the XML element from where to begin the search
   * @param name - the tag name we're searching for
   * @param iterator - an iteration block
   */
  SAVASTUtils.searchSiblingsAndChildrenWithIterator = function(element, name, iterator) {
    var results = SAVASTUtils.searchSiblingsAndChildren(element, name);
    for (var i = 0; i < results.length; i++){
      iterator(results[i]);
    }
  }

  /**
   * a function that returns a boolean if at least one element given the name
   * is found in all siblings and children of the current element
   * @param element - the XML element from where to begin the search
   * @param name - the tag name we're searching for
   * @return whether the element was found (true or false)
   */
  SAVASTUtils.checkSiblingsAndChildrenOf = function(element, name) {
    var results = SAVASTUtils.searchSiblingsAndChildren(element, name);
    return (results.length > 0 ? true : false);
  }

  SAVASTUtils.removeAllButFirst = function(array){
    if (array.length > 1){
      return [array[0]];
    } else {
      return array;
    }
  }

  /** final return */
  return SAVASTUtils;
}).call();
