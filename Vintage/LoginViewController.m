//
//  LoginViewController.m
//  Vintage
//
//  Created by William on 5/6/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "LoginViewController.h"
#import "ContentViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "VintageApiService.h"
#import "Vintage-Swift.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "HexColors.h"

#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"
NSString *RefreshPersonalInfoNotification = @"RefreshPersonalInfoNotification";
@interface LoginViewController ()<WBHttpRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture)];
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    self.bannerArray = [[NSMutableArray alloc]init];
    self.FBLoginView.layer.cornerRadius = 20;
    self.FBLoginView.layer.masksToBounds = YES;
    self.WeiBoLoginView.layer.cornerRadius = 20;
    self.WeiBoLoginView.layer.masksToBounds = YES;
    self.LoginButtonView.layer.cornerRadius = 20;
    self.LoginButtonView.layer.masksToBounds = YES;
    self.AccountFieldVIew.alpha = 0.8f;
    self.PwdFieldView.alpha = 0.8f;
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.returnKeyType = UIReturnKeyDone;
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLoginFromEmailFinishedNotification:) name:LoginFromEmailFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLoginFromThirdPartyFinishedNotification:) name:LoginFromThirdPartyFinishedNotification object:nil];
    UIColor *color = [UIColor whiteColor];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.emailTextField.leftView = paddingView1;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"信箱", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                                                      NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                                                      }];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.pwdTextField.leftView = paddingView2;
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密碼", nil) attributes:@{NSForegroundColorAttributeName: color,
                                                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]
                                                                                                                                    }];
    self.registerButton.titleLabel.textColor = [UIColor whiteColor];
    self.forgetButton.titleLabel.textColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void) respondToTapGesture
{
    [self.view endEditing:YES];
}
- (IBAction)clearEmailTextInput:(id)sender {
    self.emailTextField.text = @"";
}

- (IBAction)clearPwdTextInput:(id)sender {
    self.pwdTextField.text = @"";
}
- (IBAction)textDidBegin:(UITextField *)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_pressed.png"];
}
- (IBAction)textDidEnd:(UITextField *)sender {
    sender.background = [UIImage imageNamed:@"btn_entrybar_normal.png"];
}

- (IBAction)registerAction:(id)sender {
    [self performSegueWithIdentifier:@"loginToRegister" sender:self];
}
- (IBAction)resetPwdAction:(id)sender {
    [self performSegueWithIdentifier:@"loginToResetPwd" sender:self];
}

- (IBAction)cancelAction:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLoginFromEmailFinishedNotification:(NSNotification*)notify
{
    NSLog(@"notify.object:%@",notify.object);
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user"] objectForKey:@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user"] objectForKey:@"name"] forKey:@"name"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user"] objectForKey:@"user_id"] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user"] objectForKey:@"point_sum"] forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]setObject:@"Email" forKey:@"LoginType"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
    }
    else if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"2"])
    {
        NSLog(@"account not exist");
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
        [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"登入失敗", nil) subTitle:NSLocalizedString(@"此帳號不存在",nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    else
    {
        NSLog(@"incorrect pwd");
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
        [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"登入失敗", nil) subTitle:NSLocalizedString(@"密碼錯誤",nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    
    
}
- (void)onLoginFromThirdPartyFinishedNotification:(NSNotification*)notify
{
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"1"]) {
        NSLog(@"login!");
        
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user" ] objectForKey:@"user_id"] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user" ] objectForKey:@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user" ] objectForKey:@"name"] forKey:@"name"];
        [[NSUserDefaults standardUserDefaults]setObject:[[notify.object objectForKey:@"user" ] objectForKey:@"point_sum"] forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
    }
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
}

//Facebook graph api v2.3
- (IBAction)fbLoginAction:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"email",@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]&&[result.grantedPermissions containsObject:@"public_profile"]) {
                // Do work
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:@"/me"
                                              parameters:nil
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    NSLog(@"fb login result:%@",result);
                    NSString *profile_pic_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
                    [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"name"] forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"Facebook" forKey:@"LoginType"];
                    [[NSUserDefaults standardUserDefaults]setObject:profile_pic_url forKey:@"profile_image_url"];
                    NSLog(@"profile_image_url:%@",profile_pic_url);
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [[VintageApiService sharedInstance]loginFromThirdParty:[result objectForKey:@"id"] weibo_id:@"" email:[result objectForKey:@"email"] name:[result objectForKey:@"name"]];
                    
                }];
            }
        }
    }];
    
}
- (IBAction)weiboLoginAction:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFectchWeiboInfoNotification:) name:FetchingWeiboInfoNotification object:nil];
}
- (void)onFectchWeiboInfoNotification:(NSNotification*)notify
{
    NSLog(@"onFectchWeiboInfoNotification:%@",notify.object);
    [[NSUserDefaults standardUserDefaults]setObject:[notify.object objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
    [[NSUserDefaults standardUserDefaults]setObject:[notify.object objectForKey:@"name"] forKey:@"name"];
    [[NSUserDefaults standardUserDefaults]setObject:@"Weibo" forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[VintageApiService sharedInstance]loginFromThirdParty:@"" weibo_id:[notify.object objectForKey:@"id"] email:@"" name:[notify.object objectForKey:@"name"]];
    
}
//Login From Email

- (IBAction)emailLoginAction:(id)sender {
    if (self.emailTextField.text.length >0 && self.pwdTextField.text.length > 0)
    {
        [[VintageApiService sharedInstance]loginFromEmail:self.emailTextField.text password:self.pwdTextField.text];
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
        [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"資訊不完整", nil) subTitle:NSLocalizedString(@"請輸入完整資訊",nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showHomePage"]) {
        //ContentViewController *vc = [segue destinationViewController];
        
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
