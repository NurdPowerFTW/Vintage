//
//  AccountViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
extern NSString *ErasePersonalInfoNotification;

@interface AccountViewController : UIViewController <WeiboSDKDelegate,WBHttpRequestDelegate>
@property (weak, nonatomic) IBOutlet UILabel *loginTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *profile_pic_view;
@property (weak, nonatomic) IBOutlet UIImageView *profile_pic_imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *logoutButtonView;

@end
