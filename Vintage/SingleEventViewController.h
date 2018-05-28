//
//  SingleEventViewController.h
//  Vintage
//
//  Created by Will Tang on 5/23/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKShareKit.h"
#import "AppDelegate.h"

@interface SingleEventViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FBSDKSharingDelegate,WBHttpRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *sharePopUpView;
@property (weak, nonatomic) IBOutlet UIView *sharePopUpTopView;
@property (weak, nonatomic) IBOutlet UIView *fbShareButtonView;
@property (weak, nonatomic) IBOutlet UIView *wbShareButtonView;
@property (weak, nonatomic) IBOutlet UIView *shareResultPopUpView;
@property (weak, nonatomic) IBOutlet UIView *shareResultPopUpTopView;
@property (weak, nonatomic) IBOutlet UIButton *resultDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *fbShareButton;
@property (weak, nonatomic) IBOutlet UIButton *wbShareButton;




@property NSMutableArray* selectedEventArray;
@property NSMutableDictionary* textViews;
@property id CellNib;
@property id CellNib2;
@property id CellNib3;

@end
