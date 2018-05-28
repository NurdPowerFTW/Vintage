//
//  RegisterViewController.h
//  Vintage
//
//  Created by William on 5/6/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameFieldView;
@property (weak, nonatomic) IBOutlet UIView *emailFieldView;
@property (weak, nonatomic) IBOutlet UIView *pwdFieldView;
@property (weak, nonatomic) IBOutlet UIView *confirmPwdView;
@property (weak, nonatomic) IBOutlet UIView *registerButtonVIew;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwd_confirm_textField;

@property (weak, nonatomic) IBOutlet UIButton *nameFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *emailFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *pwdFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmPwdButton;

@end
