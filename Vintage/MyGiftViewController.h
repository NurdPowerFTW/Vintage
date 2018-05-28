//
//  MyGiftViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGiftViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *obtainButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property NSInteger selectedBannerIndex;
@property id cellNib;
@property id cellNib2;
@end
