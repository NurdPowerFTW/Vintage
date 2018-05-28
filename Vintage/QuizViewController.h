//
//  QuizViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPPopupController.h"

@interface QuizViewController : UIViewController <UITextViewDelegate,CNPPopupControllerDelegate>
{
    NSMutableDictionary *questionDictionary;
    NSMutableDictionary *answerDictionary;
    UIView *maskView;
    BOOL is_correct;
    int correctCount;
    
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
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@property (weak, nonatomic) IBOutlet UIButton *secondQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *proccedButton;



@end
