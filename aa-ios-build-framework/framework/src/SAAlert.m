/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAAlert.h"
#import "SAUtils.h"
#import "SAExtensions.h"

// other imports for the alert view
#define SA_OK_BUTTON                                    0
#define SA_CANCEL_BUTTON                                1

@interface SAAlert ()
@property (nonatomic, strong) UIAlertController         *popupController;

// instance vars holding the current alert view state
@property (nonatomic, strong) NSString                  *title;
@property (nonatomic, strong) NSString                  *message;
@property (nonatomic, strong) NSString                  *okTitle;
@property (nonatomic, strong) NSString                  *nokTitle;
@property (nonatomic, assign) BOOL                      hasTextField;
@property (nonatomic, assign) UIKeyboardType            keyboardType;

// current click handler
@property (nonatomic, strong) saDidClickOnAlertButton   handler;

@end

@implementation SAAlert

+ (instancetype) getInstance {
    static SAAlert *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void) showWithTitle:(NSString*)title
            andMessage:(NSString*)message
            andOKTitle:(NSString*)okTitle
           andNOKTitle:(NSString*)nokTitle
          andTextField:(BOOL)hasInput
       andKeyboardTyle:(UIKeyboardType)inputType
            andPressed:(saDidClickOnAlertButton)handler {
    
    _title = title != NULL ? title : @"Title";
    _message = message != NULL ? message : @"Alert";
    _okTitle = okTitle != NULL ? okTitle : @"OK";
    _nokTitle = nokTitle;
    _hasTextField = hasInput;
    _keyboardType = inputType;
    _handler = handler != NULL ? handler : ^(int button, NSString* message) {};
    
    [self showWithAlertController];
}

/**
 * Method that closes the alert view in different ways, depending 
 * on iOS version
 */
- (void) close {
    [_popupController dismissViewControllerAnimated:YES completion:nil];
}
/**
 * MARK: iOS 8.0+
 * Method that shows the current alert controller
 */
- (void) showWithAlertController {
    
    id iOKBlock = ^(UIAlertAction *action) {
        if (self.hasTextField) {
            UITextField *textField = [[self.popupController textFields] firstObject];
            NSString *text = [textField text];
            self.handler(SA_OK_BUTTON, text);
        } else {
            self.handler(SA_OK_BUTTON, nil);
        }
    };
    id iNOKBlock = ^(UIAlertAction *action) {
        self.handler(SA_CANCEL_BUTTON, nil);
    };
    
    _popupController = [UIAlertController alertControllerWithTitle:_title
                                                              message:_message
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:_okTitle style:UIAlertActionStyleDefault handler:iOKBlock];
    [_popupController addAction:okAction];
    
    // add this only if it exists
    if (_nokTitle != NULL) {
        UIAlertAction *nokAction = [UIAlertAction actionWithTitle:_nokTitle style:UIAlertActionStyleDefault handler:iNOKBlock];
        [_popupController addAction:nokAction];
    }
    
    if (_hasTextField) {
        __block UITextField *localTextField;
        __block id safeSelf = self;
        [_popupController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            localTextField = textField;
            localTextField.keyboardType = [safeSelf keyboardType];
        }];
    }
    
    [_popupController show];
}

@end
