//
//  QuizViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "QuizViewController.h"
#import "Vintage-Swift.h"
#import "HexColors.h"
#import "VintageApiService.h"


@implementation QuizViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"6"];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"7d07d8" alpha:1.0] CGColor], (id)[[UIColor colorWithHexString:@"c31bde" alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    questionDictionary = [[NSMutableDictionary alloc]init];
    [self.questionImageView sendSubviewToBack:self.gradientLineView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingQuizListInfoNotification:) name:FetchingQuizListNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSendingQuizAnswerInfoNotification:) name:SendQuizAnswerNotification object:nil];
    
    correctCount = 0;
    self.popUpView.hidden = YES;
    self.proccedButton.layer.cornerRadius = 14;
    self.proccedButton.layer.masksToBounds = YES;
    self.proccedButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
    [[VintageApiService sharedInstance]fetchQuizListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] date:[DateFormatter stringFromDate:[NSDate date]]];
}
- (void)onFetchingQuizListInfoNotification:(NSNotification*)notify
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    questionDictionary = notify.object;
    [self showPopupWithStyle:CNPPopupStyleCentered];
    if ([language isEqualToString:@"en"]) {
        self.questionTextView.text = [[questionDictionary objectForKey:@"game"]objectForKey:@"title_en"];
        [self.firstQuizButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:0]valueForKey:@"title_en"] forState:UIControlStateNormal];
        [self.secondQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:1]valueForKey:@"title_en"] forState:UIControlStateNormal];
        [self.thirdQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:2]valueForKey:@"title_en"] forState:UIControlStateNormal];
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        self.questionTextView.text = [[questionDictionary objectForKey:@"game"]objectForKey:@"title_cn"];
        [self.firstQuizButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:0]valueForKey:@"title_cn"] forState:UIControlStateNormal];
        [self.secondQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:1]valueForKey:@"title_cn"] forState:UIControlStateNormal];
        [self.thirdQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:2]valueForKey:@"title_cn"] forState:UIControlStateNormal];
    }
    else
    {
        self.questionTextView.text = [[questionDictionary objectForKey:@"game"]objectForKey:@"title_tw"];
        [self.firstQuizButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:0]valueForKey:@"title_tw"] forState:UIControlStateNormal];
        [self.secondQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:1]valueForKey:@"title_tw"] forState:UIControlStateNormal];
        [self.thirdQuestionButton setTitle:[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:2]valueForKey:@"title_tw"] forState:UIControlStateNormal];
    }
    
    self.questionTextView.textAlignment = NSTextAlignmentCenter;
    self.questionTextView.textColor = [UIColor whiteColor];
    self.questionTextView.font = [UIFont boldSystemFontOfSize:self.view.bounds.size.width * 0.05];
    
    
    //NSLog(@"test 1:%@",[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:0]valueForKey:@"title_tw"]);
}

