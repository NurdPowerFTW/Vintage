//
//  SearchResultViewController.h
//  Vintage
//
//  Created by Will Tang on 7/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIView *filterButtonView;

@property NSIndexPath *selectedIdx;
@property id cellNib;
@property id cellNib2;
@end
