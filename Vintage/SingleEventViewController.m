//
//  SingleEventViewController.m
//  Vintage
//
//  Created by Will Tang on 5/23/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SingleEventViewController.h"
#import "singleEventTitleCellTableViewCell.h"
#import "singleEventDescriptionCell.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "VintageApiService.h"
#import "EventTableCell.h"
#import "HexColors.h"
#import "VintageApiService.h"
#import "SCLAlertView.h"
#import "SingleMapViewController.h"
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* CellIdentifier = @"singleEventTableViewCell";
@interface SingleEventViewController ()
{
    UIView *maskView;
}

@end

@implementation SingleEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    //[self.bannerImageView setImageWithURL:[NSURL URLWithString:[self.selectedEventArray valueForKey:@"pic_url"]] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.textViews = [[NSMutableDictionary alloc]init];
    
    self.sharePopUpView.hidden = YES;
    self.shareResultPopUpView.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUpdatePointListNotification:) name:updatePointsListNotification object:nil];
    UITapGestureRecognizer* cancelPopUpViewRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPopUpView:)];
    [self.view addGestureRecognizer:cancelPopUpViewRecog];
    
    NSLog(@"self.selectedEventArray:%@",self.selectedEventArray);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


-(void)viewDidLayoutSubviews
{
    [self.tableView reloadData];
}

