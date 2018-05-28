//
//  ContentViewController.m
//  Vintage
//
//  Created by William on 4/20/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "ContentViewController.h"
#import "SearchTableButtonCell.h"
#import <GVPhotoBrowser.h>
#import "VintageApiService.h"
#import "SingleEventViewController.h"
#import "WineOverViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HexColors.h"

@interface ContentViewController ()
{
    NSMutableArray* functionTabArray;
    NSMutableArray* descriptionArray;
    NSMutableArray* circleButtonArray;
    NSMutableArray* circleImageArray;
    InfiniteSlideShow *slideShowWithCustomControl;
    CustomPageControl *pageControl;
}

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"0"];
    // Do any additional setup after loading the view.
    functionTabArray = [[NSMutableArray alloc]initWithObjects:@"",@"新品上市",@"行家推薦",@"熱門排行",@"當季精選",@"送禮推薦", @"好酒總覽",@"",nil];
    descriptionArray = [[NSMutableArray alloc]initWithObjects:@"",@"火熱新鮮上架",@"口碑珍藏好酒",@"暢銷熱賣酒款",@"季節限定推薦",@"佳節精選禮盒",@"泰豐嚴選美酒",@"", nil];
    circleButtonArray = [[NSMutableArray alloc]initWithObjects:@"",@"btn_new_normal",@"btn_expert_normal",@"btn_hot_normal",@"btn_season_normal",@"btn_present_normal",@"btn_all_normal",@"",nil];
    circleImageArray = [[NSMutableArray alloc]initWithObjects:@"",@"img_new",@"img_expert",@"img_hot",@"img_season",@"img_present",@"img_all",@"",nil];
    self.navigationController.navigationBarHidden = YES;
    //UITapGestureRecognizer *shrinkSideMenu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSideMenuVIew:)];
    //[self.view addGestureRecognizer:shrinkSideMenu];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"filterCountries"])
    {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"wines" ofType:@"plist"];
        NSDictionary *winesDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        [defaults setValue:[winesDictionary objectForKey:@"filterCountries"] forKey:@"filterCountries"];
        [defaults setValue:[winesDictionary objectForKey:@"filterWineTypes"] forKey:@"filterWineTypes"];
    }
    
    self.photoArray = [[NSMutableArray alloc]init];
    self.bannerItemArray = [[NSMutableArray alloc]init];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"0"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingHomeBannerNotification:) name:FetchingHomeBannerNotification object:nil];
    [self executeFetchBanner];
    
    
}
- (void)executeFetchBanner
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"access_token"];
        if(![[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"deviceToken"];
        }
        //沒登入的狀態下，還是要能收推撥，所以我把你這行 Mark 起來
        //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if ([language isEqualToString:@"en"]) {
        [[VintageApiService sharedInstance]fetchHomeBanner:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] device_token:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] device_type:@"ios" device_language:@"en"];
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        [[VintageApiService sharedInstance]fetchHomeBanner:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] device_token:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] device_type:@"ios" device_language:@"cn"];
    }
    else
    {
        [[VintageApiService sharedInstance]fetchHomeBanner:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] device_token:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] device_type:@"ios" device_language:@"tw"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FetchingHomeBannerNotification object:nil];
}

