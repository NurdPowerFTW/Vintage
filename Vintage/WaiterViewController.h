//
//  WaiterViewController.h
//  Vintage
//
//  Created by Will Tang on 5/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPPopupController.h"
@interface WaiterViewController : UIViewController
<UITextViewDelegate,CNPPopupControllerDelegate>
{
    NSMutableDictionary *questionDictionary;
    NSMutableArray *decisionArray;
    NSMutableArray *idArray;
    NSMutableArray *titleArray;
    NSMutableArray *questionTextArray;
    NSMutableArray *wine_id_array;
    NSString* selectedSequence;
    UIView *maskView;
    BOOL is_correct;
}
@property (weak, nonatomic) IBOutlet UIImageView *firstCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *secondCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *firstNumberView;
@property (weak, nonatomic) IBOutlet UIImageView *secondNumberView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdNumberView;
@property (weak, nonatomic) IBOutlet UILabel *correctPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultPromptText;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIView *gradientLineView;
@property (weak, nonatomic) IBOutlet UIView *questionImageView;
@property (weak, nonatomic) IBOutlet UIView *popUpTopView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UIButton *firstQuizButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusPromptImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *proccedButton;

@property (weak, nonatomic) IBOutlet UIButton *secondQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdQuestionButton;
@end