- (void)cancelPopUpView:(UITapGestureRecognizer *)recog
{
    if (self.sharePopUpView.hidden == NO || self.shareResultPopUpView.hidden == NO || maskView.hidden == NO) {
        self.shareResultPopUpView.hidden = YES;
        self.sharePopUpView.hidden = YES;
        maskView.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onUpdatePointListNotification:(NSNotification*)notify
{
    if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"23"])
    {
        maskView.hidden = YES;
        [self resultPopUpView:[notify.object objectForKey:@"point"]];
        [[NSUserDefaults standardUserDefaults]setObject:[notify.object objectForKey:@"point_sum"] forKey:@"point_sum"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
        
    }
    else
    {
        maskView.hidden = YES;
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
        [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"每個活動只能獲得一次分享點數", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
}
- (void)popShareView
{
    self.sharePopUpView.hidden = NO;
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height)];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:maskView];
    [self.view bringSubviewToFront:self.sharePopUpView];
    self.sharePopUpTopView.layer.cornerRadius = self.sharePopUpTopView.bounds.size.width/2;
    self.sharePopUpTopView.layer.masksToBounds = YES;
    self.sharePopUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
    
    self.sharePopUpView.layer.cornerRadius = 10;
    self.sharePopUpView.layer.masksToBounds = NO;
    self.fbShareButtonView.layer.cornerRadius = 10;
    self.fbShareButtonView.layer.masksToBounds = YES;
    self.wbShareButtonView.layer.cornerRadius = 10;
    self.wbShareButtonView.layer.masksToBounds = YES;
}
- (void)resultPopUpView:(NSString*)returnedPoints
{
    /*self.shareResultPopUpView.hidden = NO;
     
     [self.view bringSubviewToFront:self.shareResultPopUpView];
     self.shareResultPopUpTopView.layer.cornerRadius = self.shareResultPopUpTopView.bounds.size.width/2;
     self.shareResultPopUpTopView.layer.masksToBounds = YES;
     self.shareResultPopUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
     self.shareResultPopUpView.layer.cornerRadius = 10;
     self.shareResultPopUpView.layer.masksToBounds = NO;
     self.resultDoneButton.layer.cornerRadius = 14;
     self.resultDoneButton.layer.masksToBounds = YES;
     self.resultDoneButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];*/
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
    [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
    NSString *pointString = [NSString stringWithFormat:NSLocalizedString(@"獲得分享點數%@點", nil),returnedPoints];
    [alert showCustom:[UIImage imageNamed:@"img_point"] color:[UIColor colorWithHexString:@"a71645"] title:@"" subTitle:pointString closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f]; // Custom
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (float)calculateTextViewHeight:(NSString*)text
{
    UITextView *textView = [[UITextView alloc] init];
    NSString* title =text;
    [textView setText:title];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView sizeToFit];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width * 0.7, FLT_MAX)];
    //return size.height+ self.view.frame.size.height * 0.088;
    return size.height+55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // check here, if it is one of the cells, that needs to be resized
    // to the size of the contained UITextView
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (indexPath.row == 0)
    {
        return self.view.frame.size.width * 0.75;
    }
    else if (indexPath.row == 1)
    {
        //return self.view.frame.size.height * 0.153169;
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"title_en"]]+[self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"subtitle_en"]]-60;
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"title_cn"]]+[self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"subtitle_cn"]]-60;
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"title_tw"]]+[self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"subtitle_tw"]]-60;
        }
        
    }
    else if (indexPath.row == 2)
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"content_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"content_cn"]];
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"content_tw"]];
        }
        
    }
    else if (indexPath.row == 3)
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"location_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"location_cn"]];
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"location_tw"]];
        }
        
    }
    else if (indexPath.row == 4)
    {
        
        return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"phone_tw"]];
    }
    else if (indexPath.row == 5)
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"time_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"time_cn"]];
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"time_tw"]];
        }
        
    }
    else
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_en"]]+ self.view.frame.size.height *0.05;
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_cn"]]+ self.view.frame.size.height *0.05;
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_tw"]]+ self.view.frame.size.height *0.05;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (indexPath.row == 0 ) {
        static NSString* CellIdentifier = @"EventTableCell";
        EventTableCell* cell;
        cell = (EventTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            if (!self.CellNib)
            {
                self.CellNib = [UINib nibWithNibName:@"EventTableCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.CellNib instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        [cell.bannerImage setImageWithURL:[NSURL URLWithString:[self.selectedEventArray valueForKey:@"pic_url"]] placeholderImage:[UIImage imageNamed:@"img_default"]];
        return cell;
    }
    
    else if (indexPath.row == 1)
    {
        static NSString* CellIdentifier = @"singleEventTitleCellTableViewCell";
        singleEventTitleCellTableViewCell* cell;
        cell = (singleEventTitleCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            if (!self.CellNib2)
            {
                self.CellNib2 = [UINib nibWithNibName:@"singleEventTitleCellTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.CellNib2 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        if ([language isEqualToString:@"en"])
        {
            cell.titleLabel.text = [self.selectedEventArray valueForKey:@"title_en"];
            cell.subtitleLabel.text = [self.selectedEventArray valueForKey:@"subtitle_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            cell.titleLabel.text = [self.selectedEventArray valueForKey:@"title_cn"];
            cell.subtitleLabel.text = [self.selectedEventArray valueForKey:@"subtitle_cn"];
        }
        else
        {
            cell.titleLabel.text = [self.selectedEventArray valueForKey:@"title_tw"];
            cell.subtitleLabel.text = [self.selectedEventArray valueForKey:@"subtitle_tw"];
        }
        return cell;
    }
    else
    {
        static NSString* CellIdentifier = @"singleEventDescriptionCell";
        singleEventDescriptionCell* cell;
        cell = (singleEventDescriptionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            if (!self.CellNib3)
            {
                self.CellNib3 = [UINib nibWithNibName:@"singleEventDescriptionCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.CellNib3 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        
        if (indexPath.row == 2)
        {
            cell.titleLabel.text = NSLocalizedString(@"活動內容", nil);
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"content_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"content_cn"];
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"content_tw"];
            }
            
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            outerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:1.0];
            [outerRingView addSubview:innerRingView];
            
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"content_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:1.0];
            [cell addSubview:gradientLineBottom];
            
        }
        else if (indexPath.row == 3)
        {
            
            cell.titleLabel.text = NSLocalizedString(@"活動地址", nil);
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"location_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"location_cn"];
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"location_tw"];
            }
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
            [outerRingView addSubview:innerRingView];
            
            UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
            gradientLineTop.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
            [cell addSubview:gradientLineTop];
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"location_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            [cell addSubview:gradientLineBottom];
        }
        else if (indexPath.row == 4)
        {
            cell.titleLabel.text = NSLocalizedString(@"活動電話", nil);
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"phone_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"phone_cn"];
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"phone_tw"];
            }
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.backgroundColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
            [outerRingView addSubview:innerRingView];
            
            
            UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
            gradientLineTop.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            [cell addSubview:gradientLineTop];
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"phone_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            [cell addSubview:gradientLineBottom];
        }
        else if (indexPath.row == 5)
        {
            cell.titleLabel.text = NSLocalizedString(@"活動時間", nil);
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"time_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"time_cn"];
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"time_tw"];
            }
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.backgroundColor = [UIColor colorWithRed:27/255.0 green:134/255.0 blue:189/255.0 alpha:0.7];
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
            [outerRingView addSubview:innerRingView];
            
            
            UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
            gradientLineTop.backgroundColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            [cell addSubview:gradientLineTop];
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"time_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
            [cell addSubview:gradientLineBottom];
        }
        else
        {
            cell.titleLabel.text = NSLocalizedString(@"注意事項", nil);
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"note_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"note_cn"];
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"note_tw"];
            }
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            NSLog(@"noteeeee:%@",[self.selectedEventArray valueForKey:@"note_tw"]);
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:1.0];
            [outerRingView addSubview:innerRingView];
            
            
            UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
            gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
            [cell addSubview:gradientLineTop];
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
            [cell addSubview:gradientLineBottom];
            
            UIView *bottomDot = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame), 7, 7)];
            bottomDot.layer.cornerRadius = bottomDot.bounds.size.width/2;
            bottomDot.layer.masksToBounds = YES;
            [bottomDot setCenter:CGPointMake(CGRectGetMidX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame))];
            bottomDot.backgroundColor =[UIColor colorWithHexString:@"0a9d98" alpha:0.7];
            [cell addSubview:bottomDot];
        }
        return cell;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    
    [self.tableView beginUpdates]; // This will cause an animated update of
    [self.tableView endUpdates];   // the height of your UITableViewCell
    
    // If the UITextView is not automatically resized (e.g. through autolayout
    // constraints), resize it here
    
    //[self scrollToCursorForTextView:textView]; // OPTIONAL: Follow cursor
}

