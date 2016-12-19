//
//  FirebaseGetToken.h
//  Pods
//
//  Created by Gabriel Coman on 28/06/2016.
//
//

#import <Foundation/Foundation.h>
#import "KWSService.h"

typedef void (^gotToken)(BOOL sucess, NSString *token);

@interface FirebaseGetToken : KWSService

- (void) execute:(gotToken)gottoken;
- (NSString*) getSavedToken;

@end
