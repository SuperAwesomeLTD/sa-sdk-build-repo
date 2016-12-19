//
//  SAExtensions.m
//  Pods
//
//  Created by Gabriel Coman on 09/03/2016.
//
//

#import "SAExtensions.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////
// SuperAwesome extension for NSDictionary
////////////////////////////////////////////////////////////////////////////////

@implementation NSDictionary (SAExtensions)

- (void) enumerateKeysAndObjectsUsingBlock:(void (^)(id _Nonnull, id _Nonnull, BOOL * _Nonnull))block atEnd:(void (^)())end {
    [self enumerateKeysAndObjectsUsingBlock:block];
    end();
}

@end

////////////////////////////////////////////////////////////////////////////////
// SuperAwesome extension for NSArray
////////////////////////////////////////////////////////////////////////////////

@implementation NSArray (SAExtensions)

- (NSArray*) filterBy:(NSString*) member withValue:(NSString*) value {
    
    // create a result array to add to if all goes well
    NSMutableArray *result = [@[] mutableCopy];
    
    for (id item in self) {
        
        // get the selector
        SEL sel = NSSelectorFromString(member);
        
        // check if item responds to selector
        if ([item respondsToSelector:sel]) {
            
            // find out return type
            Method m = class_getInstanceMethod([item class], sel);
            char ret[256];
            method_getReturnType(m, ret, 256);
            NSString *type = [NSString stringWithCString:ret encoding:NSUTF8StringEncoding];
            
            // only if it's an object
            if ([type isEqualToString:@"@"]) {
                
                IMP imp = [item methodForSelector:sel];
                id (*func)(id, SEL) = (void *)imp;
                id testVal = func(item, sel);
                
                // and if the value is a string (only comparison that makes sense)
                if ([testVal isKindOfClass:[NSString class]]) {
                    if ([testVal isEqualToString:value]) {
                        [result addObject:item];
                    }
                }
            }
        }
    }
    
    return result;
}

- (NSArray*) filterBy:(NSString*) member withBool:(BOOL) value {
    
    // create a result array to add to if all goes well
    NSMutableArray *result = [@[] mutableCopy];
    
    for (id item in self) {
        
        // get the selector
        SEL sel = NSSelectorFromString(member);
        
        // check if item responds to selector
        if ([item respondsToSelector:sel]) {
            
            // find out return type
            Method m = class_getInstanceMethod([item class], sel);
            char ret[256];
            method_getReturnType(m, ret, 256);
            NSString *type = [NSString stringWithCString:ret encoding:NSUTF8StringEncoding];
            
            // only if it's a bool
            if ([type isEqualToString:@"B"]) {
                
                IMP imp = [item methodForSelector:sel];
                BOOL (*func)(id, SEL) = (void *)imp;
                BOOL testVal = func(item, sel);
                
                if (testVal == value) {
                    [result addObject:item];
                }
            }
            
        }
        
    }
    
    return result;
}

- (nonnull NSArray*) filterBy:(nonnull NSString*) member withInt:(NSInteger) value {
    // create a result array to add to if all goes well
    NSMutableArray *result = [@[] mutableCopy];
    
    for (id item in self) {
        
        // get the selector
        SEL sel = NSSelectorFromString(member);
        
        // check if item responds to selector
        if ([item respondsToSelector:sel]) {
            
            // find out return type
            Method m = class_getInstanceMethod([item class], sel);
            char ret[256];
            method_getReturnType(m, ret, 256);
            NSString *type = [NSString stringWithCString:ret encoding:NSUTF8StringEncoding];
            
            // only if it's a bool
            if ([type isEqualToString:@"q"]) {
                
                IMP imp = [item methodForSelector:sel];
                NSInteger (*func)(id, SEL) = (void *)imp;
                NSInteger testVal = func(item, sel);
                
                if (testVal == value) {
                    [result addObject:item];
                }
            }
            
        }
        
    }
    
    return result;
}

- (NSArray*) removeAllButFirstElement {
    NSMutableArray *_mutableSelf = [self mutableCopy];
    
    if (_mutableSelf.count >= 1) {
        return [[NSMutableArray alloc] initWithObjects:[_mutableSelf firstObject], nil];
    } else {
        return _mutableSelf;
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
// SuperAwesome extension for UIAlertController
////////////////////////////////////////////////////////////////////////////////


@interface UIAlertController (Private)
@property (nonatomic, strong) UIWindow *alertWindow;
@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

- (void) setAlertWindow:(UIWindow*) alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow*) alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (SAExtensions)

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

@end
