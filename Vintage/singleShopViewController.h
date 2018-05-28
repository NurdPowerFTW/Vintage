//
//  singleShopViewController.h
//  Vintage
//
//  Created by Will Tang on 6/15/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singleShopViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *topBarTitle;
@property NSMutableArray* selectedEventArray;
@property NSMutableDictionary* textViews;
@property id CellNib;
@property id CellNib2;
@property id CellNib3;

@end