- (void)hideSideMenuView:(UITapGestureRecognizer*)recog
{
    [self.navigationController hideSideMenuView];
}
- (void)onFetchingHomeBannerNotification:(NSNotification*)notify
{
    
    if ([[AFNetworkReachabilityManager sharedManager]isReachable])
    {
        NSArray *filterWineTypesArray = [notify.object objectForKey:@"wine_types"];
        NSArray *filterCountriesArray = [notify.object objectForKey:@"countries"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (filterWineTypesArray && [filterWineTypesArray count])
        {
            [defaults setValue:filterWineTypesArray forKey:@"filterWineTypes"];
        }
        if (filterCountriesArray && [filterCountriesArray count])
        {
            [defaults setValue:filterCountriesArray forKey:@"filterCountries"];
        }

        [defaults synchronize];

        self.bannerItemArray = [notify.object objectForKey:@"banners"];
        for (NSString* bannerURL in [[notify.object objectForKey:@"banners"] valueForKey:@"pic_url"]) {
            [self.photoArray addObject:bannerURL];
        }
        NSLog(@"self.photoArray:%@",self.photoArray);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Email"]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[notify.object objectForKey:@"point_sum"] forKey:@"point_sum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
        }
        slideShowWithCustomControl = [[InfiniteSlideShow alloc] initWithFrame:CGRectMake(0, 0 , self.slidingImageView.frame.size.width, self.slidingImageView.frame.size.height)];
        slideShowWithCustomControl.dataSource = self;
        slideShowWithCustomControl.delegate = self;
        pageControl = [[CustomPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        [pageControl setNumberOfPages:self.photoArray.count];
        [pageControl setCurrentPage:0];
        [pageControl setOnImage:[UIImage imageNamed:@"dot_on"]];
        [pageControl setOnImage:[UIImage imageNamed:@"dot_off"]];
        [pageControl setIndicatorDiameter:10.0f];
        [pageControl setIndicatorSpace:7.0f];
        [slideShowWithCustomControl setUpViewWithTimerDuration:[NSNumber numberWithFloat:5.0] animationDuration:[NSNumber numberWithFloat:1.0] customPageControl:pageControl];
        //self.slidingImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.slidingImageView.clipsToBounds = YES;
        [self.slidingImageView addSubview:slideShowWithCustomControl];
        [self.slidingImageView bringSubviewToFront:self.functionButtonView];
    }
    else
    {
        NSError *error = notify.object;
        NSInteger statusCode = error.code;
        if(statusCode == -1001) {
            // request timed out
            
        } else if (statusCode == -1009 || statusCode == -1004)
        {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
            [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
            [alert addButton:NSLocalizedString(@"重新連線", nil) target:self selector:@selector(executeFetchBanner)];
            [alert showCustom:[UIImage imageNamed:@"img_disconnect"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"無法連線", nil) subTitle:NSLocalizedString(@"請檢查您的網路狀態",nil) closeButtonTitle:nil duration:0.0f];
        }
    }
    
}

#pragma Infinite Slide Show Delegate methods
- (void)didClickSlideShowItem:(id)sender
{
    NSLog(@"%@",[self.bannerItemArray objectAtIndex:[pageControl currentPage]]);
    self.selectedBannerIndex = [pageControl currentPage];
    [self performSegueWithIdentifier:@"homeToSingleEvent" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToSingleEvent"]) {
        
        SingleEventViewController* vc = [segue destinationViewController];
        //vc.selectedBannerIndex = self.selectedBannerIndex;
        vc.selectedEventArray = [self.bannerItemArray objectAtIndex:self.selectedBannerIndex];
        NSLog(@"vc.selectedEventArray:%@",[self.bannerItemArray objectAtIndex:self.selectedBannerIndex]);
    }
    if ([segue.identifier isEqualToString:@"showAllItem"]) {
        WineOverViewController* vc = [segue destinationViewController];
        switch (self.selectedPageIndex) {
            case 1:
                vc.pageName = NSLocalizedString(@"新品上市", nil);
                vc.pageIndex = @"0";
                break;
            case 2:
                vc.pageName = NSLocalizedString(@"行家推薦", nil);
                vc.pageIndex = @"1";
                break;
            case 3:
                vc.pageName = NSLocalizedString(@"熱門排行", nil);
                vc.pageIndex = @"2";
                break;
            case 4:
                vc.pageName = NSLocalizedString(@"當季精選", nil);
                vc.pageIndex = @"3";
                break;
            case 5:
                vc.pageName = NSLocalizedString(@"好禮推薦", nil);
                vc.pageIndex = @"4";
                break;
            case 6:
                vc.pageName = NSLocalizedString(@"好酒總覽", nil);
                vc.pageIndex = @"5";
                break;
            default:
                break;
        }
    }
    if ([segue.identifier isEqualToString:@"homeToSearch"]) {
        
        SearchViewController* vc = [segue destinationViewController];
        vc.pageIndex = self.searchPageIndex;
    }
}
#pragma mark InfiniteSlideshow Datasource
- (NSArray *)loadSlideShowItems
{
    NSLog(@"Loading slide show items.");
    return [self.photoArray copy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return functionTabArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.view.frame.size.height * 0.067;
    }
    else if (indexPath.row >0 && indexPath.row < 7)
    {
        return self.view.frame.size.height * 0.21;
    }
    else
    {
        return self.view.frame.size.height *0.204;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0)
    {
        static NSString *cellID = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        UIView *gradientLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.75, -20, 1, cell.bounds.size.height+20)];
        gradientLine.backgroundColor = [UIColor colorWithRed:(235/255.0) green:(222/255.0) blue:(222/255.0) alpha:1.0];
        [cell addSubview:gradientLine];
        return cell;
    }
    else if (indexPath.row >0 && indexPath.row < 7)
    {
        static NSString *cellIdentifier = @"mainTableViewCell";
        mainTableViewCell* cell;
        cell = (mainTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib2)
            {
                self.cellNib2 = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib2 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        cell.categoryTextField.text = NSLocalizedString([functionTabArray objectAtIndex:indexPath.row], nil);
        cell.describeTextField.text = NSLocalizedString([descriptionArray objectAtIndex:indexPath.row], nil);
        
        UIView *imageWrapper = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.55, 0, self.view.frame.size.width * 0.28, self.view.frame.size.width * 0.28)];
        [imageWrapper setCenter:CGPointMake(self.view.frame.size.width*3/4, CGRectGetHeight(cell.frame)/2)];
        //imageWrapper.backgroundColor = [UIColor blueColor];
        
        UIImageView *circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWrapper.frame.size.width, imageWrapper.frame.size.height)];
        circleImg.image = [UIImage imageNamed:[circleButtonArray objectAtIndex:indexPath.row]];
        
        UIImageView *circleButtonImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height * 0.056, self.view.frame.size.height * 0.056)];
        [circleButtonImg setCenter:CGPointMake(circleImg.frame.size.width/2, circleImg.frame.size.height/2)];
        circleButtonImg.image = [UIImage imageNamed:[circleImageArray objectAtIndex:indexPath.row]];
        [circleImg addSubview:circleButtonImg];
        [imageWrapper addSubview:circleImg];
        [cell addSubview:imageWrapper];
        
        UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(imageWrapper.center.x, 0, 1,CGRectGetMinY(imageWrapper.frame))];
        UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(imageWrapper.center.x, CGRectGetMaxY(imageWrapper.frame), 1,self.view.frame.size.height * 0.21-CGRectGetMaxY(imageWrapper.frame))];
        
        //NSLog(@"CGRectGetMaxY:%f",cell.circleView.frame.origin.y + cell.circleView.frame.size.height);
        
        switch (indexPath.row)
        {
            case 1:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(235/255.0) green:(222/255.0) blue:(222/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor =  [UIColor colorWithRed:(235/255.0) green:(222/255.0) blue:(222/255.0) alpha:1.0];
                
                break;
            case 2:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(235/255.0) green:(222/255.0) blue:(222/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor =  [UIColor colorWithRed:(167/255.0) green:(22/255.0) blue:(69/255.0) alpha:1.0];
                break;
            case 3:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(167/255.0) green:(22/255.0) blue:(69/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor = [UIColor colorWithRed:(89/255.0) green:(27/255.0) blue:(72/255.0) alpha:1.0];
                break;
            case 4:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(89/255.0) green:(27/255.0) blue:(72/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor = [UIColor colorWithRed:(75/255.0) green:(4/255.0) blue:(105/255.0) alpha:1.0];
                break;
            case 5:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(75/255.0) green:(4/255.0) blue:(105/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor = [UIColor colorWithRed:(1/255.0) green:(1/255.0) blue:(96/255.0) alpha:1.0];
                break;
            case 6:
                gradientLineTop.backgroundColor = [UIColor colorWithRed:(1/255.0) green:(1/255.0) blue:(96/255.0) alpha:1.0];
                gradientLineBottom.backgroundColor = [UIColor colorWithRed:(1/255.0) green:(1/255.0) blue:(96/255.0) alpha:1.0];
                break;
                
            default:
                break;
        }
        [cell addSubview:gradientLineTop];
        [cell addSubview:gradientLineBottom];
        return cell;
        
    }
    else
    {
        static NSString *cellIdentifier = @"mainTableViewCell";
        mainTableViewCell* cell;
        cell = (mainTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib2)
            {
                self.cellNib2 = [UINib nibWithNibName:@"mainTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib2 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        cell.categoryTextField.hidden = YES;
        cell.describeTextField.hidden = YES;
        UIImageView *imageWrapper = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.094, self.view.frame.size.height *0.05, self.view.frame.size.width * 0.37, self.view.frame.size.height * 0.076)];
        imageWrapper.image = [UIImage imageNamed:@"img_tfhowlogo"];
        [cell addSubview:imageWrapper];
        UIView *gradientLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.75, 0, 1, cell.bounds.size.height)];
        gradientLine.backgroundColor = [UIColor colorWithRed:(1/255.0) green:(1/255.0) blue:(96/255.0) alpha:1.0];
        
        [cell addSubview:gradientLine];
        return cell;
        
    }
    
}

- (void)textFieldDidChange:(UITextField*)textField
{
    NSLog(@"test");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < 7 && indexPath.row > 0)
    {
        self.selectedPageIndex = indexPath.row;
        NSLog(@"selectedPageIndex:%ld",(long)self.selectedPageIndex);
        [self performSegueWithIdentifier:@"showAllItem" sender:self];
        
    }
    
    
}

- (IBAction)searchAction:(id)sender {
    self.searchPageIndex = @"0";
    [self performSegueWithIdentifier:@"homeToSearch" sender:self];
}
- (IBAction)toggleSideMenuVIew:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"]) {
        NSLog(@"toggle menu with user id %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
    }
    [self.navigationController showSideMenuView];
}

- (NSInteger)indexFromPixels:(NSInteger)pixels
{
    if (pixels == 60)
        return 0;
    else if (pixels == 120)
        return 1;
    else
        return 2;
}

- (NSInteger)pixelsFromIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            return 60;
            
        case 1:
            return 120;
            
        case 2:
            return 200;
            
        default:
            return 0;
    }
}
@end
