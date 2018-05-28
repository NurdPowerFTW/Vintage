//
//  tableWithLineViewCell.h
//  Vintage
//
//  Created by Will Tang on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableWithLineViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryTextField;
@property (weak, nonatomic) IBOutlet UILabel *describeTextField;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIImageView *circleImg;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@end
