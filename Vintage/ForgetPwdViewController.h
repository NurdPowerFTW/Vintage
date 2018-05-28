//
//  ForgetPwdViewController.h
//  Vintage
//
//  Created by William on 5/22/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailFieldView;
@property (weak, nonatomic) IBOutlet UIView *resetButtonView;




@end
