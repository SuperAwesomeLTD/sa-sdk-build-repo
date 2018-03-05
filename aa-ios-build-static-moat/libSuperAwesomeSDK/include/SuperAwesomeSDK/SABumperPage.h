//
//  SABumperController.h
//  Pods
//
//  Created by Gabriel Coman on 07/08/2017.
//
//

#import <UIKit/UIKit.h>

//
// define bumper callback
typedef void (^sabumpercallback)(void);

//
// define the SABumperController class
@interface SABumperPage : UIViewController

+ (void) play;

+ (void) overrideLogo:(UIImage*) image;
+ (void) overrideName:(NSString*) name;

+ (void) setCallback:(sabumpercallback)callback;

@end
