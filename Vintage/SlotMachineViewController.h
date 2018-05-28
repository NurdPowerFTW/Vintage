//
//  SlotMachineViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlotMachineViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *itemImageView;
}
@property (weak, nonatomic) IBOutlet UIView *slotMachineView;
@property (weak, nonatomic) IBOutlet UIScrollView *slotScrollView;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIView *startButtonView;



@end
