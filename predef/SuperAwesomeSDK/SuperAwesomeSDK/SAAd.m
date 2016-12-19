//
//  SAAd.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SAAd.h"

#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SATracking.h"

@implementation SAAd

- (id) init {
    if (self = [super init]){
        [self initDefaults];
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defaults
        [self initDefaults];
        
        // start taking from JSON
        _error = [jsonDictionary safeIntForKey:@"error" orDefault:_error];
        _advertiserId = [jsonDictionary safeIntForKey:@"advertiserId" orDefault:_advertiserId];
        _publisherId = [jsonDictionary safeIntForKey:@"publisherId" orDefault:_publisherId];
        _app = [jsonDictionary safeIntForKey:@"app" orDefault:_app];
        _lineItemId = [jsonDictionary safeIntForKey:@"line_item_id" orDefault:_lineItemId];
        _campaignId = [jsonDictionary safeIntForKey:@"campaign_id" orDefault:_campaignId];
        _placementId = [jsonDictionary safeIntForKey:@"placementId" orDefault:_placementId];
        _campaignType = [jsonDictionary safeIntForKey:@"campaign_type" orDefault:_campaignType];
        
        _test = [jsonDictionary safeBoolForKey:@"test" orDefault:_test];
        _isFallback = [jsonDictionary safeBoolForKey:@"is_fallback" orDefault:_isFallback];
        _isFill = [jsonDictionary safeBoolForKey:@"is_fill" orDefault:_isFill];
        _isHouse = [jsonDictionary safeBoolForKey:@"is_house" orDefault:_isHouse];
        _safeAdApproved = [jsonDictionary safeBoolForKey:@"safe_ad_approved" orDefault:_safeAdApproved];
        _showPadlock = [jsonDictionary safeBoolForKey:@"show_padlock" orDefault:_showPadlock];
        
        _device = [jsonDictionary safeStringForKey:@"device" orDefault:_device];
        
        _isVAST = [jsonDictionary safeBoolForKey:@"isVAST" orDefault:_isVAST];
        _vastType = [jsonDictionary safeIntForKey:@"vastType" orDefault:_vastType];
        _vastRedirect = [jsonDictionary safeStringForKey:@"vastRedirect" orDefault:_vastRedirect];
        
        NSDictionary *creativeDict = [jsonDictionary safeDictionaryForKey:@"creative" orDefault:nil];
        if (creativeDict) {
            _creative = [[SACreative alloc] initWithJsonDictionary:creativeDict];
        }
    }
    
    return self;
}

- (void) initDefaults {
    
    // init w/ defaults
    _error = 0;
    _advertiserId = 0;
    _publisherId = 0;
    _app = 0;
    _lineItemId = 0;
    _campaignId = 0;
    _placementId = 0;
    _campaignType = cpm;
    _test = false;
    _isFallback = false;
    _isFill = false;
    _isHouse = false;
    _safeAdApproved = false;
    _showPadlock = false;
    _isVAST = false;
    _vastType = InLine;
    _vastRedirect = nil;
    _device = nil;
    
    // create creative
    _creative = [[SACreative alloc] init];
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"error": @(_error),
             @"advertiserId": @(_advertiserId),
             @"publisherId": @(_publisherId),
             @"app": @(_app),
             @"line_item_id": @(_lineItemId),
             @"campaign_id": @(_campaignId),
             @"placementId": @(_placementId),
             @"campaign_type": @(_campaignType),
             @"test": @(_test),
             @"is_fallback": @(_isFallback),
             @"is_fill": @(_isFill),
             @"is_house": @(_isHouse),
             @"safe_ad_approved": @(_safeAdApproved),
             @"show_padlock": @(_showPadlock),
             @"isVAST": @(_isVAST),
             @"vastType": @(_vastType),
             @"vastRedirect": nullSafe(_vastRedirect),
             @"creative": nullSafe([_creative dictionaryRepresentation]),
             @"device": nullSafe(_device)
             };
}

- (BOOL) isValid {
    
    if (_creative == NULL) return false;
    if (_creative.creativeFormat == invalid) return false;
    if (_creative.details == NULL) return false;
    
    switch (_creative.creativeFormat) {
        case image: {
            if (_creative.details.image == NULL) return false;
            break;
        }
        case video:{
            if (_creative.details.vast == NULL) return false;
            break;
        }
        case invalid:{
            return false;
            break;
        }
        case tag:{
            if (_creative.details.tag == NULL) return false;
            break;
        }
        case rich:{
            if (_creative.details.url == NULL) return false;
            break;
        }
        case gamewall: {
            return true;
            break;
        }
    }
    
    return true;
}

- (void) sumAd:(SAAd*) dest {
    if (dest.creative.clickUrl != NULL) {
        self.creative.clickUrl = dest.creative.clickUrl;
    }
    
    [self.creative.events addObjectsFromArray:dest.creative.events];
    
    if (dest.creative.details.media) {
        self.creative.details.media = dest.creative.details.media;
    }
}

@end
