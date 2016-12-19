//
//  SAGameWallParser.m
//  Pods
//
//  Created by Gabriel Coman on 28/09/2016.
//
//

#import "SAAppWallParser.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SANetworking/SAFileDownloader.h>)
#import <SANetworking/SAFileDownloader.h>
#else
#import "SAFileDownloader.h"
#endif
#endif

@implementation SAAppWallParser

- (void) getAppWallResourcesForAds:(NSArray *)ads andCallback:(gotAllImages)callback {
    NSInteger max = [ads count];
    NSInteger first = 0;
    [self getImages:first max:max ads:ads callback:callback];
}

- (void) getImages: (NSInteger) index max: (NSInteger) max ads: (NSArray<SAAd*> *)ads callback: (gotAllImages) callback {
    if (index > max - 1) {
        if (callback != nil) {
            callback ();
        }
    } else {
        // get the ad
        __block SAAd *ad = (SAAd*)[ads objectAtIndex:index];
        ad.creative.details.media.playableMediaUrl = ad.creative.details.image;
        
        // download the image
        [[SAFileDownloader getInstance] downloadFileFrom:ad.creative.details.media.playableMediaUrl
                                             andResponse:^(BOOL success, NSString *diskPath) {
        
                                                 ad.creative.details.media.isOnDisk = success;
                                                 ad.creative.details.media.playableDiskUrl = diskPath;
                                                 
                                                 // call this func recursively
                                                 [self getImages:(index + 1) max:max ads:ads callback:callback];
                                                 
                                             }];
    }
}

@end