- (void)onSendingQuizAnswerInfoNotification:(NSNotification*)notify
{
    answerDictionary = notify.object;
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"answerDictionary:%@",answerDictionary);
    NSInteger point_sum = [[answerDictionary objectForKey:@"point"]integerValue];
    NSInteger currentPoint = [[[NSUserDefaults standardUserDefaults]objectForKey:@"point_sum"]integerValue];
    NSInteger resultPoint = point_sum + currentPoint;
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)resultPoint] forKey:@"point_sum"];
    [[VintageApiService sharedInstance]fetchQuizListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] date:[DateFormatter stringFromDate:[NSDate date]]];
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    if ([[questionDictionary objectForKey:@"ERR_CODE"]isEqualToString:@"29"])
    {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"本日問題已全數回答完畢", nil)  attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"請明日繼續挑戰!", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
        
        //NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"返回", nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
        
        CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
        buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
            NSLog(@"Block for button: %@", item.buttonTitle.string);
            
        };
        
        self.popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne] buttonItems:@[buttonItem] destructiveButtonItem:nil];
        self.popupController.theme = [CNPPopupTheme defaultTheme];
        self.popupController.theme.popupStyle = popupStyle;
        self.popupController.delegate = self;
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromRight;
        [self.popupController presentPopupControllerAnimated:YES];
    }
    else
    {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"每日限定三題", nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString: NSLocalizedString(@"快來賺點數吧!", nil)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
        
        //NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"確定",nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
        
        CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
        buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
            NSLog(@"Block for button: %@", item.buttonTitle.string);
            
        };
        
        self.popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne] buttonItems:@[buttonItem] destructiveButtonItem:nil];
        self.popupController.theme = [CNPPopupTheme defaultTheme];
        self.popupController.theme.popupStyle = popupStyle;
        self.popupController.delegate = self;
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromRight;
        [self.popupController presentPopupControllerAnimated:YES];
    }
}
- (void)showPopUpView
{
    self.popUpView.hidden = NO;
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height)];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:maskView];
    [self.view bringSubviewToFront:self.popUpView];
    self.popUpTopView.layer.cornerRadius = self.popUpTopView.bounds.size.width/2;
    self.popUpTopView.layer.masksToBounds = YES;
    self.popUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
    
    self.popUpView.layer.cornerRadius = 10;
    self.popUpView.layer.masksToBounds = NO;
    if (correctCount == 3) {
        self.resultImageView.image = [UIImage imageNamed:@"img_menubadge_star"];
        self.correctPromptLabel.text = NSLocalizedString (@"恭喜你",nil);
        NSString *myString1 = NSLocalizedString (@"本日問題已全數回答完畢",nil);
        NSString *myString2 = NSLocalizedString (@"請明日繼續挑戰!",nil);
        self.resultPromptText.text =[NSString stringWithFormat:@"%@\r%@", myString1,myString2];
        
        
    }
}
- (void)checkAnswers:(NSInteger)buttonNum
{
    
    switch (correctCount) {
        case 0:
            if ([[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:buttonNum]valueForKey:@"correct"]integerValue]==1)
            {
                self.firstCircleView.image = [UIImage imageNamed:@"img_takepointsball_on"];
                self.secondCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.thirdCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.firstNumberView.image = [UIImage imageNamed:@"img_one_on"];
                self.secondNumberView.image = [UIImage imageNamed:@"img_takepoints_two_off"];
                self.thirdNumberView.image = [UIImage imageNamed:@"img_takepoints_three_off"];
                
                self.resultImageView.image = [UIImage imageNamed:@"img_point"];
                self.correctPromptLabel.text = NSLocalizedString (@"獲得點數",nil);
                self.resultPromptText.text = NSLocalizedString (@"獲得答題點數!",nil);
                [self showPopUpView];
                [[VintageApiService sharedInstance]sendQuizAnswerInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] game_id:[[questionDictionary objectForKey:@"game"]objectForKey:@"id"]];
                correctCount++;
                
            }
            else
            {
                self.resultImageView.image = [UIImage imageNamed:@"img_error"];
                self.correctPromptLabel.text = NSLocalizedString (@"答案不正確",nil);
                self.resultPromptText.text = NSLocalizedString (@"答案不正確喔，請再試一次",nil);
                [self showPopUpView];
            }
            
            break;
        case 1:
            if ([[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:buttonNum]valueForKey:@"correct"]integerValue]==1)
            {
                self.firstCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.secondCircleView.image = [UIImage imageNamed:@"img_takepointsball_on"];
                self.thirdCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.firstNumberView.image = [UIImage imageNamed:@"img_takepoints_one_off"];
                self.secondNumberView.image = [UIImage imageNamed:@"img_two_on"];
                self.thirdNumberView.image = [UIImage imageNamed:@"img_takepoints_three_off"];
                self.resultImageView.image = [UIImage imageNamed:@"img_point"];
                self.correctPromptLabel.text = NSLocalizedString (@"獲得點數",nil);
                self.resultPromptText.text = NSLocalizedString (@"獲得答題點數!",nil);
                [self showPopUpView];
                [[VintageApiService sharedInstance]sendQuizAnswerInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] game_id:[[questionDictionary objectForKey:@"game"]objectForKey:@"id"]];
                correctCount++;
            }
            else
            {
                self.resultImageView.image = [UIImage imageNamed:@"img_error"];
                self.correctPromptLabel.text = NSLocalizedString (@"答案不正確",nil);
                self.resultPromptText.text = NSLocalizedString (@"答案不正確喔，請再試一次",nil);
                [self showPopUpView];
            }
            break;
        case 2:
            if ([[[[[questionDictionary objectForKey:@"game"]objectForKey:@"game_options"]objectAtIndex:buttonNum]valueForKey:@"correct"]integerValue]==1)
            {
                self.firstCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.secondCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
                self.thirdCircleView.image = [UIImage imageNamed:@"img_takepointsball_on"];
                self.firstNumberView.image = [UIImage imageNamed:@"img_takepoints_one_off"];
                self.secondNumberView.image = [UIImage imageNamed:@"img_takepoints_two_off"];
                self.thirdNumberView.image = [UIImage imageNamed:@"img_three_on"];
                //[self performSegueWithIdentifier:@"waiterToResult" sender:self];
                self.resultImageView.image = [UIImage imageNamed:@"img_point"];
                [[VintageApiService sharedInstance]sendQuizAnswerInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] game_id:[[questionDictionary objectForKey:@"game"]objectForKey:@"id"]];
                self.correctPromptLabel.text = NSLocalizedString (@"答案正確",nil);
                self.resultPromptText.text = NSLocalizedString(@"本日問題已全數回答完畢",nil);
                [self showPopUpView];
                correctCount++;
            }
            else
            {
                self.resultImageView.image = [UIImage imageNamed:@"img_error"];
                self.correctPromptLabel.text = NSLocalizedString (@"答案不正確",nil);
                self.resultPromptText.text = NSLocalizedString (@"答案不正確喔，請再試一次",nil);
                [self showPopUpView];
            }
        default:
            break;
    }
}
- (IBAction)firstAnswerTapped:(UIButton*)sender {
    [self checkAnswers:sender.tag];
}
- (IBAction)secondAnswerTapped:(UIButton*)sender {
    [self checkAnswers:sender.tag];
}
- (IBAction)thirdAnswerTapped:(UIButton*)sender {
    [self checkAnswers:sender.tag];
    
}
- (IBAction)proceedAction:(id)sender {
    self.popUpView.hidden = YES;
    [maskView removeFromSuperview];
    if (correctCount == 3)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
    }
}
- (IBAction)showSideBar:(id)sender {
    [self.navigationController showSideMenuView];
    
}
- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
    if ([[questionDictionary objectForKey:@"ERR_CODE"]isEqualToString:@"29"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
    }
    else
    {
        self.firstCircleView.image = [UIImage imageNamed:@"img_takepointsball_on"];
        self.secondCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
        self.thirdCircleView.image = [UIImage imageNamed:@"img_takepointsball_off"];
        self.firstNumberView.image = [UIImage imageNamed:@"img_one_on"];
        self.secondNumberView.image = [UIImage imageNamed:@"img_takepoints_two_off"];
        self.thirdNumberView.image = [UIImage imageNamed:@"img_takepoints_three_off"];
    }
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}
@end
