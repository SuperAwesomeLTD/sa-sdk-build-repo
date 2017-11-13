/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */


#import <Foundation/Foundation.h>

@class SAAd;
@class SASession;
@class SAClickEvent;
@class SAImpressionEvent;
@class SAViewableImpressionEvent;
@class SAPGOpenEvent;
@class SAPGFailEvent;
@class SAPGCloseEvent;
@class SAPGSuccessEvent;

@interface SAServerModule : NSObject

@property (nonatomic, strong) SAClickEvent              *clickEvent;
@property (nonatomic, strong) SAImpressionEvent         *impressionEvent;
@property (nonatomic, strong) SAViewableImpressionEvent *viewableImpressionEvent;
@property (nonatomic, strong) SAPGOpenEvent             *pgOpenEvent;
@property (nonatomic, strong) SAPGFailEvent             *pgFailEvent;
@property (nonatomic, strong) SAPGCloseEvent            *pgCloseEvent;
@property (nonatomic, strong) SAPGSuccessEvent          *pgSuccessEvent;

- (id) initWithAd: (SAAd*) ad
       andSession: (SASession*) session;

- (void) triggerClickEvent;
- (void) triggerImpressionEvent;
- (void) triggeViewableImpressionEvent;
- (void) triggerPgOpenEvent;
- (void) triggerPgFailEvent;
- (void) triggerPgCloseEvent;
- (void) triggerPgSuccessEvent;

@end
