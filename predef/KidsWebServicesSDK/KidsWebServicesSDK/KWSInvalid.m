//
//  KWSInvalid.m
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import "KWSInvalid.h"
#import "KWSParentEmailError.h"

@implementation KWSInvalid

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        _parentEmail = [[KWSParentEmailError alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"parentEmail"]];
    }
    return self;
}

- (BOOL) isValid {
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"parentEmail": nullSafe([_parentEmail dictionaryRepresentation])
    };
}

@end
