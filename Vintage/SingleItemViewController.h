//
//  SingleItemViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKShareKit.h"
#import "RPFloatingPlaceholderTextField.h"
#import "RPFloatingPlaceholderTextView.h"
#import "SCLAlertView.h"
@interface SingleItemViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,FBSDKSharingDelegate,UITextFieldDelegate>
{
    UIView *maskView;
    BOOL selected;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UIView *queryPopUpView;
@property (weak, nonatomic) IBOutlet UIView *queryPopUpTopView;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *contactTextField;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextView *contextTextView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *sharePopUpView;
@property (weak, nonatomic) IBOutlet UIView *sharePopUpTopView;
@property (weak, nonatomic) IBOutlet UIView *fbShareButtonView;
@property (weak, nonatomic) IBOutlet UIView *wbShareButtonView;
@property (weak, nonatomic) IBOutlet UIButton *fbShareButton;
@property (weak, nonatomic) IBOutlet UIButton *wbShareButton;


@property (strong,nonatomic)FBSDKShareDialog* shareDialog;
@property NSString *twTitleString;
@property NSString *enTitleString;
@property NSString *priceString;
@property NSString *manufactureString;
@property NSString *productImageString;
@property NSString *windIdString;
@property NSMutableDictionary *selectedWineInfoDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *likeButtonImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *askButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@property id CellNib;
@property id CellNib2;
@end
