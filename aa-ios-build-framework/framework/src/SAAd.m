/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"

@implementation SAAd

/**
 * Base init method
 *
 * @return a new instance of the object
 */
- (id) init {
    if (self = [super init]){
        [self initDefaults];
    }
    return self;
}

/**
 * Overridden "initWithJsonDictionary" init method from the
 * SADeserializationProtocol protocol that describes how this model gets
 * initialised from the fields of a NSDictionary object (create from a
 * JSON string)
 *
 * @return a new instance of the object
 */
- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        // init defaults
        [self initDefaults];
        
        // start taking from JSON
        _error = [jsonDictionary safeIntForKey:@"error" orDefault:_error];
        _advertiserId = [jsonDictionary safeIntForKey:@"advertiserId" orDefault:_advertiserId];
        _publisherId = [jsonDictionary safeIntForKey:@"publisherId" orDefault:_publisherId];
        _appId = [jsonDictionary safeIntForKey:@"app" orDefault:_appId];
        _lineItemId = [jsonDictionary safeIntForKey:@"line_item_id" orDefault:_lineItemId];
        _campaignId = [jsonDictionary safeIntForKey:@"campaign_id" orDefault:_campaignId];
        _placementId = [jsonDictionary safeIntForKey:@"placementId" orDefault:_placementId];
        
        NSInteger campaignType = [jsonDictionary safeIntForKey:@"campaign_type" orDefault:0];
        _campaignType = getSACampaignTypeFromInt(campaignType);
        
        _isTest = [jsonDictionary safeBoolForKey:@"test" orDefault:_isTest];
        _isFallback = [jsonDictionary safeBoolForKey:@"is_fallback" orDefault:_isFallback];
        _isFill = [jsonDictionary safeBoolForKey:@"is_fill" orDefault:_isFill];
        _isHouse = [jsonDictionary safeBoolForKey:@"is_house" orDefault:_isHouse];
        _isSafeAdApproved = [jsonDictionary safeBoolForKey:@"safe_ad_approved" orDefault:_isSafeAdApproved];
        _isPadlockVisible = [jsonDictionary safeBoolForKey:@"show_padlock" orDefault:_isPadlockVisible];
        _moat = [jsonDictionary safeFloatForKey:@"moat" orDefault:_moat];
        
        _device = [jsonDictionary safeStringForKey:@"device" orDefault:_device];
        
        _loadTime = [jsonDictionary safeIntForKey:@"loadTime" orDefault:_loadTime];
        
        NSDictionary *creativeDict = [jsonDictionary safeDictionaryForKey:@"creative" orDefault:nil];
        if (creativeDict) {
            _creative = [[SACreative alloc] initWithJsonDictionary:creativeDict];
        }
    }
    
    return self;
}

- (id) initWithPlacementId: (NSInteger) placementId
         andJsonDictionary: (NSDictionary*) jsonDictionary {
    
    if (self = [self initWithJsonDictionary:jsonDictionary]) {
        _placementId = placementId;
    }
    
    return self;
}

/**
 * Overridden "isValid" method from the SADeserializationProtocol protocol
 *
 * @return true or false
 */
- (BOOL) isValid {
    
    switch (_creative.format) {
        case SA_Invalid:
            return false;
        case SA_Image:
            return _creative.details.image != nil && _creative.details.media.html != nil;
        case SA_Rich:
            return _creative.details.url != nil && _creative.details.media.html != nil;
        case SA_Video:
            return _creative.details.vast != nil &&
                    _creative.details.media.path != nil &&
                    _creative.details.media.path != (NSString*)[NSNull null] &&
                    _creative.details.media.url != nil &&
                    _creative.details.media.isDownloaded;
        case SA_Tag:
            return _creative.details.tag != nil && _creative.details.media.html != nil;
        case SA_Appwall:
            return _creative.details.image != nil &&
                    _creative.details.media.path != nil &&
                    _creative.details.media.path != (NSString*)[NSNull null] &&
                    _creative.details.media.url != nil &&
                    _creative.details.media.isDownloaded;
    }
    
    return true;
}

/**
 * Overridden "dictionaryRepresentation" method from the
 * SADeserializationProtocol protocol that describes how this model is
 * going to get translated to a dictionary
 *
 * @return a NSDictionary object representing all the members of this object
 */
- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"error": @(_error),
             @"advertiserId": @(_advertiserId),
             @"publisherId": @(_publisherId),
             @"app": @(_appId),
             @"line_item_id": @(_lineItemId),
             @"campaign_id": @(_campaignId),
             @"placementId": @(_placementId),
             @"campaign_type": @(_campaignType),
             @"moat": @(_moat),
             @"test": @(_isTest),
             @"is_fallback": @(_isFallback),
             @"is_fill": @(_isFill),
             @"is_house": @(_isHouse),
             @"safe_ad_approved": @(_isSafeAdApproved),
             @"show_padlock": @(_isPadlockVisible),
             @"creative": nullSafe([_creative dictionaryRepresentation]),
             @"device": nullSafe(_device),
             @"loadTime": @(_loadTime)
             };
}

/**
 * Method that initializes all the values for the model
 */
- (void) initDefaults {
    
    _error = 0;
    _advertiserId = 0;
    _publisherId = 0;
    _appId = 0;
    _lineItemId = 0;
    _campaignId = 0;
    _placementId = 0;
    _campaignType = SA_CPM;
    _moat = 0.2;
    _isTest = false;
    _isFallback = false;
    _isFill = false;
    _isHouse = false;
    _isSafeAdApproved = false;
    _isPadlockVisible = false;
    _device = nil;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    _loadTime = timeStamp * 1000;
    
    
    // create creative
    _creative = [[SACreative alloc] init];
}

@end
