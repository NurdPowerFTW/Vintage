//
//  SearchResultViewController.m
//  Vintage
//
//  Created by Will Tang on 7/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SearchResultViewController.h"
#import "WineOverViewController.h"
#import "itemTableViewCell.h"
#import "singleEventTitleCellTableViewCell.h"
#import "NewItemTableViewCell.h"
#import "VintageApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"
#import "SingleItemViewController.h"
#import "SVPullToRefresh.h"
@interface SearchResultViewController ()
{
    NSMutableArray* wineInfoArray;
    NSArray* refreshedArray;
    NSMutableArray* cellType;
    NSMutableArray* title_tw_array;
    NSMutableArray* title_tw_length_array;
    NSMutableArray* title_en_array;
    NSMutableArray* title_en_length_array;
    NSMutableArray* priceArray;
    NSMutableArray* manufactureArray;
    UIView *imageContainer;
    NSInteger loadingOffset;
    NSUserDefaults *defaults;
    UIView *maskView;
    BOOL is_last_item;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    wineInfoArray = [[NSMutableArray alloc]init];
    refreshedArray = [[NSArray alloc]init];
    title_tw_array = [[NSMutableArray alloc]init];
    title_en_array = [[NSMutableArray alloc]init];
    manufactureArray = [[NSMutableArray alloc]init];
    title_tw_length_array = [[NSMutableArray alloc]init];
    title_en_length_array = [[NSMutableArray alloc]init];
    priceArray = [[NSMutableArray alloc]init];
    cellType = [[NSMutableArray alloc]init];
    
    defaults = [[NSUserDefaults alloc]init];
    [defaults removeObjectForKey:@"previousSelectedWineTypes"];
    [defaults removeObjectForKey:@"previousSelectedCountries"];
    [defaults removeObjectForKey:@"previousOrderBy"];
    [defaults removeObjectForKey:@"previousOrder"];
    [defaults removeObjectForKey:@"filtWithAllOptions"];
    [defaults removeObjectForKey:@"filtOrderBy"];
    [defaults removeObjectForKey:@"filtOrder"];
    [defaults removeObjectForKey:@"filtWithWineType"];
    [defaults removeObjectForKey:@"filtWithRegion"];
    //[defaults setObject:@"off" forKey:@"filterSwitch"];
    //[defaults setObject:@"off" forKey:@"searchSwitch"];
    [defaults synchronize];
    
    NSString *initialOffset = [NSString stringWithFormat:@"%d",0];
    NSString* limit = @"30";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingWineListInfoNotification:) name:FetchingWineListNotification object:nil];
    //[self fetchOverViewList:limit offset:initialOffset search:[defaults objectForKey:@"searchString"]];
    
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [defaults setObject:@"off" forKey:@"searchSwitch"];
    [defaults setObject:@"off" forKey:@"filtSwitch"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"FetchingWineListNotification"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    NSString *initialOffset = [NSString stringWithFormat:@"%d",0];
    NSString* limit = @"30";
    
    self.tableView.userInteractionEnabled = YES;
    if ([[defaults objectForKey:@"filterSwitch"]isEqualToString:@"on"]||[[defaults objectForKey:@"searchSwitch"]isEqualToString:@"on"])
    {
        [wineInfoArray removeAllObjects];
        [self.tableView reloadData];
        //start activity loading icon
        
        
        if ([[defaults objectForKey:@"searchSwitch"]isEqualToString:@"on"])
        {
            [self fetchOverViewList:limit offset:initialOffset search:[defaults objectForKey:@"searchString"]];
        }
        else
        {
            [self fetchOverViewList:limit offset:initialOffset search:@""];
        }
        
    }
    
}

