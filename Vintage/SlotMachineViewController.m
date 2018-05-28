//
//  SlotMachineViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SlotMachineViewController.h"
#import "Vintage-Swift.h"
#import "VintageApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"
#import "LoginViewController.h"
#import "SCLAlertView.h"
@implementation SlotMachineViewController
{
    NSArray *slotIcon;
    NSMutableArray *slotItemArray;
    NSArray *slotTitle;
    NSInteger numberOfItems;
    NSString *point_sum;
    NSInteger prizeID;
    NSInteger prizeIndex;
    NSString *prizeName;
    int rollingIndex;
    int cycleIndex;
    float eachItemWidth;
    float eachItemHeight;
    
}
#pragma mark - View LifeCycle




- (void)viewDidLoad
{
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"7"];
    slotIcon = [[NSArray alloc]init];
    slotItemArray = [[NSMutableArray alloc]init];
    slotTitle = [[NSArray alloc]init];
    
    self.startButtonView.layer.cornerRadius = 12;
    self.startButtonView.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingSlotMachineInfoNotification:) name:FetchingSlotMachineInfoNotification object:nil];
    [[VintageApiService sharedInstance]fetchSlotMachineListInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSendSlotRequestNotification:) name:SendSlotRequestNotification object:nil];
    
    CGRect rect = CGRectMake(0,0,self.view.frame.size.width * 0.863,self.view.frame.size.height * 0.37);
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageNamed:@"img_upperlayer.png"]drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    
    self.slotMachineView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    //self.slotScrollView.backgroundColor = [UIColor colorWithPatternImage:upperLayerImage];
    eachItemWidth = self.view.frame.size.width *0.5;
    eachItemHeight = self.view.frame.size.height *0.352;
    self.slotScrollView.delegate = self;
    NSAttributedString* pointCharacter = [[NSAttributedString alloc]initWithString:NSLocalizedString(@" 點",nil)];
    NSMutableAttributedString *point_sum_string = [[NSMutableAttributedString alloc]initWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"point_sum"]];
    NSRange range = NSMakeRange(0,point_sum_string.length);
    [point_sum_string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c12558"] range:range];
    [point_sum_string appendAttributedString:pointCharacter];
    self.pointLabel.attributedText = point_sum_string;
    
    self.slotScrollView.userInteractionEnabled = NO;
    
}

- (void)onSendSlotRequestNotification:(NSNotification*)notify
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    point_sum = [notify.object objectForKey:@"point_sum"];
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"332"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
        [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"您的點數不足", nil) subTitle:NSLocalizedString(@"趕快分享文章收集點數吧",nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
    else
    {
        NSAttributedString* pointCharacter = [[NSAttributedString alloc]initWithString:@" 點"];
        NSMutableAttributedString *point_sum_string = [[NSMutableAttributedString alloc]initWithString:point_sum];
        NSRange range = NSMakeRange(0,point_sum_string.length);
        [point_sum_string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c12558"] range:range];
        [point_sum_string appendAttributedString:pointCharacter];
        self.pointLabel.attributedText = point_sum_string;
        [[NSUserDefaults standardUserDefaults]setObject:point_sum forKey:@"point_sum"];
        prizeID = [[[notify.object objectForKey:@"result"] valueForKey:@"id"]integerValue];
        
        for (NSInteger i = 0; i < slotItemArray.count; i++) {
            if ([[[notify.object objectForKey:@"result"] valueForKey:@"id"] isEqualToString:[[slotItemArray objectAtIndex:i] valueForKey:@"id"]])
            {
                prizeIndex = i;
                if ([language isEqualToString:@"en"])
                {
                    prizeName = [NSString stringWithFormat:NSLocalizedString(@"獲得%@", nil) ,[[slotItemArray objectAtIndex:i] valueForKey:@"title_en"]];
                }
                else if ([language isEqualToString:@"zh-Hans"])
                {
                    prizeName = [NSString stringWithFormat:NSLocalizedString(@"獲得%@", nil) ,[[slotItemArray objectAtIndex:i] valueForKey:@"title_cn"]];
                }
                else
                {
                    prizeName = [NSString stringWithFormat:NSLocalizedString(@"獲得%@", nil) ,[[slotItemArray objectAtIndex:i] valueForKey:@"title_tw"]];
                }
                
                
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
        [self rollingSlot];
        
        
    }
}
- (void)onFetchingSlotMachineInfoNotification:(NSNotification*)notify
{
    
    slotItemArray = [notify.object objectForKey:@"slots"];
    slotIcon = [[notify.object objectForKey:@"slots"]valueForKey:@"pic_url"];
    slotTitle = [[notify.object objectForKey:@"slots"]valueForKey:@"title_tw"];
    NSLog(@"slotIcon:%@",slotIcon);
    [self.slotScrollView setContentSize:(CGSizeMake(0, eachItemHeight))];
    for (int i = 0; i <slotIcon.count; i++)
    {
        [self createItemInSlotWithImageURL:[slotIcon objectAtIndex:i] andTitleText:[slotTitle objectAtIndex:i] andTag:[[[slotItemArray objectAtIndex:i] valueForKey:@"id"] integerValue]];
    }
    numberOfItems = slotIcon.count;
    //must add 2 dummy item
    [self createItemInSlotWithImageURL:[slotIcon objectAtIndex:0] andTitleText:[slotTitle objectAtIndex:0] andTag:0];
    [self createItemInSlotWithImageURL:[slotIcon objectAtIndex:1] andTitleText:[slotTitle objectAtIndex:1] andTag:0];
    [self.slotScrollView setContentOffset:CGPointMake(eachItemWidth-(self.slotScrollView.frame.size.width - eachItemWidth)/2, 0)];
    [self.slotScrollView setContentSize:(CGSizeMake(self.slotScrollView.contentSize.width+self.slotScrollView.frame.size.width, self.slotScrollView.contentSize.height))];

    
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.slotScrollView setDelegate:nil];
}
- (void)createItemInSlotWithImageURL:(NSString *)imageURL andTitleText:(NSString *)titleText andTag:(NSInteger)priceIDTag
{
    CGFloat scrollViewWidth = self.slotScrollView.contentSize.width;
    CGFloat scrollViewHeight = self.slotScrollView.contentSize.height;
    
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(scrollViewWidth, 0, eachItemWidth, eachItemHeight)];
    itemView.tag = priceIDTag;
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.05 , self.view.frame.size.height *0.048, self.view.frame.size.width * 0.4, self.view.frame.size.height *0.22)];
    [itemImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    itemImageView.layer.cornerRadius = itemImageView.frame.size.width/2;
    itemImageView.layer.masksToBounds = YES;
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height *0.3, self.view.frame.size.width * 0.5 , 16)];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.text = titleText;
    itemLabel.font = [UIFont systemFontOfSize:12.0];
    [itemView addSubview:itemImageView];
    [itemView addSubview:itemLabel];
    [self.slotScrollView addSubview:itemView];
    //itemImageView.center = self.slotScrollView.center;
    
    scrollViewWidth = scrollViewWidth + itemView.frame.size.width;
    [self.slotScrollView setContentSize:(CGSizeMake(scrollViewWidth, scrollViewHeight))];
}


