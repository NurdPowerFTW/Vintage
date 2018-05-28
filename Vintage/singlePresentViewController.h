//
//  singlePresentViewController.h
//  Vintage
//
//  Created by Will Tang on 6/17/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singlePresentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UIView *maskView;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *popUpTopView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *obtainButton;
@property (strong, nonatomic) IBOutlet UIButton *onlineRedeemButton;
@property (nonatomic) BOOL can_redeem;
@property NSMutableArray* selectedEventArray;
@property id CellNib;
@property id CellNib2;
@property id CellNib3;
@end
