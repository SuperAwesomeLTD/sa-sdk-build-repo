//
//  SAParentalGate.h
//  Pods
//
//  Created by Gabriel Coman on 09/08/2017.
//
//

#import <UIKit/UIKit.h>

typedef void (^sapgcallback)();

@interface SAParentalGate : NSObject

+ (void) play;
+ (void) close;

+ (void) setPgOpenCallback:(sapgcallback)callback;
+ (void) setPgCanceledCallback:(sapgcallback)callback;
+ (void) setPgFailedCallback:(sapgcallback)callback;
+ (void) setPgSuccessCallback:(sapgcallback)callback;

@end
