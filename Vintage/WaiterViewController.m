//
//  WaiterViewController.m
//  Vintage
//
//  Created by Will Tang on 5/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "WaiterViewController.h"
#import "Vintage-Swift.h"
#import "VintageApiService.h"
#import "HexColors.h"
#import "VintageApiService.h"
#import "WineOverViewController.h"

@interface WaiterViewController ()
{
    int current_combo_number;
    NSString *languageKey;
    int firstSelectedOptionIndex;
    int secondSelectedOptionIndex;
    int currentQuestionIndex;
}
@end

@implementation WaiterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[VintageApiService sharedInstance]setLastTappedIndex:@"1"];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"b41c47" alpha:1.0] CGColor], (id)[[UIColor colorWithHexString:@"ff4d8e" alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.proccedButton.layer.cornerRadius = 14;
    self.proccedButton.layer.masksToBounds = YES;
    self.proccedButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];
    //在題組3與題組4之間切換
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"current_combo_number"])
    {
        current_combo_number = [[defaults valueForKey:@"current_combo_number"] intValue];
    }
    else
    {
        current_combo_number = 3;
        [defaults setValue:@"3" forKey:@"current_combo_number"];
        [defaults synchronize];
    }
    //決定語言
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"])
    {
        languageKey = @"title_en";
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        languageKey = @"title_cn";
    }
    else
    {
        languageKey = @"title_tw";
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self showGreeting];
    [self.questionImageView sendSubviewToBack:self.gradientLineView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingWaiterListNotification:) name:FetchingWaiterListNotification object:nil];
    decisionArray = [[NSMutableArray alloc]init];
    wine_id_array = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    questionTextArray = [[NSMutableArray alloc]init];
    idArray = [[NSMutableArray alloc]init];
}

