//
//  ForgetPwdViewController.m
//  Vintage
//
//  Created by William on 5/22/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "VintageApiService.h"
#import "SCLAlertView.h"

@interface ForgetPwdViewController ()

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ForgetPwdViewController viewDidLoad");
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onResetPasswordRequestNotification:) name:ResetPasswordNotification object:nil];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture)];
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    self.resetButtonView.layer.cornerRadius = 22;
    self.resetButtonView.layer.masksToBounds = YES;
    UIColor *color = [UIColor whiteColor];
    self.emailFieldView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"信箱", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                                                      NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                                                      }];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.emailFieldView.leftView = paddingView;
    self.emailFieldView.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)onResetPasswordRequestNotification:(NSNotification*)notify
{
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"2"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showWarning:self title:NSLocalizedString(@"此帳號不存在", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showSuccess:self title:NSLocalizedString(@"重設密碼信件已經寄出", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        
    }
}
- (void) respondToTapGesture
{
    [self.view endEditing:YES];
}
- (IBAction)editDidBegin:(UITextField *)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_pressed.png"];
}
- (IBAction)editDidEnd:(UITextField *)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_normal.png"];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)resetAction:(id)sender {
    if (self.emailFieldView.text.length > 0)
    {
        [[VintageApiService sharedInstance]resetPasswordRequest:self.emailFieldView.text];
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showWarning:self title:NSLocalizedString(@"請輸入註冊信箱", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
}

- (void) keyboardWillShow:(NSNotification*) note
{
    NSLog(@"keyboardWillShow");
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSValue* keyboardFrameBegin = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"screenHeight:%f keyboardWillShow:%f self.controlView.frame.size.height:%f newHeight:%f",screenHeight, keyboardHeight, self.view.frame.size.height, screenHeight - keyboardHeight - self.view.frame.size.height);
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                      screenHeight - kbSize.height - self.view.frame.size.height,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
                     } completion:^(BOOL finished){
                     }];
    
}

- (void) keyboardWillHide:(NSNotification*) note
{
    NSLog(@"keyboardWillHide");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    
    NSLog(@"screenHeight:%f newHeight:%f", screenHeight, screenHeight-self.view.frame.size.height);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                      screenHeight-self.view.frame.size.height,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
- (BOOL)textFieldShouldReturn:(id)sender {
    
    [sender resignFirstResponder];
    
    return NO;
}
@end