- (void)insertRowAtBottom {
    __weak SearchResultViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        NSMutableArray* insertIndexPaths = [[NSMutableArray alloc] init];
        NSInteger lastIndex = wineInfoArray.count;
        for (int i = 0; i < [refreshedArray count]; i++)
        {
            
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:wineInfoArray.count + i inSection:0]];
        }
        [wineInfoArray addObjectsFromArray:refreshedArray];
        NSLog(@"wineInfoArray.count:%lu",(unsigned long)wineInfoArray.count);
        [self loadDataFromVintageApi:lastIndex];
        
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
    });
}
- (void)onFetchingWineListInfoNotification:(NSNotification*)notify
{
    NSArray *item = [notify.object objectForKey:@"wines"];
    
    // setup infinite scrolling
    if ([[defaults objectForKey:@"filterSwitch"]isEqualToString:@"on"]||[[defaults objectForKey:@"searchSwitch"]isEqualToString:@"on"])
    {
        if ([[defaults objectForKey:@"filtFirstTime"]isEqualToString:@"on"]||[[defaults objectForKey:@"searchFirstTime"]isEqualToString:@"on"])
        {
            wineInfoArray = [[NSMutableArray alloc]initWithArray:item];
            [self loadDataFromVintageApi:0];
            NSLog(@"filtered data loaded");
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if (item.count!=0)
            {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            
            
        }
        else
        {
            if (item.count == 0)
            {
                [defaults setObject:@"off" forKey:@"filterSwitch"];
                [defaults synchronize];
                NSLog(@"No more data with filter on");
                
            }
            refreshedArray = [[NSMutableArray alloc]initWithArray:item];
            NSLog(@"insert more data with filter on");
            [self insertRowAtBottom];
        }
        
        
    }
    else
    {
        
        if (item.count != 0)
        {
            refreshedArray = [[NSMutableArray alloc]initWithArray:item];
            NSLog(@"insert more data with filter off");
            [self insertRowAtBottom];
        }
        else
        {
            NSLog(@"end!!!!");
        }
        
        /*
         if (wineInfoArray.count == 0)
         {
         wineInfoArray = [[NSMutableArray alloc]initWithArray:item];
         [self loadDataFromVintageApi:0];
         NSLog(@"initial data loaded");
         [self.tableView reloadData];
         //[self.tableView.infiniteScrollingView stopAnimating];
         }
         else
         {
         if (item.count == 0)
         {
         NSLog(@"No more data with filter off");
         }
         
         refreshedArray = [[NSMutableArray alloc]initWithArray:item];
         NSLog(@"insert more data with filter off");
         [self insertRowAtBottom];
         
         
         }
         */
    }
    
    
    
    
    
    
}
- (void)loadDataFromVintageApi:(NSInteger)index
{
    
    if (index == 0 )
    {
        
        [title_en_length_array removeAllObjects];
        [title_tw_length_array removeAllObjects];
        [manufactureArray removeAllObjects];
        [priceArray removeAllObjects];
        NSLog(@"array object removed");
    }
    cellType = [wineInfoArray valueForKey:@"id"];
    title_tw_array = [wineInfoArray valueForKey:@"title_tw"];
    title_en_array = [wineInfoArray valueForKey:@"title_en"];
    
    for (NSInteger i = index; i < title_tw_array.count; i++)
    {
        
        [title_tw_length_array addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[title_tw_array objectAtIndex:i]]]];
        
        [title_en_length_array addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[title_en_array objectAtIndex:i]]]];
        
        
        if ([[wineInfoArray objectAtIndex:i] valueForKey:@"country_name_tw"] && [[wineInfoArray objectAtIndex:i] valueForKey:@"village_name_tw"] &&[[wineInfoArray objectAtIndex:i] valueForKey:@"price"])
        {
            [manufactureArray addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[NSString stringWithFormat:@"%@ - %@",
                                                                                                     [[wineInfoArray objectAtIndex:i] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:i] valueForKey:@"village_name_tw"]]]]];
            
            [priceArray addObject:[NSNumber numberWithFloat:[self calculatePriceTextViewHeight:[[wineInfoArray objectAtIndex:i] valueForKey:@"price"]]]];
            
        }
        else
        {
            [manufactureArray addObject:@""];
            [priceArray addObject:@""];
            
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (float)calculateNameTextViewHeight:(NSString*)text
{
    
    UITextView *textView = [[UITextView alloc] init];
    NSString* title =text;
    [textView setText:title];
    [textView sizeToFit];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width * 0.53125, MAXFLOAT)];
    return size.height/2;
}

- (float)calculateSubNameTextViewHeight:(NSString*)text
{
    UITextView *textView = [[UITextView alloc] init];
    NSString* title =text;
    [textView setText:title];
    [textView sizeToFit];
    CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width *0.53125, MAXFLOAT)];
    return size.height/2;
}

- (float)calculatePriceTextViewHeight:(NSString*)text
{
    UILabel *priceLabel = [[UILabel alloc]init];
    NSString *title = text;
    [priceLabel setText:title];
    [priceLabel sizeToFit];
    CGSize size = [priceLabel sizeThatFits:CGSizeMake(MAXFLOAT,self.view.frame.size.height * 0.04)];
    
    return size.height+ self.view.frame.size.height * 0.088;
}

