//
//  SideBarMenuController.m
//  Vintage
//
//  Created by William on 5/13/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SideBarMenuController.h"
#import "Vintage-Swift.h"
#import "VintageApiService.h"
#import "WaiterViewController.h"
#import "SideBarTableViewCell.h"
#import <HexColors.h>
#import "WeiboSDK.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginViewController.h"
#import "AccountViewController.h"
#import "SCLAlertView.h"

@implementation SideBarMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.tableVIew setContentInset:UIEdgeInsetsMake(9.f, 0, 0, 0)];
    self.tableItemArray = [[NSMutableArray alloc]initWithObjects:@"MENU",@"首頁",@"行動侍酒師",@"附近店家",@"最新活動",@"我的收藏",@"我的帳號",@"答題拿點數",@"拉霸A好康",@"我的好禮",nil];
    self.tableVIew.separatorColor = [UIColor clearColor];
    //self.tableVIew.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.8f];
    
    
    self.personalInfoDictionary = [[NSMutableDictionary alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingPersonalInfoNotification:) name:FetchingPersonalInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRefreshPersonalInfoNotification) name:RefreshPersonalInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onErasePersonalInfoNotification) name:ErasePersonalInfoNotification object:nil];
    
    
}
- (void)onFetchingPersonalInfoNotification:(NSNotification*)notify
{
    
    self.personalInfoDictionary = notify.object;
    NSLog(@"fetching personal info in side bar:%@",notify.object);
    [self.tableVIew reloadData];
}
- (void)onRefreshPersonalInfoNotification
{
    
    NSLog(@"refreshing personal info in side bar");
    [self.tableVIew reloadData];
}

- (void)onErasePersonalInfoNotification
{
    
    
    NSLog(@"erasing personal info in side bar");
    [self.tableVIew reloadData];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.view.frame.size.height * 0.052;
    }
    else
    {
        return self.view.frame.size.height / 10;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tableItemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SideBarTableViewCell";
    SideBarTableViewCell* cell;
    cell = (SideBarTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        if (!self.CellNib)
        {
            self.CellNib = [UINib nibWithNibName:@"SideBarTableViewCell" bundle:nil];
            
        }
        NSArray* bundleObjects = [self.CellNib instantiateWithOwner:self options:nil];
        cell = [bundleObjects objectAtIndex:0];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row == 0)
    {
        //cell.homeText.text = @"MENU";
        //cell.homeText.textColor = [UIColor whiteColor];
        UILabel *homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableVIew.frame.size.width/2-20, 5, 56, 20)];
        homeLabel.text = @"MENU";
        homeLabel.font = [UIFont systemFontOfSize:14];
        homeLabel.textColor = [UIColor whiteColor];
        
        [cell addSubview:homeLabel];
        
        cell.buttonText.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.highlightedEdge.hidden = YES;
        cell.pointView.hidden = YES;
    }
    else if(indexPath.row == 8)
    {
        cell.homeText.hidden = YES;
        cell.buttonText.text = NSLocalizedString([self.tableItemArray objectAtIndex:indexPath.row], nil);
        cell.backgroundColor = [UIColor clearColor];
        cell.highlightedEdge.hidden = YES;
        cell.pointView.layer.cornerRadius = 12;
        cell.pointView.layer.masksToBounds = YES;
        cell.pointView.backgroundColor = [UIColor colorWithHexString:@"a71645"];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
        {
            cell.pointView.hidden = NO;
            cell.pointLabel.hidden = NO;
            
            cell.pointLabel.text =[NSString stringWithFormat:@"%@ 點",[[NSUserDefaults standardUserDefaults]objectForKey:@"point_sum"]];
            
        }
        else
        {
            cell.pointView.hidden = YES;
            cell.pointLabel.hidden = YES;
            
        }
        
    }
    else
    {
        cell.homeText.hidden = YES;
        cell.buttonText.text = NSLocalizedString([self.tableItemArray objectAtIndex:indexPath.row], nil);
        cell.backgroundColor = [UIColor clearColor];
        cell.highlightedEdge.hidden = YES;
        cell.pointView.hidden = YES;
    }
    
    return cell;
    /*static NSString *cellID = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
     cell.backgroundColor = [UIColor clearColor];
     UIView *selectionView = [[UIView alloc] initWithFrame:cell.bounds];
     selectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
     [cell setSelectedBackgroundView:selectionView];
     }
     cell.textLabel.text = [self.tableItemArray objectAtIndex:indexPath.row];*/
    
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    SideBarTableViewCell *cell = (SideBarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row > 0)
    {
        cell.backgroundColor = [UIColor colorWithHexString:@"c12558" alpha:1.0];
        cell.buttonText.textColor = [UIColor whiteColor];
    }
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SideBarTableViewCell *cell = (SideBarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.highlightedEdge.hidden = YES;
    cell.buttonText.textColor = [UIColor grayColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SideBarTableViewCell *cell = (SideBarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1 )
    {
        
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        cell.highlightedEdge.hidden = NO;
        
        if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"0"])
        {
            [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"content"]];
        }
        else
        {
            [self.navigationController toggleSideMenuView];
        }
        
    }
    else if (indexPath.row == 2)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"1"])
        {
            [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"waiter"]];
        }
        else
        {
            [self.navigationController toggleSideMenuView];
        }
        
        
    }
    else if (indexPath.row == 3)
    {
        
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        cell.highlightedEdge.hidden = NO;
        if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"2"])
        {
            [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"nearbyShop"]];
        }
        else
        {
            [self.navigationController toggleSideMenuView];
        }
    }
    else if (indexPath.row == 4)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"3"])
        {
            [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"promotion"]];
        }
        else
        {
            [self.navigationController toggleSideMenuView];
        }
    }
    else if (indexPath.row == 5)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"4"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"myCollection"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
            
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
            [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        }
        
    }
    else if (indexPath.row == 6)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"5"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"myAccount"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"5"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"myAccount"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Email"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"5"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"myAccount"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else
        {
            [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Login"]];
        }
    }
    else if (indexPath.row == 7)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"6"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"quiz"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
            [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        }
        
    }
    else if (indexPath.row == 8)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"7"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"lottery"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
            [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        }
        
    }
    else if (indexPath.row == 9)
    {
        cell.highlightedEdge.hidden = NO;
        cell.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.9];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
        {
            if (![[[VintageApiService sharedInstance]lastTappedIndex]isEqualToString:@"8"])
            {
                [self.sideMenuController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"myPresent"]];
            }
            else
            {
                [self.navigationController toggleSideMenuView];
            }
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
            [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
        }
        
    }
    
}
@end
