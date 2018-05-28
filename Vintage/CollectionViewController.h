//
//  CollectionViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    BOOL will_cancel;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBarVIew;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAction;
@property NSIndexPath *selectedIdx;
@property NSMutableArray *selectedButtonIdxArray;
@property id cellNib;
@property id cellNib2;
@end