- (float)textWrapperViewHeight:(NSString*)title subTitle:(NSString*)subTitle price:(NSString*)price producer:(NSString*)producer
{
    return [self calculateNameTextViewHeight:title] + [self calculateSubNameTextViewHeight:subTitle] + [self calculatePriceTextViewHeight:price] + [self calculateNameTextViewHeight:producer];
}
- (UIColor*)drawGradientLineWithRGB:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [wineInfoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"id"] isEqualToString:@"0"])
    {
        return self.tableView.frame.size.height * 0.09;
    }
    else if (indexPath.row == [wineInfoArray count]-1)
    {
        return [[title_tw_length_array objectAtIndex:[wineInfoArray count]-1]floatValue]+[[title_en_length_array objectAtIndex:[wineInfoArray count]-1]floatValue]+[[priceArray objectAtIndex:[wineInfoArray count]-1]floatValue]+[[manufactureArray objectAtIndex:[wineInfoArray count]-1]floatValue]+40+48;
    }
    else
    {
        return [[title_tw_length_array objectAtIndex:indexPath.row]floatValue]+[[title_en_length_array objectAtIndex:indexPath.row]floatValue]+[[priceArray objectAtIndex:indexPath.row]floatValue]+[[manufactureArray objectAtIndex:indexPath.row]floatValue]+48;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    float superViewWidth = self.view.frame.size.width;
    //float superViewHeight = self.view.frame.size.height;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.07)];
    imageContainer = [[UIView alloc]initWithFrame:CGRectMake(headerView.frame.size.width * 0.034375,headerView.frame.size.height * 0.2, headerView.frame.size.height * 0.6, headerView.frame.size.height * 0.6)];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"id" ]isEqualToString:@"0"])
    {
        
        singleEventTitleCellTableViewCell* cell;
        static NSString *cellIdentifier = @"NewItemTableViewCell";
        cell = (singleEventTitleCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib2)
            {
                self.cellNib2 = [UINib nibWithNibName:@"singleEventTitleCellTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib2 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        cell.titleLabel.hidden = YES;
        cell.subtitleLabel.hidden = YES;
        cell.bottomLine.hidden  = YES;
        imageContainer.layer.cornerRadius = imageContainer.bounds.size.width/2;
        imageContainer.layer.masksToBounds = YES;
        
        UIImageView *glassImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.height * 0.6, headerView.frame.size.height * 0.6)];
        if ([[wineInfoArray objectAtIndex:0]valueForKey:@"wine_type_id"])
        {
            glassImage.image = [UIImage imageNamed:@"img_wineglass.png"];
        }
        else
        {
            glassImage.image = [UIImage imageNamed:@"img_money.png"];
        }
        glassImage.frame = CGRectMake(0, 0, headerView.frame.size.height * 0.4, headerView.frame.size.height * 0.4);
        [glassImage setCenter:CGPointMake(imageContainer.frame.size.width /2 , imageContainer.frame.size.height / 2)];
        [imageContainer addSubview:glassImage];
        [headerView addSubview:imageContainer];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134 + 5, CGRectGetMidY(headerView.frame)-7, superViewWidth*0.8f, 14)];
        //[title setCenter:CGPointMake(superViewWidth * 0.134 + 5+60, CGRectGetMidX(glassImage.frame.size.height))];
        if ([language isEqualToString:@"en"]) {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_cn"];
        }
        else
        {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_tw"];
        }
        
        title.font = [UIFont boldSystemFontOfSize:13];
        
        UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageContainer.frame), CGRectGetMaxY(imageContainer.frame), 1, headerView.frame.size.height - CGRectGetMaxY(imageContainer.frame)+1)];
        
        UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageContainer.frame), headerView.frame.origin.y, 1, CGRectGetMinY(imageContainer.frame))];
        if (indexPath.row > 0)
        {
            switch ([[[wineInfoArray objectAtIndex:indexPath.row - 1]valueForKey:@"wine_type_id"]integerValue]) {
                case 1:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                    break;
                case 2:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                    break;
                case 3:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.4];
                    break;
                case 4:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                    break;
                case 5:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.4];
                    break;
                case 6:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.4];
                    break;
                case 7:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.4];
                    break;
                case 8:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.4];
                    break;
                case 9:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.4];
                    break;
                case 10:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                    break;
                case 11:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                    break;
                case 12:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.4];
                    break;
                case 13:
                    gradientLineTop.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.4];
                    break;
                default:
                    break;
            }
        }
        
        switch ([[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"wine_type_id"]integerValue]) {
            case 1:
                title.textColor = [UIColor colorWithHexString:@"a71645"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"a71645"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                break;
            case 2:
                title.textColor = [UIColor colorWithHexString:@"0a9d98"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"0a9d98"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                
                break;
            case 3:
                title.textColor = [UIColor colorWithHexString:@"663ab0"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"663ab0"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.4];
                
                break;
            case 4:
                title.textColor = [UIColor colorWithHexString:@"1b86bd"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"1b86bd"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                
                break;
            case 5:
                title.textColor = [UIColor colorWithHexString:@"ef8d01"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"ef8d01"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.4];
                
                break;
            case 6:
                title.textColor = [UIColor colorWithHexString:@"eed05a"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"eed05a"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.4];
                
                break;
            case 7:
                title.textColor = [UIColor colorWithHexString:@"8ce3e0"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"8ce3e0"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.4];
                
                break;
            case 8:
                title.textColor = [UIColor colorWithHexString:@"92e38c"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"92e38c"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.4];
                
                break;
            case 9:
                title.textColor = [UIColor colorWithHexString:@"fcbcd8"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"fcbcd8"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.4];
                
                break;
            case 10:
                title.textColor = [UIColor colorWithHexString:@"0a9d98"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"0a9d98"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                
                break;
            case 11:
                title.textColor = [UIColor colorWithHexString:@"a71645"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"a71645"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                
                break;
            case 12:
                title.textColor = [UIColor colorWithHexString:@"fe557d"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"fe557d"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.4];
                
                break;
            case 13:
                title.textColor = [UIColor colorWithHexString:@"2543d8"];
                imageContainer.backgroundColor = [UIColor colorWithHexString:@"2543d8"];
                gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.4];
                
                break;
            default:
                break;
        }
        if (![[wineInfoArray objectAtIndex:0]valueForKey:@"wine_type_id"]) {
            NSLog(@"no wine_type_id");
            switch ([[[wineInfoArray objectAtIndex:indexPath.row+1]valueForKey:@"wine_type_id"]integerValue]) {
                case 1:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"a71645"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                    break;
                case 2:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"0a9d98"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                    
                    break;
                case 3:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"663ab0"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.4];
                    
                    break;
                case 4:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"1b86bd"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                    
                    break;
                case 5:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"ef8d01"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.4];
                    
                    break;
                case 6:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"eed05a"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.4];
                    
                    break;
                case 7:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"8ce3e0"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.4];
                    
                    break;
                case 8:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"92e38c"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.4];
                    
                    break;
                case 9:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"fcbcd8"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.4];
                    
                    break;
                case 10:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"0a9d98"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                    
                    break;
                case 11:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"a71645"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                    
                    break;
                case 12:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"fe557d"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.4];
                    
                    break;
                case 13:
                    imageContainer.backgroundColor = [UIColor colorWithHexString:@"2543d8"];
                    gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.4];
                    break;
                default:
                    break;
            }
        }
        [headerView addSubview:title];
        [cell addSubview:headerView];
        
        if (indexPath.row != 0)
        {
            [cell addSubview:gradientLineTop];
        }
        
        [cell addSubview:gradientLineBottom];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"NewItemTableViewCell";
        NewItemTableViewCell* cell;
        cell = (NewItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib)
            {
                self.cellNib = [UINib nibWithNibName:@"NewItemTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        
        UITextView *title = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , superViewWidth*0.53125, [[title_tw_length_array objectAtIndex:indexPath.row]floatValue])];
        if ([language isEqualToString:@"en"]) {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_cn"];
        }
        else
        {
            title.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"title_tw"];
        }
        
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = [UIColor blackColor];
        title.userInteractionEnabled = NO;
        title.contentInset = UIEdgeInsetsMake(0,0,0,0);
        [title sizeToFit];
        //[cell.itemImageView setImageWithURL:[NSURL URLWithString:[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"]]];
       
        
        [cell.itemImageView sd_setImageWithURL:[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"] placeholderImage:[UIImage  imageNamed:@"img_windglass.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.itemImageView.image = image;
        }];
        UITextView *subTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) -10 , superViewWidth*0.53125, [[title_en_array objectAtIndex:indexPath.row]floatValue])];
        if ([language isEqualToString:@"en"]) {
            subTitle.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"subtitle_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            subTitle.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"subtitle_cn"];
        }
        else
        {
            subTitle.text = [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"subtitle_tw"];
        }
        subTitle.font = [UIFont systemFontOfSize:14];
        subTitle.textColor = [UIColor blackColor];
        subTitle.userInteractionEnabled = NO;
        subTitle.contentInset = UIEdgeInsetsMake(0,0,0,0);
        [subTitle sizeToFit];
        
        UIView * priceWrapperView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitle.frame) , [[priceArray objectAtIndex:indexPath.row]floatValue], self.view.frame.size.height * 0.04)];
        priceWrapperView.backgroundColor = [UIColor darkGrayColor];
        priceWrapperView.layer.cornerRadius = 10;
        priceWrapperView.layer.masksToBounds = YES;
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, priceWrapperView.frame.size.width, self.view.frame.size.height * 0.04)];
        priceLabel.text = [NSString stringWithFormat:@"NT$%@", [[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"price"]];
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.textColor = [UIColor whiteColor];
        [priceLabel sizeToFit];
        [priceLabel setCenter:CGPointMake(priceWrapperView.frame.size.width/2, priceWrapperView.frame.size.height/2)];
        [priceWrapperView addSubview:priceLabel];
        
        UITextView *producerName = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(subTitle.frame), CGRectGetMaxY(priceWrapperView.frame), CGRectGetMinX(cell.itemImageView.frame),  [[manufactureArray objectAtIndex:indexPath.row]floatValue])];
        
        if ([language isEqualToString:@"en"]) {
            producerName.text = [NSString stringWithFormat:@"%@ - %@",
                                 [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"country_name_en"],[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"village_name_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            producerName.text = [NSString stringWithFormat:@"%@ - %@",
                                 [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"country_name_cn"],[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"village_name_cn"]];
        }
        else
        {
            producerName.text = [NSString stringWithFormat:@"%@ - %@",
                                 [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"village_name_tw"]];
        }
        
        [UIFont systemFontOfSize:14];
        producerName.textColor = [UIColor blackColor];
        producerName.textAlignment = NSTextAlignmentNatural;
        producerName.userInteractionEnabled = NO;
        [producerName sizeToFit];
        [producerName layoutIfNeeded];
        UIView *textWrapperView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.134,0 , CGRectGetMinX(cell.imageWrapper.frame)-superViewWidth * 0.134,CGRectGetMaxY(producerName.frame) - CGRectGetMinY(title.frame) )];
        [textWrapperView addSubview:title];
        [textWrapperView addSubview:subTitle];
        [textWrapperView addSubview:priceWrapperView];
        [textWrapperView addSubview:producerName];
        [textWrapperView setCenter:CGPointMake(CGRectGetMidX(textWrapperView.frame), CGRectGetMidY(cell.imageWrapper.frame))];
        //textWrapperView.backgroundColor = [UIColor clearColor];
        [cell addSubview:textWrapperView];
        
        UIView *gradientLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageContainer.frame), cell.bounds.origin.y, 1, [[title_tw_length_array objectAtIndex:indexPath.row]floatValue]+[[title_en_length_array objectAtIndex:indexPath.row]floatValue]+[[priceArray objectAtIndex:indexPath.row]floatValue]+[[manufactureArray objectAtIndex:indexPath.row]floatValue]+48)];
        UIView *bottomDot = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(gradientLine.frame), CGRectGetMaxY(gradientLine.frame), 7, 7)];
        bottomDot.layer.cornerRadius = bottomDot.bounds.size.width/2;
        bottomDot.layer.masksToBounds = YES;
        [bottomDot setCenter:CGPointMake(CGRectGetMidX(gradientLine.frame), CGRectGetMaxY(gradientLine.frame))];
        
        switch ([[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"wine_type_id"]integerValue]) {
            case 1:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.7];
                break;
            case 2:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
                break;
            case 3:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.7];
                break;
            case 4:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
                break;
            case 5:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.7];
                break;
            case 6:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.7];
                break;
            case 7:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.7];
                break;
            case 8:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.7];
                break;
            case 9:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.7];
                break;
            case 10:
                
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
                break;
            case 11:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.7];
                break;
            case 12:
                
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.7];
                break;
            case 13:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.7];
                break;
            default:
                break;
        }
        [cell addSubview:gradientLine];
        if (indexPath.row == wineInfoArray.count-1) {
            NSLog(@"last item");
            [cell addSubview:bottomDot];
        }
        
        
        UIView *dividedLine = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth*0.666, CGRectGetHeight(cell.itemImageView.frame)*0.2, 1, CGRectGetHeight(cell.itemImageView.frame)*3/4)];
        dividedLine.backgroundColor = [self drawGradientLineWithRGB:232 green:233 blue:232 alpha:1.0];
        //[cell addSubview:dividedLine];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedIdx = indexPath;
    if (![[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"id" ]isEqualToString:@"0"])
    {
        [self performSegueWithIdentifier:@"resultToSingle" sender:self];
        self.tableView.userInteractionEnabled = NO;
    }
    
}
-(void)tableView:(UITableView*) tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == [wineInfoArray count] - 1)
    {
        
        NSString* limit = @"30";
        if ([[defaults objectForKey:@"filtFirstTime"]isEqualToString:@"on"]||[[defaults objectForKey:@"searchFirstTime"]isEqualToString:@"on"])
        {
            loadingOffset = 30;
            NSLog(@"initialized offset");
        }
        else
        {
            loadingOffset += 30;
            NSLog(@"offset changed");
        }
        
        NSString* calculatedOffset = [NSString stringWithFormat:@"%ld",(long)loadingOffset];
        NSLog(@"current offset:%@",calculatedOffset);
        if ([[defaults objectForKey:@"searchSwitch"]isEqualToString:@"on"]) {
            [self fetchOverViewList:limit offset:calculatedOffset search:[defaults objectForKey:@"searchString"]];
            
        }
        else
        {
            [self fetchOverViewList:limit offset:calculatedOffset search:@""];
            
        }
        [defaults setObject:@"off" forKey:@"filtFirstTime"];
        [defaults setObject:@"off" forKey:@"searchFirstTime"];
        [defaults synchronize];
        
        NSLog(@"we are at last row");
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultToSingle"])
    {
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        SingleItemViewController *vc = [segue destinationViewController];
        vc.twTitleString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"title_tw"];
        vc.enTitleString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"title_en"];
        vc.priceString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"price"];
        if ([language isEqualToString:@"en"]) {
            vc.manufactureString = [NSString stringWithFormat:@"%@ - %@",[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"country_name_en"],[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"village_name_en"]];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            vc.manufactureString = [NSString stringWithFormat:@"%@ - %@",[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"country_name_cn"],[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"village_name_cn"]];
        }
        else
        {
            vc.manufactureString = [NSString stringWithFormat:@"%@ - %@",[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"village_name_tw"]];
        }
        
        vc.selectedWineInfoDictionary = [wineInfoArray objectAtIndex:self.selectedIdx.row];
        vc.productImageString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"pic_url"];
        vc.windIdString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"id"];
    }
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterAction:(id)sender {
    [self performSegueWithIdentifier:@"resultToFilter" sender:self];
}


