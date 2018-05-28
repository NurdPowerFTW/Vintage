//
//  singleGiftViewController.m
//  Vintage
//
//  Created by Will Tang on 6/16/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "singleGiftViewController.h"
#import "singleEventTitleCellTableViewCell.h"
#import "singleEventDescriptionCell.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "VintageApiService.h"
#import "EventTableCell.h"
#import "HexColors.h"
#import "SCLAlertView.h"

@interface singleGiftViewController ()

@end

@implementation singleGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self.view bringSubviewToFront:self.bottomBarView];
    if (self.can_redeem == NO) {
        self.retailRedeemButton.enabled = NO;
    }
    self.popUpView.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRetailRedeemNotification:) name:RetailRedeemNotification object:nil];
    
    UITapGestureRecognizer* cancelPopUpViewRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPopUpView:)];
    [self.view addGestureRecognizer:cancelPopUpViewRecog];
    [self.popUpView removeGestureRecognizer:cancelPopUpViewRecog];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancelPopUpView:(UITapGestureRecognizer *)recog
{
    if (maskView.hidden == NO) {
        self.popUpView.hidden = YES;
        maskView.hidden = YES;
        [self.view endEditing:YES];
    }
}
- (void)onRetailRedeemNotification:(NSNotification*)notify
{
    
    if ([[notify.object objectForKey:@"ERR_CODE"] integerValue] == 36)
    {
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showSuccess:NSLocalizedString(@"店家兌換獎品成功", nil)  subTitle:NSLocalizedString(@"直接跟店家領取", nil) closeButtonTitle:nil duration:3.0f];
        self.bottomBarView.hidden = YES;
    }
    else if ([[notify.object objectForKey:@"ERR_CODE"] integerValue] == 38)
    {
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:NSLocalizedString(@"兌換獎品失敗", nil)  subTitle:NSLocalizedString(@"之前已經兌換過", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        [self.view endEditing:YES];
    }
    else if ([[notify.object objectForKey:@"ERR_CODE"] integerValue] == 39)
    {
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:NSLocalizedString(@"店家兌換獎品失敗", nil)  subTitle:NSLocalizedString(@"密碼錯誤", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        [self.view endEditing:YES];
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
    self.popUpTextView.layer.cornerRadius = 10;
    self.popUpTextView.layer.masksToBounds = YES;
    self.obtainButton.layer.cornerRadius = 14;
    self.obtainButton.layer.masksToBounds = YES;
    self.obtainButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"])
    {
        self.retailAddress.text = [NSString stringWithFormat:NSLocalizedString(@"地址：%@", nil) ,[self.selectedEventArray valueForKey:@"location_en"]];
        self.retailNumber.text = [NSString stringWithFormat:NSLocalizedString(@"電話：%@", nil) ,[self.selectedEventArray valueForKey:@"phone_en"]];
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        self.retailAddress.text = [NSString stringWithFormat:NSLocalizedString(@"地址：%@", nil) ,[self.selectedEventArray valueForKey:@"location_cn"]];
        self.retailNumber.text = [NSString stringWithFormat:NSLocalizedString(@"電話：%@", nil) ,[self.selectedEventArray valueForKey:@"phone_cn"]];
    }
    else
    {
        self.retailAddress.text = [NSString stringWithFormat:NSLocalizedString(@"地址：%@", nil) ,[self.selectedEventArray valueForKey:@"location_tw"]];
        self.retailNumber.text = [NSString stringWithFormat:NSLocalizedString(@"電話：%@", nil) ,[self.selectedEventArray valueForKey:@"phone_tw"]];
    }
    
}
- (IBAction)obtainPressed:(id)sender {
    
    self.popUpView.hidden = YES;
    maskView.hidden = YES;
    if (self.popUpTextView.text.length > 0)
    {
        [[VintageApiService sharedInstance]retailRedeem:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] my_gift_id:[self.selectedEventArray valueForKey:@"my_gift_id"] pwd:self.popUpTextView.text];
    }
    
    [self.view endEditing:YES];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [textView sizeToFit];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width * 0.73125, FLT_MAX)];
    float totalHeight = size.height+ self.view.frame.size.height * 0.0775;
    NSLog(@"size.height:%f",totalHeight);
    return size.height+ self.view.frame.size.height * 0.088;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // check here, if it is one of the cells, that needs to be resized
    // to the size of the contained UITextView
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (indexPath.row == 0)
    {
        return self.view.frame.size.height * 0.466549;
    }
    else if (indexPath.row == 1)
    {
        return self.view.frame.size.height * 0.153169;
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
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_en"]] + self.view.frame.size.height *0.05;
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_cn"]] + self.view.frame.size.height *0.05;
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"note_tw"]] + self.view.frame.size.height *0.05;
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
        cell.bannerImage.clipsToBounds = YES;
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
            cell.subtitleLabel.text = [NSString stringWithFormat:@"Activity Time %@",[self.selectedEventArray valueForKey:@"time_en"]];

        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            cell.titleLabel.text = [self.selectedEventArray valueForKey:@"title_cn"];
            cell.subtitleLabel.text = [NSString stringWithFormat:@"活动日期%@",[self.selectedEventArray valueForKey:@"time_cn"]];;
        }
        else
        {
            cell.titleLabel.text = [self.selectedEventArray valueForKey:@"title_tw"];
            cell.subtitleLabel.text = [NSString stringWithFormat:@"活動日期%@",[self.selectedEventArray valueForKey:@"time_tw"]];
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
            //cell.subTitle.backgroundColor = [UIColor redColor];
            cell.subTitle.scrollEnabled =NO;
            cell.subTitle.editable = NO;
            [cell.subTitle sizeToFit];
            //cell.backgroundColor = [UIColor blueColor];
            UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.044, CGRectGetMinY(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame), CGRectGetHeight(cell.titleLabel.frame))];
            
            outerRingView.backgroundColor = [UIColor purpleColor];
            outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
            outerRingView.layer.masksToBounds = YES;
            outerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
            [cell addSubview:outerRingView];
            
            UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
            innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
            innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
            innerRingView.layer.masksToBounds = YES;
            innerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
            [outerRingView addSubview:innerRingView];
            
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"content_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
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
- (IBAction)obtainAction:(id)sender {
    [self showPopUpView];
}
- (void) keyboardWillShow:(NSNotification*) note
{
    NSLog(@"keyboardWillShow");
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSValue* keyboardFrameBegin = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"screenHeight:%f keyboardWillShow:%f self.controlView.frame.size.height:%f newHeight:%f",screenHeight, keyboardHeight, self.view.frame.size.height, screenHeight - keyboardHeight - self.view.frame.size.height);
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                      screenHeight - kbSize.height - self.view.frame.size.height,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
                     } completion:^(BOOL finished){
                     }];
    
}

- (void) keyboardWillHide:(NSNotification*) note
{
    NSLog(@"keyboardWillHide");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    
    NSLog(@"screenHeight:%f newHeight:%f", screenHeight, screenHeight-self.view.frame.size.height);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                      screenHeight-self.view.frame.size.height,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
- (BOOL)textFieldShouldReturn:(id)sender {
    
    [sender resignFirstResponder];
    
    return NO;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
@end
