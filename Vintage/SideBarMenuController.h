//
//  SideBarMenuController.h
//  Vintage
//
//  Created by William on 5/13/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vintage-Swift.h"
@interface SideBarMenuController : UIViewController <ENSideMenuDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property NSMutableArray *tableItemArray;
@property NSMutableDictionary* personalInfoDictionary;
@property ENSideMenu* sideMenu;
@property id CellNib;
@end
