//
//  RegisterViewController.m
//  Vintage
//
//  Created by William on 5/6/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "RegisterViewController.h"
#import "VintageApiService.h"
#import <QuartzCore/QuartzCore.h>
#import "SCLAlertView.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*self.nameFieldView.layer.cornerRadius = 22;
     self.nameFieldView.layer.masksToBounds = YES;
     self.emailFieldView.layer.cornerRadius = 22;
     self.emailFieldView.layer.masksToBounds = YES;
     self.pwdFieldView.layer.cornerRadius = 22;
     self.pwdFieldView.layer.masksToBounds = YES;
     self.confirmPwdView.layer.cornerRadius = 22;
     self.confirmPwdView.layer.masksToBounds = YES;*/
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture)];
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    self.registerButtonVIew.layer.cornerRadius = 22;
    self.registerButtonVIew.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRegisterFromEmailFinishedNotification:) name:EmailRegisterFinishedNotification object:nil];
    UIColor *color = [UIColor whiteColor];
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"姓名", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                             }];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.nameTextField.leftView = paddingView1;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"信箱", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                              NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                              }];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.emailTextField.leftView = paddingView2;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];

    self.pwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密碼", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                            }];
    self.pwdTextField.leftView = paddingView3;
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];

    self.pwd_confirm_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"確認密碼", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                                       }];
    self.pwd_confirm_textField.leftView = paddingView4;
    self.pwd_confirm_textField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.secureTextEntry = YES;
    self.pwd_confirm_textField.secureTextEntry = YES;
    self.pwd_confirm_textField.returnKeyType = UIReturnKeyDone;
    self.pwdTextField.returnKeyType = UIReturnKeyDone;
}
- (void) respondToTapGesture
{
    [self.view endEditing:YES];
}
- (IBAction)textEditBegin:(UITextField*)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_pressed.png"];
    
    
}
- (IBAction)textEditEnd:(UITextField *)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_normal.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onRegisterFromEmailFinishedNotification:(NSNotification*)notify
{
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"7"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showWarning:self title:NSLocalizedString(@"此帳號已經存在", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showSuccess:self title:NSLocalizedString(@"註冊成功", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        
    }
}
- (IBAction)registerAction:(id)sender {
    if (self.emailTextField.text.length >0 && self.pwdTextField.text.length >0 && self.pwd_confirm_textField.text.length >0 && self.nameTextField.text.length >0 )
    {
        if ([self.pwdTextField.text isEqualToString:self.pwd_confirm_textField.text]) {
            [[VintageApiService sharedInstance]registerFromEmail:self.emailTextField.text password:self.pwdTextField.text pwd_confirm:self.pwd_confirm_textField.text name:self.nameTextField.text];
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
            [alert showWarning:self title:NSLocalizedString(@"請確認密碼是否相同", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        }
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showWarning:self title:NSLocalizedString(@"資訊不完整", nil) subTitle:NSLocalizedString(@"請完整輸入所有欄位", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    
}
- (IBAction)backAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
