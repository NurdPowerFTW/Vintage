//
//  SearchViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString* pageIndex;
@property (nonatomic)  NSUserDefaults *defaults;
@property (nonatomic)  NSMutableArray *searchItemArray;

@property id cellNib;
@property id cellNib2;
@end
