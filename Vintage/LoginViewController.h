//
//  LoginViewController.h
//  Vintage
//
//  Created by William on 5/6/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *RefreshPersonalInfoNotification;

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *FBLoginView;
@property (weak, nonatomic) IBOutlet UIView *WeiBoLoginView;
@property (weak, nonatomic) IBOutlet UIView *AccountFieldVIew;
@property (weak, nonatomic) IBOutlet UIView *PwdFieldView;
@property (weak, nonatomic) IBOutlet UIView *LoginButtonView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *forgetButton;
@property NSMutableArray *bannerArray;
@end
