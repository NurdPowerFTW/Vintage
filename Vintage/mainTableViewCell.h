//
//  mainTableViewCell.h
//  Vintage
//
//  Created by Will Tang on 5/17/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryTextField;
@property (weak, nonatomic) IBOutlet UILabel *describeTextField;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIImageView *circleImg;

@end
