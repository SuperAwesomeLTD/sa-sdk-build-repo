//
//  SADownloadQueue.m
//  Pods
//
//  Created by Gabriel Coman on 30/09/2016.
//
//

#import "SADownloadQueue.h"
#import "SADownloadItem.h"

@interface SADownloadQueue ()

// the queue
@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation SADownloadQueue

- (id) init {
    if (self = [super init]) {
        
        // init queue
        _queue = [@[] mutableCopy];
    }
    
    return self;
}

- (void) addToQueue:(SADownloadItem *)item {
    if (item != nil && item != (SADownloadItem*)[NSNull null]) {
        [_queue addObject:item];
    }
}

- (void) removeFromQueue:(SADownloadItem *)item {
    if (item != nil && item != (SADownloadItem*)[NSNull null]) {
        [_queue removeObject:item];
    }
}

- (void) moveToBackOfQueue:(SADownloadItem *)item {
    [self removeFromQueue:item];
    [self addToQueue:item];
}

- (NSInteger) getLength {
    return [_queue count];
}

- (BOOL) hasItemForURL:(NSString *)url {
    
    for (SADownloadItem *item in _queue) {
        if ([[item urlKey] isEqualToString:url]) {
            return true;
        }
    }
    
    return false;
}

- (SADownloadItem*) itemForURL:(NSString *)url {
    
    for (SADownloadItem *item in _queue) {
        if ([[item urlKey] isEqualToString:url]) {
            return item;
        }
    }
    
    return nil;
}

- (SADownloadItem*) getNext {
    
    for (SADownloadItem *item in _queue) {
        if (![item isOnDisk]) {
            return item;
        }
    }
    
    return nil;
}

@end