- (IBAction)callAction:(id)sender {
    NSString *phNo = [self.selectedEventArray valueForKey:@"phone_tw"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}
- (IBAction)addressAction:(id)sender {
    [self performSegueWithIdentifier:@"showEventToSingleMap" sender:self];
}
- (IBAction)shareAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"])
    {
        self.fbShareButton.enabled =YES;
        self.wbShareButton.enabled = YES;
        [self popShareView];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
        
    {
        self.wbShareButton.enabled = YES;
        self.fbShareButton.enabled =YES;
        [self popShareView];
    }
    else
    {
        /*SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
         [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
         [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
         [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];*/
        self.wbShareButton.enabled = YES;
        self.fbShareButton.enabled =YES;
        [self popShareView];
    }
}
- (IBAction)fbShareAction:(id)sender {
    /*FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
     photo.imageURL = [self.selectedEventArray valueForKey:@"title_tw"];
     photo.userGenerated = YES;
     FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
     content.photos = @[photo];
     
     FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
     dialog.fromViewController = self;
     //dialog.content = content;
     dialog.mode = FBSDKShareDialogModeShareSheet;
     [dialog show];*/
    
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentTitle = [self.selectedEventArray valueForKey:@"title_tw"];
    content.contentDescription = [self.selectedEventArray valueForKey:@"title_tw"];
    //content.imageURL = [NSURL URLWithString:[self.selectedEventArray valueForKey:@"pic_url"]];
    content.contentURL = [NSURL URLWithString:[self.selectedEventArray valueForKey:@"pic_url"]];

    NSLog(@"fb sharecontent.contentTitle:%@",content.contentTitle);
    NSLog(@"fb imageURL:%@",content.imageURL);
    FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
    [shareDialog setDelegate:self];
    [shareDialog setMode:FBSDKShareDialogModeNative];
    //[shareDialog setMode:FBSDKShareDialogModeFeedWeb];
    [shareDialog setShareContent:content];
    [shareDialog setFromViewController:self];
    [shareDialog show];
    
}

- (IBAction)resultDoneAction:(id)sender {
    self.shareResultPopUpView.hidden = YES;
    maskView.hidden = YES;
    
}
- (void)sharer:	(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"share result:%@",results);
    /*if ([results count]>0)
    {
        self.sharePopUpView.hidden = YES;
        [[VintageApiService sharedInstance]updatePointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] activity_id:[self.selectedEventArray valueForKey:@"id"]];
    }
    */
    self.sharePopUpView.hidden = YES;
    [[VintageApiService sharedInstance]updatePointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] activity_id:[self.selectedEventArray valueForKey:@"id"]];
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"FB: ERROR=%@\n",error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
}
- (IBAction)wbShareAction:(id)sender {
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/2/comments/create.json";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFectchWeiboInfoNotification:) name:FetchingWeiboInfoNotification object:nil];
    
}

- (void)onFectchWeiboInfoNotification:(NSNotification*)notify
{
    NSLog(@"onFectchWeiboShareNotification:%@",notify.object);
    self.sharePopUpView.hidden = YES;
    [[VintageApiService sharedInstance]updatePointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] activity_id:[self.selectedEventArray valueForKey:@"id"]];
    
}
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = [self.selectedEventArray valueForKey:@"title_tw"];
    WBImageObject *image = [WBImageObject object];
    NSURL *url = [NSURL URLWithString:[self.selectedEventArray valueForKey:@"pic_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage* img = [UIImage imageWithData:imageData];
    
    CGFloat compression = 0.9f;
    NSData *compressedImage = UIImageJPEGRepresentation(img, compression);
    int maxFileSize = 32*1024;
    NSLog(@"[compressedImage length]:%lu",(unsigned long)[compressedImage length]);
    
    while ([compressedImage length] > maxFileSize)
    {
        compression -= 0.1;
        compressedImage = UIImageJPEGRepresentation(img, compression);
        
    }
    
    image.imageData = [NSData dataWithData:compressedImage];
    message.imageObject = image;
    return message;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEventToSingleMap"]) {
        SingleMapViewController* vc = [segue destinationViewController];
        vc.selectedItemArray = self.selectedEventArray;
    }
    
}

@end
