//
//  NewItemTableViewCell.h
//  Vintage
//
//  Created by Will Tang on 5/28/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIView *imageWrapper;

@end
