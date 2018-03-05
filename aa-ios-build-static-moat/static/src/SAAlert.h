/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

// define a blocks used by UIAlertActions
typedef void(^saDidClickOnAlertButton) (int button, NSString *popupMessage);

/**
 * This class abstracts away the creation of a simple alert dialog
 */
@interface SAAlert : NSObject

/**
 * Get the only existing instance of the SAAlert class
 *
 * @return instance variable
 */
+ (instancetype) getInstance;

/**
 * Main public method of the class, that creates and displays a new alert
 *
 * @param title     the alert box title
 * @param message   the alert box message
 * @param okTitle   the text for the "positive dismiss" button
 * @param nokTitle  the text for the "negative dismiss" button
 * @param hasInput  whether the alert should display an input box or not
 * @param inputType the text type for the input box, if present
 * @param handler   an instance of the saDidClickOnAlertButton, used to send 
 *                  messages back to the library user
 */
- (void) showWithTitle:(NSString*)title
            andMessage:(NSString*)message
            andOKTitle:(NSString*)okTitle
           andNOKTitle:(NSString*)nokTitle
          andTextField:(BOOL)hasInput
       andKeyboardTyle:(UIKeyboardType)inputType
            andPressed:(saDidClickOnAlertButton)handler;

@end
