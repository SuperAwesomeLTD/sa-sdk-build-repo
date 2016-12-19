//
//  SAVAST2Parser.m
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import "SAVASTParser.h"

// guard external imports
#if defined(__has_include)
#if __has_include(<SAModelSpace/SAModelSpace.h>)
#import <SAModelSpace/SAModelSpace.h>
#else
#import "SAModelSpace.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SANetwork/SANetwork.h>)
#import <SANetwork/SANetwork.h>
#else
#import "SANetwork.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

// local imports
#import "SAXMLParser.h"

@interface SAVASTParser ()
@property (nonatomic, assign) SAConnectionType connection;
@end

@implementation SAVASTParser

////////////////////////////////////////////////////////////////////////////////
// MARK: View lifecycle
////////////////////////////////////////////////////////////////////////////////

- (id) init {
    if (self = [super init]) {
        // do nothing
    }
    return self;
}

- (void) dealloc {
    NSLog(@"SAVASTParser dealloc");
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Parsing public function
////////////////////////////////////////////////////////////////////////////////

- (void) parseVASTURL:(NSString *)url
          withSession:(SASession*)session
                 done:(vastParsingDone)vastParsing {
    
    // get connectivity
    _connection = (SAConnectionType)[session getConnectivityType];
    
    // parse the vast ad
    [self parseVASTAds:url withResult:^(SAAd *ad) {
        
        // download an ad
        if (ad.creative.details.media) {
            
            [[SAFileDownloader getInstance] downloadFileFrom:ad.creative.details.media.playableMediaUrl
                                                 andResponse:^(BOOL success, NSString *diskPath)
            {
                ad.creative.details.media.playableDiskUrl = diskPath;
                ad.creative.details.media.isOnDisk = success;
                vastParsing (ad);
            }];
        } else {
            vastParsing(ad);
        }
        
    }];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Parsing private functions
////////////////////////////////////////////////////////////////////////////////

- (void) parseVASTAds:(NSString*)vastURL withResult:(vastParsingDone)done {
    
    SARequest *request = [[SARequest alloc] init];
    [request sendGET:vastURL
           withQuery:@{}
           andHeader:@{@"Content-Type":@"application/json",
                       @"User-Agent":[SAAux getUserAgent]}
        withResponse:^(NSInteger status, NSString *payload, BOOL success) {
            
            // create empty ad
            SAAd *empty = [[SAAd alloc] init];
            
            if (!success) {
                done(empty);
            } else {
                // parse XML element
                SAXMLParser *parser = [[SAXMLParser alloc] init];
                __block SAXMLElement *root = [parser parseXMLString:payload];
                
                // check for preliminary errors
                if ([parser getError]) { done(empty); return; }
                if (!root) { done(empty); return; }
                if (![SAXMLParser checkSiblingsAndChildrenOf:root forName:@"Ad"]) { done(empty); return; }
                
                // get and parse *Only* first Ad
                SAXMLElement *element = [SAXMLParser findFirstIntanceInSiblingsAndChildrenOf:root forName:@"Ad"];
                __block SAAd *ad = [self parseAdXML:element];
                
                if (ad.vastType == InLine) {
                    done(ad);
                    return;
                } else if (ad.vastType == Wrapper) {
                    [self parseVASTAds:ad.vastRedirect withResult:^(SAAd *wrapper) {
                        [ad sumAd: wrapper];
                        done(ad);
                        return;
                    }];
                } else {
                    done(empty);
                    return;
                }
                
            }
        }];
}

- (SAAd*) parseAdXML:(SAXMLElement *)adElement {
    // create ad
    SAAd *ad = [[SAAd alloc] init];
    
    ad.error = 0;
    ad.isVAST = YES;
    ad.vastType = InLine;
    
    // init arrays of data
    NSMutableArray *errors = [@[] mutableCopy];
    NSMutableArray *impressions = [@[] mutableCopy];
    
    // check ad type
    BOOL isInLine = [SAXMLParser checkSiblingsAndChildrenOf:adElement forName:@"InLine"];
    BOOL isWrapper = [SAXMLParser checkSiblingsAndChildrenOf:adElement forName:@"Wrapper"];
    
    if (isInLine) ad.vastType = InLine;
    if (isWrapper) ad.vastType = Wrapper;
    
    // get VAStAdTagURI
    SAXMLElement *redirect = [SAXMLParser findFirstIntanceInSiblingsAndChildrenOf:adElement forName:@"VASTAdTagURI"];
    if (redirect) {
        ad.vastRedirect = [redirect getValue];
    }
    
    // get errors
    [SAXMLParser searchSiblingsAndChildrenOf:adElement forName:@"Error" andInterate:^(SAXMLElement *errElement) {
        NSString *error = [SAAux decodeHTMLEntitiesFrom:[errElement getValue]];
        error = [error stringByReplacingOccurrencesOfString:@" " withString:@""];
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = error;
        tracking.event = @"error";
        [errors addObject:tracking];
    }];
    
    // get impressions
    [SAXMLParser searchSiblingsAndChildrenOf:adElement forName:@"Impression" andInterate:^(SAXMLElement *impElement) {
        NSString *impression = [SAAux decodeHTMLEntitiesFrom:[impElement value]];
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = impression;
        tracking.event = @"impression";
        [impressions addObject:tracking];
    }];
    
    // get creatives
    SAXMLElement *creativeElement = [SAXMLParser findFirstIntanceInSiblingsAndChildrenOf:adElement forName:@"Creative"];
    ad.creative = [self parseCreativeXML:creativeElement];
    
    // add errors and impressions
    [ad.creative.events addObjectsFromArray:errors];
    [ad.creative.events addObjectsFromArray:impressions];
    
    // return the ad
    return ad;
}

- (SACreative*) parseCreativeXML:(SAXMLElement *)element {
    // create linear creative
    SACreative *creative = [[SACreative alloc] init];
    
    // create arrays
    creative.events = [@[] mutableCopy];
    
    // populate clickthrough
    [SAXMLParser searchSiblingsAndChildrenOf:element forName:@"ClickThrough" andInterate:^(SAXMLElement *clickElement) {
        NSString *clickUrl = [clickElement value];
        clickUrl = [SAAux decodeHTMLEntitiesFrom:clickUrl];
        clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
        clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = clickUrl;
        tracking.event = @"click_through";
        [creative.events addObject:tracking];
    }];
    
    // populate click tracking array
    [SAXMLParser searchSiblingsAndChildrenOf:element forName:@"ClickTracking" andInterate:^(SAXMLElement *ctrackElement) {
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = [SAAux decodeHTMLEntitiesFrom:[ctrackElement value]];
        tracking.event = @"click_tracking";
        [creative.events addObject:tracking];
    }];
    
    // populate custom clicks array
    [SAXMLParser searchSiblingsAndChildrenOf:element forName:@"CustomClicks" andInterate:^(SAXMLElement *cclickElement) {
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = [SAAux decodeHTMLEntitiesFrom:[cclickElement value]];
        tracking.event = @"custom_clicks";
    }];
    
    // populate tracking
    [SAXMLParser searchSiblingsAndChildrenOf:element forName:@"Tracking" andInterate:^(SAXMLElement *cTrackingElement) {
        SATracking *tracking = [[SATracking alloc] init];
        tracking.URL = [SAAux decodeHTMLEntitiesFrom:[cTrackingElement value]];
        tracking.event = [cTrackingElement getAttribute:@"event"];
        [creative.events addObject:tracking];
    }];
    
    // create the details
    creative.details = [[SADetails alloc] init];
    
    // populate media files
    __block SAMedia *defaultMedia = nil;
    NSMutableArray<SAMedia*> *mediaFiles = [@[] mutableCopy];
    
    [SAXMLParser searchSiblingsAndChildrenOf:element forName:@"MediaFile" andInterate:^(SAXMLElement *cMediaElement) {
        SAMedia *media = [self parseMediaXML:cMediaElement];
        if ([media.type rangeOfString:@"mp4"].location != NSNotFound ||
            [media.type rangeOfString:@".mp4"].location != NSNotFound) {
            [mediaFiles addObject:media];
            defaultMedia = media;
        }
    }];
    
    // if there is at least one element in the array
    if (mediaFiles.count >= 1 && defaultMedia != nil) {
        // get the videos at different bitrates
        NSArray *bitrate360 = [mediaFiles filterBy:@"bitrate" withInt:360];
        NSArray *bitrate540 = [mediaFiles filterBy:@"bitrate" withInt:540];
        NSArray *bitrate720 = [mediaFiles filterBy:@"bitrate" withInt:720];
        SAMedia *media360 = bitrate360.count >= 1 ? [bitrate360 firstObject] : nil;
        SAMedia *media540 = bitrate540.count >= 1 ? [bitrate540 firstObject] : nil;
        SAMedia *media720 = bitrate720.count >= 1 ? [bitrate720 firstObject] : nil;
        
        // when connection is:
        //  1) cellular unknown
        //  2) 2g
        // try to get the lowest media possible
        if (_connection == cellular_unknown || _connection == cellular_2g) {
            creative.details.media = media360;
        }
        // when connection is:
        //  1) 3g
        // try to get the medium media
        else if (_connection == cellular_3g) {
            creative.details.media = media540;
        }
        // when connection is:
        //  1) unknown
        //  2) 4g
        //  3) wifi
        //  4) ethernet
        // try to get the best media available
        else {
            creative.details.media = media720;
        }
    }
    
    // if somehow no media was added (because of legacy VAST)
    // then just add the default media (which should be the 720 one)
    if (creative.details.media == nil) {
        creative.details.media = defaultMedia;
    }
    
    // return creative
    return creative;
}

- (SAMedia*) parseMediaXML:(SAXMLElement*)element {
    SAMedia *media = [[SAMedia alloc] init];
    media.type = [element getAttribute:@"type"];
    NSString *bitstr = [element getAttribute:@"bitrate"];
    if (bitstr != nil) {
        media.bitrate = [bitstr integerValue];
    }
    media.playableMediaUrl = [[element value] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return media;
}


@end
