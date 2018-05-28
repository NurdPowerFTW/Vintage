//
//  NewItemTableViewCell.m
//  Vintage
//
//  Created by Will Tang on 5/28/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "NewItemTableViewCell.h"

@implementation NewItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
