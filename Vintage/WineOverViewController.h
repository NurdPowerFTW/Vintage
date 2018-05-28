//
//  WineOverViewController.h
//  Vintage
//
//  Created by Will Tang on 6/1/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WineOverViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *popUpTopView;
@property (weak, nonatomic) IBOutlet UIButton *proccedButton;
@property (weak, nonatomic) IBOutlet UIView *filterButtonView;

@property NSString* waiterDecisionString;
@property (nonatomic,copy)NSString* pageName;
@property (nonatomic,copy)NSString* pageIndex;
@property NSIndexPath *selectedIdx;
@property id cellNib;
@property id cellNib2;
@end