-(void)viewDidLayoutSubviews
{
    //調整UI
    self.questionTextView.textAlignment = NSTextAlignmentCenter;
    self.questionTextView.textColor = [UIColor whiteColor];
    self.questionTextView.font = [UIFont boldSystemFontOfSize:self.view.bounds.size.width * 0.05];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FetchingWaiterListNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGreeting
{
    self.statusPromptImageVIew.image = [UIImage imageNamed:@"img_sommelier_icon"];
    self.correctPromptLabel.text = NSLocalizedString(@"行動侍酒師", nil) ;
    
    self.resultPromptText.text = NSLocalizedString(@"依您的喜好作答我們將推薦適合您的酒款", nil);
    [self showPopUpView];
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
}

- (IBAction)proceedAction:(id)sender
{
    self.popUpView.hidden = YES;
    [maskView removeFromSuperview];
    
    [[VintageApiService sharedInstance]fetchWaiterListInfo:[NSString stringWithFormat:@"%d",current_combo_number]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (current_combo_number == 3)
    {
        current_combo_number = 4;
        [defaults setValue:@"4" forKey:@"current_combo_number"];
        [defaults synchronize];
    }
    else
    {
        current_combo_number = 3;
        [defaults setValue:@"3" forKey:@"current_combo_number"];
        [defaults synchronize];
        
    }
}

- (void)onFetchingWaiterListNotification:(NSNotification*)notify
{
    questionDictionary = notify.object;
    currentQuestionIndex = 1;
    [self showUIForCurrentQuestion];
}

- (void)showUIForCurrentQuestion
{
    self.firstCircleView.image = [UIImage imageNamed:@"img_sommelierball_off"];
    self.secondCircleView.image = [UIImage imageNamed:@"img_sommelierball_off"];
    self.thirdCircleView.image = [UIImage imageNamed:@"img_sommelierball_off"];
    self.firstNumberView.image = [UIImage imageNamed:@"img_one_off"];
    self.secondNumberView.image = [UIImage imageNamed:@"img_sommelier_two_off"];
    self.thirdNumberView.image = [UIImage imageNamed:@"img_sommelier_three_off"];
    
    if (currentQuestionIndex == 1)
    {
        self.firstCircleView.image = [UIImage imageNamed:@"img_sommelierball_on"];
        self.firstNumberView.image = [UIImage imageNamed:@"img_one_on"];
    }
    else if (currentQuestionIndex == 2)
    {
        self.secondCircleView.image = [UIImage imageNamed:@"img_sommelierball_on"];
        self.secondNumberView.image = [UIImage imageNamed:@"img_one_on"];
    }
    else if (currentQuestionIndex == 3)
    {
        self.thirdCircleView.image = [UIImage imageNamed:@"img_sommelierball_on"];
        self.thirdNumberView.image = [UIImage imageNamed:@"img_one_on"];
    }
    NSDictionary *questionOne;
    if(currentQuestionIndex != 3)
    {
        questionOne = [[[questionDictionary objectForKey:@"questions"] objectAtIndex:(currentQuestionIndex - 1)] objectAtIndex:0];
    }
    else
    {
        questionOne = [[[questionDictionary objectForKey:@"questions"] objectAtIndex:(currentQuestionIndex - 1)] objectAtIndex:((firstSelectedOptionIndex-1)*3 + secondSelectedOptionIndex - 1)];
    }
    self.questionTextView.text = [questionOne valueForKey:languageKey];
    NSArray *questionOneOptions = [questionOne valueForKey:@"options"];
    [self.firstQuizButton setTitle:[[questionOneOptions objectAtIndex:0] valueForKey:languageKey] forState:UIControlStateNormal];
    self.firstQuizButton.tag = [[[questionOneOptions objectAtIndex:0] valueForKey:@"id"] intValue];
    [self.secondQuestionButton setTitle:[[questionOneOptions objectAtIndex:1] valueForKey:languageKey] forState:UIControlStateNormal];
    self.secondQuestionButton.tag = [[[questionOneOptions objectAtIndex:1] valueForKey:@"id"] intValue];
    [self.thirdQuestionButton setTitle:[[questionOneOptions objectAtIndex:2] valueForKey:languageKey] forState:UIControlStateNormal];
    self.thirdQuestionButton.tag = [[[questionOneOptions objectAtIndex:2] valueForKey:@"id"] intValue];
}

- (void)optionTappedWithOptionIndex:(int)optionIndex andOptionID:(long)optionID
{
    if (currentQuestionIndex == 1)
    {
        firstSelectedOptionIndex = optionIndex;
    }
    else if (currentQuestionIndex == 2)
    {
        secondSelectedOptionIndex = optionIndex;
    }
    [decisionArray addObject:[NSString stringWithFormat:@"%ld",optionID]];
    currentQuestionIndex ++;
    if (currentQuestionIndex <=3)
    {
        [self showUIForCurrentQuestion];
    }
    else
    {
        [self performSegueWithIdentifier:@"waiterToResult" sender:self];
    }
}

- (IBAction)firstAnswerTapped:(UIButton *)button
{
    NSLog(@"firstAnswerTapped ButtonTag:%ld",(long)button.tag);
    [self optionTappedWithOptionIndex:1 andOptionID:button.tag];
}

- (IBAction)secondAnswerTapped:(UIButton *)button
{
    NSLog(@"secondAnswerTapped ButtonTag:%ld",(long)button.tag);
    [self optionTappedWithOptionIndex:2 andOptionID:button.tag];
}

- (IBAction)thirdAnswerTapped:(UIButton *)button
{
    NSLog(@"thirdAnswerTapped ButtonTag:%ld",(long)button.tag);
    [self optionTappedWithOptionIndex:3 andOptionID:button.tag];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"waiterToResult"]) {
        WineOverViewController* vc = [segue destinationViewController];
        vc.pageName = NSLocalizedString(@"行動侍酒師", nil);
        vc.pageIndex = @"6";
        NSLog(@"decisionArray:%@",decisionArray);
        NSMutableString *decisionMutableString = [[NSMutableString alloc]init];
        for (int i = 0 ; i < decisionArray.count; i++) {
            [decisionMutableString appendFormat:@"%@,",[decisionArray objectAtIndex:i]];
        }
        NSLog(@"decisionMutableString:%@",decisionMutableString );
        vc.waiterDecisionString = [decisionMutableString substringToIndex:[decisionMutableString length]-1];
    }
}

- (IBAction)showSideBar:(id)sender
{
    [self.navigationController showSideMenuView];
}
@end
