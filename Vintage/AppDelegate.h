//
//  AppDelegate.h
//  Vintage
//
//  Created by William on 4/16/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ContentViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Vintage-Swift.h"
#import "SideBarMenuController.h"
#import "WeiboSDK.h"
#import "FBSDKLoginKit/FBSDKLoginManager.h"
#import <AFNetworkReachabilityManager.h>
#import "SCLAlertView.h"
#define kAppKey @"1481517449"
#define kRedirctURL @"https://api.weibo.com/oauth2/default.html"
extern NSString *FetchingWeiboInfoNotification;

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSDictionary *jsonDict;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

