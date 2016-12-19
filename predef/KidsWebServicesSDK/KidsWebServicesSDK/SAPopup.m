//
//  SAPopup.m
//  Pods
//
//  Created by Gabriel Coman on 07/07/2016.
//
//

// header
#import "SAPopup.h"

// other imports
#import "SASystemVersion.h"
#import "SAExtensions.h"
#import "SALogger.h"

#define SA_OK_BUTTON 0
#define SA_CANCEL_BUTTON 1

// interface
@interface SAPopup ()
@property (nonatomic, strong) UIAlertController *kwsPopupController;
@property (nonatomic, strong) UIAlertView *kwsPopupAlertView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *okTitle;
@property (nonatomic, strong) NSString *nokTitle;
@property (nonatomic, assign) BOOL hasTextField;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, strong) pressed pressed;
@end

@implementation SAPopup

// MARK: Main class functions

+ (instancetype) sharedManager {
    static SAPopup *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void) showWithTitle:(NSString*)title
            andMessage:(NSString*)message
            andOKTitle:(NSString*)ok
           andNOKTitle:(NSString*)nok
          andTextField:(BOOL)hasTextField
       andKeyboardTyle:(UIKeyboardType)keyboardType
            andPressed:(pressed)pressed {
    
    _title = (title != NULL ? title : @"Title");
    _message = (message != NULL ? message : @"Alert");
    _okTitle = (ok != NULL ? ok : @"OK");
    _nokTitle = nok;
    _hasTextField = hasTextField;
    _keyboardType = keyboardType;
    _pressed = (pressed != NULL ? pressed : ^(int button, NSString* message) { });
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self showWithAlertController];
    } else {
        [self showWithAlertView];
    }
    
}

- (void) close {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [_kwsPopupController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_kwsPopupAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

// MARK: iOS 8.0+

- (void) showWithAlertController {
    
    actionBlock iOKBlock = ^(UIAlertAction *action) {
        if (_hasTextField) {
            UITextField *textField = [[_kwsPopupController textFields] firstObject];
            NSString *text = [textField text];
            _pressed(SA_OK_BUTTON, text);
        } else {
            _pressed(SA_OK_BUTTON, nil);
        }
    };
    actionBlock iNOKBlock = ^(UIAlertAction *action) {
        _pressed(SA_CANCEL_BUTTON, nil);
    };
    
    _kwsPopupController = [UIAlertController alertControllerWithTitle:_title
                                                              message:_message
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:_okTitle style:UIAlertActionStyleDefault handler:iOKBlock];
    [_kwsPopupController addAction:okAction];
    
    // add this only if it exists
    if (_nokTitle != NULL) {
        UIAlertAction *nokAction = [UIAlertAction actionWithTitle:_nokTitle style:UIAlertActionStyleDefault handler:iNOKBlock];
        [_kwsPopupController addAction:nokAction];
    }
    
    if (_hasTextField) {
        __block UITextField *localTextField;
        __block id safeSelf = self;
        [_kwsPopupController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            localTextField = textField;
            localTextField.keyboardType = [safeSelf keyboardType];
        }];
    }
    
    [_kwsPopupController show];
}

// MARK: iOS 8.0-

- (void) showWithAlertView {
    _kwsPopupAlertView = [[UIAlertView alloc] initWithTitle:_title
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:_nokTitle
                                          otherButtonTitles:_okTitle, nil];
    if (_hasTextField) {
        _kwsPopupAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    [_kwsPopupAlertView show];
}

- (void) willPresentAlertView:(UIAlertView *)alertView {
    if (_hasTextField) {
        UITextField *textField = [_kwsPopupAlertView textFieldAtIndex:0];
        textField.keyboardType = _keyboardType;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_hasTextField) {
            UITextField *textField = [_kwsPopupAlertView textFieldAtIndex:0];
            NSString *text = [textField text];
            _pressed(SA_OK_BUTTON, text);
        } else {
            _pressed(SA_OK_BUTTON, nil);
        }
    }
    else if (buttonIndex == 0){
        _pressed(SA_CANCEL_BUTTON, nil);
    }
}

@end