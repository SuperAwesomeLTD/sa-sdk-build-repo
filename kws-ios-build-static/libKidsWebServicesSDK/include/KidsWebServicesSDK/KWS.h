//
//  KWS.h
//  Pods
//
//  Created by Gabriel Coman on 24/05/2016.
//
//

#import <UIKit/UIKit.h>

// imports
#import "KWSParentEmail.h"
#import "KWSGetUser.h"
#import "KWSGetLeaderboard.h"
#import "KWSRequestPermission.h"
#import "KWSTriggerEvent.h"
#import "KWSParentEmail.h"
#import "KWSGetScore.h"
#import "KWSGetAppData.h"
#import "KWSSetAppData.h"
#import "KWSHasTriggeredEvent.h"
#import "KWSUpdateUser.h"
#import "KWSInviteUser.h"
#import "KWSCreateUser.h"
#import "KWSLoggedUser.h"
#import "KWSCreateUserProcess.h"
#import "KWSNotificationProcess.h"
#import "KWSAuthUserProcess.h"
#import "KWSRandomNameProcess.h"

// forward declarations
@class KWSMetadata;

@interface KWS : NSObject

// singleton func
+ (instancetype) sdk;

// setup func
- (void) startSessionWithClientId:(NSString*)clientId
                  andClientSecret:(NSString*)clientSecret
                        andAPIUrl:(NSString*)apiUrl;
- (void) stopSession;

// Create, auth user
- (void) createUser:(NSString*)username
       withPassword:(NSString*)password
     andDateOfBirth:(NSString*)dateOfBirth
         andCountry:(NSString*)country
     andParentEmail:(NSString*)parentEmail
        andResponse:(userCreated) userCreated;

- (void) loginUser:(NSString*)username
             withPassword:(NSString*)password
              andResponse:(userAuthenticated)userAuthenticated;

- (void) logoutUser;

// random name
- (void) generateRandomName:(gotRandomName)randomName;

// get user & update user details
- (void) getUser:(gotUser)gotUser;
- (void) updateUser:(KWSUser*)updatedUser
        andResponse:(updated)updated;

// request permissions & submit parent email, if not already submitted
- (void) submitParentEmail:(NSString*)email
               andResponse:(submitted)submitted;
- (void) requestPermission:(NSArray<NSNumber*>*)requestedPermissions
               andResponse:(requested)requested;

// invite another user
- (void) inviteUser:(NSString*)email
        andResponse:(invited)invited;

// events, points, leaderboards
- (void) triggerEvent:(NSString*)event
           withPoints:(NSInteger)points
          andResponse:(triggered)triggered;
- (void) hasTriggeredEvent:(NSInteger) eventId
               andResponse: (hasTriggered)triggered;
- (void) getScore:(gotScore)gotscore;
- (void) getLeaderboard:(gotLeaderboard)gotLeaderboard;

// app data
- (void) getAppData:(gotAppData)gotappdata;
- (void) setAppData:(NSString*)name
          withValue:(NSInteger)value
        andResponse:(setAppData)setappdata;

// register for notifications
- (void) register:(registered)registered;
- (void) unregister:(unregistered)unregistered;
- (void) isRegistered:(isRegistered)isRegistered;

// Main aux public functions
- (void) registerWithPopup:(registered)registered;
- (void) submitParentEmailWithPopup:(submitted)submitted;

// version
- (NSString*) getVersion;

// other setters & getters
- (NSString*) getClientId;
- (NSString*) getClientSecret;
- (NSString*) getKWSApiUrl;
- (void) setLoggedUser: (KWSLoggedUser*) loggedUser;
- (KWSLoggedUser*) getLoggedUser;

@end
