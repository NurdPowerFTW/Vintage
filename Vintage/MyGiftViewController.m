//
//  MyGiftViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "MyGiftViewController.h"
#import "Vintage-Swift.h"
#import "itemTableViewCell.h"
#import "singleEventTitleCellTableViewCell.h"
#import "NewItemTableViewCell.h"
#import "VintageApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"
#import "Vintage-Swift.h"
#import "ShopTableViewCell.h"
#import "singleShopViewController.h"
#import "singleGiftViewController.h"
#import "singlePresentViewController.h"
@implementation MyGiftViewController
{
    NSMutableArray* giftInfoArray;
    NSMutableArray* giftHistoryInfoArray;
    NSMutableArray* title_tw_array;
    NSMutableArray* subtitle_tw_array;
    UIView *imageContainer;
    BOOL will_obtain;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"8"];
    self.obtainButton.selected = YES;
    self.historyButton.selected = NO;
    will_obtain = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    giftInfoArray = [[NSMutableArray alloc]init];
    giftHistoryInfoArray = [[NSMutableArray alloc]init];
    title_tw_array = [[NSMutableArray alloc]init];
    subtitle_tw_array = [[NSMutableArray alloc]init];
    [self.obtainButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingGiftListNotification:) name:FetchingGiftListNotification object:nil];
    [[VintageApiService sharedInstance]fetchGiftListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"]];
    
    NSLog(@"viewWillAppear");
}
-(void)onFetchingGiftListNotification:(NSNotification*)notify
{
    giftInfoArray = [notify.object objectForKey:@"my_gifts_not_used"];
    giftHistoryInfoArray = [notify.object objectForKey:@"my_gifts_used"];
    title_tw_array = [giftInfoArray valueForKey:@"title_tw"];
    subtitle_tw_array = [giftInfoArray valueForKey:@"subtitle_tw"];
    
    [self.tableView reloadData];
}
- (IBAction)showSideBar:(id)sender {
    [self.navigationController showSideMenuView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (will_obtain == YES)
    {
        return giftInfoArray.count;
    }
    else
    {
        return giftHistoryInfoArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.view.frame.size.height * 0.185;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    float superViewWidth = self.view.frame.size.width;
    float superViewHeight = self.view.frame.size.height;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.07)];
    imageContainer = [[UIView alloc]initWithFrame:CGRectMake(headerView.frame.size.width * 0.034375,headerView.frame.size.height * 0.2, headerView.frame.size.height * 0.6, headerView.frame.size.height * 0.6)];
    
    ShopTableViewCell* cell;
    static NSString *cellIdentifier = @"ShopTableViewCell";
    cell = (ShopTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        if (!self.cellNib2)
        {
            self.cellNib2 = [UINib nibWithNibName:@"ShopTableViewCell" bundle:nil];
            
        }
        NSArray* bundleObjects = [self.cellNib2 instantiateWithOwner:self options:nil];
        cell = [bundleObjects objectAtIndex:0];
    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.078125, CGRectGetMidY(cell.photoView.frame)-superViewHeight*0.02113, 150, superViewHeight*0.02113)];
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.078125, CGRectGetMaxY(title.frame)+8, 150,superViewHeight*0.02113)];
    
    if (will_obtain == YES)
    {
        if ([language isEqualToString:@"en"])
        {
            title.text = [[giftInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_en"];
            subTitle.text = [NSString stringWithFormat:@"Activity Time %@",[[giftInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            title.text = [[giftInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_cn"];
            subTitle.text = [NSString stringWithFormat:@"活动日期%@",[[giftInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_cn"]];
        }
        else
        {
            title.text = [[giftInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_tw"];
            subTitle.text = [NSString stringWithFormat:@"活動日期%@",[[giftInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_tw"]];
        }
        
        
        title.font = [UIFont boldSystemFontOfSize:superViewHeight*0.02113];
        title.textColor = [UIColor darkTextColor];
        [cell addSubview:title];
        
        
        
        subTitle.font = [UIFont boldSystemFontOfSize:superViewHeight*0.02113];
        subTitle.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        [cell addSubview:subTitle];
        
        
        [cell.photoImageVIew sd_setImageWithURL:[[giftInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"] placeholderImage:[UIImage  imageNamed:@"img_windglass.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.photoImageVIew.image = image;
        }];
        return cell;
    }
    else
    {
        if ([language isEqualToString:@"en"])
        {
            title.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_en"];
            subTitle.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            title.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_cn"];
            subTitle.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_cn"];
        }
        else
        {
            title.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_tw"];
            subTitle.text = [[giftHistoryInfoArray objectAtIndex:indexPath.row]valueForKey:@"time_tw"];
        }
        
        
        title.font = [UIFont boldSystemFontOfSize:superViewHeight*0.02113];
        title.textColor = [UIColor darkTextColor];
        [cell addSubview:title];
        
        
        
        subTitle.font = [UIFont boldSystemFontOfSize:superViewHeight*0.02113];
        subTitle.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        [cell addSubview:subTitle];
        
        
        [cell.photoImageVIew sd_setImageWithURL:[[giftHistoryInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"] placeholderImage:[UIImage  imageNamed:@"img_windglass.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.photoImageVIew.image = image;
        }];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedBannerIndex = indexPath.row;
    
    if ([[[giftInfoArray objectAtIndex:indexPath.row]valueForKey:@"exchange_way"]isEqualToString:@"OFFLINE"])
    {
        [self performSegueWithIdentifier:@"showSingleGift" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"showSinglePresent" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSingleGift"])
    {
        singleGiftViewController* vc = [segue destinationViewController];
        if (will_obtain == NO)
        {
            vc.can_redeem = NO;
            vc.selectedEventArray = [giftHistoryInfoArray objectAtIndex:self.selectedBannerIndex];

        }
        else
        {
            vc.can_redeem = YES;
            vc.selectedEventArray = [giftInfoArray objectAtIndex:self.selectedBannerIndex];

        }
    }
    else if ([segue.identifier isEqualToString:@"showSinglePresent"])
    {
        singlePresentViewController* vc = [segue destinationViewController];
        if (will_obtain == NO) {
            vc.can_redeem = NO;
            vc.selectedEventArray = [giftHistoryInfoArray objectAtIndex:self.selectedBannerIndex];

        }
        else
        {
            vc.can_redeem = YES;
            vc.selectedEventArray = [giftInfoArray objectAtIndex:self.selectedBannerIndex];

        }
    }
}
- (IBAction)obtainButtonPressed:(id)sender {
    if (self.obtainButton.selected == NO)
    {
        will_obtain = YES;
        self.obtainButton.selected = YES;
        self.historyButton.selected = NO;
        [self.obtainButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
        [self.historyButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"F4F4F4"]] forState:UIControlStateSelected];
    }
    [self.tableView reloadData];
}
- (IBAction)historyButtonPressed:(id)sender {
    if (self.historyButton.selected == NO)
    {
        will_obtain = NO;
        self.obtainButton.selected = NO;
        self.historyButton.selected = YES;
        [self.historyButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
        [self.obtainButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"F4F4F4"]] forState:UIControlStateSelected];
    }
    [self.tableView reloadData];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
