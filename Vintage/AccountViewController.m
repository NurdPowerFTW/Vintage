//
//  AccountViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "AccountViewController.h"
#import "Vintage-Swift.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VintageApiService.h"

NSString *ErasePersonalInfoNotification = @"ErasePersonalInfoNotification";

@implementation AccountViewController 

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"5"];
    self.logoutButtonView.layer.cornerRadius = 20;
    self.logoutButtonView.layer.masksToBounds = YES;
    self.profile_pic_view.layer.cornerRadius = self.view.frame.size.width * 0.3125 / 2;
    self.profile_pic_view.layer.masksToBounds = YES;
    self.profile_pic_view.layer.borderWidth = 2;
    self.profile_pic_view.layer.borderColor = [UIColor whiteColor].CGColor;
    [self checkCurrentLoginType];
}
- (IBAction)logOutAction:(id)sender {
    [self logoutService];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
}
- (IBAction)showSideBar:(id)sender {
    [self.navigationController showSideMenuView];
}

-(void)checkCurrentLoginType
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"])
    {
        self.loginTypeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您目前以 %@ 登入", nil),@"Facebook"];
        [self.profile_pic_imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url"]]];
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
    {
        self.loginTypeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您目前以 %@ 登入", nil),@"Weibo"];
        [self.profile_pic_imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url"]]];
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    }
    else
    {
        self.loginTypeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您目前以 %@ 登入", nil),@"Email"];
        [self.profile_pic_imageView setImage:[UIImage imageNamed:@"img_people_default"]];
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    }
}
- (void)logoutService
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"])
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        

        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:@"none" forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:ErasePersonalInfoNotification object:nil];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
    {
        [WeiboSDK logOutWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"weibo_token"] delegate:self withTag:@
         "weibo_logout"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:@"none" forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:ErasePersonalInfoNotification object:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:@"none" forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:ErasePersonalInfoNotification object:nil];
    }
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}
@end