- (void)rollingSlot
{
    
    if(rollingIndex >= numberOfItems)
    {
        //Already rolled 1 cycle, now move the scrollView to first item
        [self.slotScrollView scrollRectToVisible:CGRectMake(self.slotScrollView.contentOffset.x - numberOfItems * eachItemWidth, 0, self.slotScrollView.frame.size.width, self.slotScrollView.frame.size.height) animated:NO];
        
        cycleIndex ++;
        
        if(cycleIndex >= 3)
        {
            //Rolling 3 cycles and it's time to just show the prize!!
            [self.slotScrollView scrollRectToVisible:CGRectMake(prizeIndex * eachItemWidth, 0, self.slotScrollView.frame.size.width, self.slotScrollView.frame.size.height) animated:YES];
            [self.slotScrollView setContentOffset:CGPointMake(self.slotScrollView.contentOffset.x-(self.slotScrollView.frame.size.width - eachItemWidth)/2, 0)];
            //add outer ring
            
            for (UIView *itemView in self.slotScrollView.subviews)
            {
                if (itemView.tag == prizeID)
                {
                    UIImageView *prizeImageView = [itemView.subviews objectAtIndex:0];
                    prizeImageView.layer.borderWidth = 3.0f;
                    prizeImageView.layer.borderColor = [UIColor colorWithHexString:@"a71645"].CGColor;
                }
            }
            
            [self performSelector:@selector(showPrizeAlertView) withObject:self afterDelay:1.0];
            
            
            
        }
        else
        {
            //Let's do another cycle!
            rollingIndex = 0;
            
            [self rollingSlot];
        }
        
    }
    else
    {
        rollingIndex ++;
        [UIView animateWithDuration:0.2 animations:^{
            [self.slotScrollView scrollRectToVisible:CGRectMake(self.slotScrollView.contentOffset.x + 1 * eachItemWidth, 0, self.slotScrollView.frame.size.width, self.slotScrollView.frame.size.height) animated:NO];
            
        } completion:^(BOOL finished) {
            [self rollingSlot];
        }];
    }
    
}
- (void)showPrizeAlertView
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
    [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
    [alert showCustom:[UIImage imageNamed:@"img_present"] color:[UIColor colorWithHexString:@"a71645"] title:prizeName subTitle:NSLocalizedString(@"請至我的好禮查詢",nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    self.startButtonView.userInteractionEnabled = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    /*
     if (scrollView.contentOffset.x >= (numberOfItems) * eachItemWidth)
     {
     [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x - numberOfItems * eachItemWidth, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
     }
     */
    //[self rollingSlot];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    /*
     if (scrollView.contentOffset.x >= (numberOfItems) * eachItemWidth)
     {
     [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x - numberOfItems * eachItemWidth, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
     }
     */
    //[self rollingSlot];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (IBAction)beginAction:(id)sender {
    self.startButtonView.userInteractionEnabled = NO;
    rollingIndex = (int)prizeIndex;
    for (UIView *itemView in self.slotScrollView.subviews)
    {
        if (itemView.tag != 0)
        {
            UIImageView *prizeImageView = [itemView.subviews objectAtIndex:0];
            prizeImageView.layer.borderWidth = 0.0f;

        }
        
    }
    cycleIndex = 0;
    rollingIndex = 0;
    [[VintageApiService sharedInstance]sendSlotMachineRequest:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"]];
}
- (IBAction)showSideBar:(id)sender {
    [self.navigationController showSideMenuView];
}

@end