- (void)fetchOverViewList:(NSString*)limit offset:(NSString*)offset search:(NSString*)searchString
{
    if ([[defaults objectForKey:@"filtWithAllOptions"]isEqualToString:@"selected"])
    {
        [[VintageApiService sharedInstance]fetchWineListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] order_by:[defaults objectForKey:@"filtOrderBy"] order:[defaults objectForKey:@"filtOrder"] limit:limit offset:offset country_id:@"" wine_type_id:@"" search:searchString];
        NSLog(@"filtWithAllOptions");
    }
    else if ([defaults objectForKey:@"filtWithWineType"]!=nil)
    {
        
        [[VintageApiService sharedInstance]fetchWineListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] order_by:[defaults objectForKey:@"filtOrderBy"] order:[defaults objectForKey:@"filtOrder"] limit:limit offset:offset country_id:[defaults objectForKey:@"filtWithRegion"] wine_type_id:[defaults objectForKey:@"filtWithWineType"]search:searchString];
        NSLog(@"filtWithWineType");
        
    }
    else
    {
        [[VintageApiService sharedInstance]fetchWineListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] order_by:@"" order:@"" limit:limit offset:offset country_id:@"" wine_type_id:@"" search:searchString];
        NSLog(@"filtWithoutOptions");
    }
}
@end
