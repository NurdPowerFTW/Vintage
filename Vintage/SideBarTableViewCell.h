//
//  SideBarTableViewCell.h
//  Vintage
//
//  Created by Will Tang on 5/19/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeText;
@property (weak, nonatomic) IBOutlet UILabel *buttonText;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIView *highlightedEdge;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end
