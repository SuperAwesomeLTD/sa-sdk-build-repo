/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "NSDictionary+SafeHandling.h"

@implementation NSDictionary (SafeHandling)

- (id _Nullable) safeObjectForKey:(id _Nullable)aKey {
    if (aKey == nil || aKey == [NSNull null]) {
        return nil;
    } else {
        NSObject *object = self[aKey];
        
        if (object == [NSNull null]) {
            return nil;
        }
        if (object == nil) {
            return nil;
        }
        
        return object;
    }
}

- (id _Nullable) safeObjectForKey:(id _Nullable)aKey orDefault:(id _Nullable)def {
    id object = [self safeObjectForKey:aKey];
    if (object) {
        return object;
    } else {
        return def;
    }
}

- (NSInteger) safeIntForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    } else {
        return 0;
    }
}

- (NSInteger) safeIntForKey:(id _Nullable)aKey orDefault:(NSInteger) def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    } else {
        return def;
    }
}

- (BOOL) safeBoolForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return false;
    }
}

- (BOOL) safeBoolForKey:(id _Nullable)aKey orDefault:(BOOL) def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return def;
    }

}

- (float) safeFloatForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    } else {
        return .0f;
    }
}

- (float) safeFloatForKey:(id _Nullable)aKey orDefault:(float)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    } else {
        return def;
    }
}

- (double) safeDoubleForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    } else {
        return .0;
    }
}

- (double) safeDoubleForKey:(id _Nullable)aKey orDefault:(double)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    } else {
        return def;
    }
}

- (NSString* _Nullable) safeStringForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return nil;
    }
}

- (NSString* _Nullable) safeStringForKey:(id _Nullable)aKey orDefault:(NSString* _Nullable)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return def;
    }
}

- (NSDictionary* _Nullable) safeDictionaryForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)object;
    } else {
        return @{};
    }
}

- (NSDictionary* _Nullable) safeDictionaryForKey:(id _Nullable)aKey orDefault:(NSDictionary* _Nullable)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)object;
    } else {
        return def;
    }
}

- (NSArray* _Nullable) safeArrayForKey:(id _Nullable)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return (NSArray*)object;
    } else {
        return @[];
    }
}

- (NSArray* _Nullable) safeArrayForKey:(id _Nullable)aKey orDefault:(NSArray* _Nullable)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return (NSArray*)object;
    } else {
        return def;
    }
}

@end
