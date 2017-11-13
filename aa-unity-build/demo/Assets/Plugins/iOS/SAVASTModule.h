/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <Foundation/Foundation.h>

@class SAAd;
@class SAURLEvent;

@interface SAVASTModule : NSObject

@property (nonatomic, strong) SAURLEvent                    *vastClickThrough;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastError;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastImpression;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastCreativeView;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastStart;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastFirstQuartile;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastMidpoint;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastThirdQuartile;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastComplete;
@property (nonatomic, strong) NSMutableArray<SAURLEvent*>   *vastClickTracking;

- (id) initWithAd: (SAAd*) ad;

- (NSString*) getVASTClickThroughEvent;

- (void) triggerVASTClickThroughEvent;
- (void) triggerVASTErrorEvent;
- (void) triggerVASTImpressionEvent;
- (void) triggerVASTCreativeViewEvent;
- (void) triggerVASTStartEvent;
- (void) triggerVASTFirstQuartileEvent;
- (void) triggerVASTMidpointEvent;
- (void) triggerVASTThirdQuartileEvent;
- (void) triggerVASTCompleteEvent;
- (void) triggerVASTClickTrackingEvent;

@end
