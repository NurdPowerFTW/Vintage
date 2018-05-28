//
//  WaiterResultViewController.h
//  Vintage
//
//  Created by Will Tang on 6/8/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaiterResultViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIView *maskView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *popUpTopView;
@property (weak, nonatomic) IBOutlet UIButton *proccedButton;
@property NSIndexPath *selectedIdx;

@property id cellNib;
@property id cellNib2;
@end
