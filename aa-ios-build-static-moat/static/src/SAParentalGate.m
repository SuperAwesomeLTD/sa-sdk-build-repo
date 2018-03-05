//
//  SAParentalGate.m
//  Pods
//
//  Created by Gabriel Coman on 09/08/2017.
//
//

#import "SAParentalGate.h"

// define a block used by UIAlertActions
typedef void(^actionBlock) (UIAlertAction *action);

// parental gate defines
#define SA_CHALLANGE_ALERTVIEW                      0
#define SA_ERROR_ALLERTVIEW                         1

#define SA_RAND_MIN                                 50
#define SA_RAND_MAX                                 99

#define SA_CHALLANGE_ALERTVIEW_TITLE                @"Parental Gate"
#define SA_CHALLANGE_ALERTVIEW_MESSAGE              @"Please solve the following problem to continue:\n%@ + %@ = ?"
#define SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE    [NSString stringWithFormat:SA_CHALLANGE_ALERTVIEW_MESSAGE, @(_number1), @(_number2)]
#define SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE   @"Cancel"
#define SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE @"Continue"

#define SA_ERROR_ALERTVIEW_TITLE                    @"Oops! That was the wrong answer."
#define SA_ERROR_ALERTVIEW_MESSAGE                  @"Please seek guidance from a responsible adult to help you continue."
#define SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE       @"Ok"

//
// actual parental gate
static SAParentalGate   *parentalGate;

//
// callbacks
static sapgcallback     pgopencallback = ^(){};
static sapgcallback     pgcanceledcallback = ^(){};
static sapgcallback     pgfailedcallback = ^(){};
static sapgcallback     pgsuccesscallback = ^(){};

//
// top window
static UIWindow         *topWindow;

////
//// Interface implementation
@interface SAParentalGate () <UIAlertViewDelegate>

@property (nonatomic,assign) NSInteger              number1;
@property (nonatomic,assign) NSInteger              number2;
@property (nonatomic,assign) NSInteger              solution;

@property (nonatomic, strong) UIAlertController     *challangeAlertController;
@property (nonatomic, strong) UIAlertController     *errorAlertController;

@end

@implementation SAParentalGate

- (id) init {
    if (self = [super init]) {
        
        //
        // new question
        [self newQuestion];
        
        //
        // callback
        pgopencallback();
        
        // get a weak self reference
        __weak typeof (self) weakSelf = self;
        
        // action block #1
        actionBlock cancelBlock = ^(UIAlertAction *action) {
            
            //
            // stop
            [weakSelf stop];
            
            // send pg cancel delegate call
            pgcanceledcallback();
            
        };
        
        // action block #2
        actionBlock continueBlock = ^(UIAlertAction *action) {
            
            // get number from text field
            UITextField *textField = [[_challangeAlertController textFields] firstObject];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *input = [f numberFromString:textField.text];
            [textField resignFirstResponder];
            
            // what happens when you get a right solution
            if([input integerValue] == weakSelf.solution){
                [weakSelf handlePGSuccess];
            }
            // or a bad solution
            else{
                [weakSelf handlePGError];
            }
        };
        
        
        // alert view (controller)
        _challangeAlertController = [UIAlertController alertControllerWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                                        message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        // actions
        UIAlertAction* continueBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE
                                                              style:UIAlertActionStyleDefault
                                                            handler:continueBlock];
        UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                                            style:UIAlertActionStyleDefault
                                                          handler:cancelBlock];
        
        
        // add actions
        [_challangeAlertController addAction:cancelBtn];
        [_challangeAlertController addAction:continueBtn];
        __block UITextField *localTextField;
        
        [_challangeAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            localTextField = textField;
            localTextField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIViewController *dummy = [[UIViewController alloc] init];
        
        topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = dummy;
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:_challangeAlertController animated:true completion:nil];
    }
    return self;
}

/**
 * Internal method that describes what happens in case the parental gate is a
 * success. Mainly "close the alert view" and "goto click url"
 */
- (void) handlePGSuccess {
    
    //
    // stop this
    [self stop];
    
    //send pg success delegate call
    pgsuccesscallback();
    
}

/**
 * Internal method that describes what happens in case the parental gate is a
 * error. Mainly "close the alert view" and "present error message"
 */
- (void) handlePGError {
    
    //
    // stop
    [self stop];
    
    // action block #1
    actionBlock okBlock = ^(UIAlertAction *action) {
        
        // send pg cancel delegate call
        pgfailedcallback();
        
        //
        // stop
        [self stop];
    };
    
    // alert view (controller)
    _errorAlertController = [UIAlertController alertControllerWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                                message:SA_ERROR_ALERTVIEW_MESSAGE
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    // actions
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                                    style:UIAlertActionStyleDefault
                                                  handler:okBlock];
    
    
    // add actions
    [_errorAlertController addAction:okBtn];
    
    UIViewController *dummy = [[UIViewController alloc] init];
    
    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = dummy;
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:_errorAlertController animated:true completion:nil];
}


- (void) stop {
    
    [_challangeAlertController dismissViewControllerAnimated:YES completion:nil];
    [_errorAlertController dismissViewControllerAnimated:YES completion:nil];
    topWindow.hidden = YES;
    topWindow = nil;
}

/**
 * Method that inits the numbers and solution for a new parental gate question
 */
- (void) newQuestion {
    _number1 = [self randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _number2 = [self randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _solution = _number1 + _number2;
}

- (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}


+ (void) play {
    parentalGate = [[SAParentalGate alloc] init];
}

+ (void) close {
    if (parentalGate != NULL) {
        [parentalGate stop];
    }
}

+ (void) setPgOpenCallback:(sapgcallback)callback {
    pgopencallback = callback;
}

+ (void) setPgCanceledCallback:(sapgcallback)callback {
    pgcanceledcallback = callback;
}

+ (void) setPgFailedCallback:(sapgcallback)callback {
    pgfailedcallback = callback;
}

+ (void) setPgSuccessCallback:(sapgcallback)callback {
    pgsuccesscallback = callback;
}


@end
