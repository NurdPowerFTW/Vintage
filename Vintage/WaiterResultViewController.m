//
//  WaiterResultViewController.m
//  Vintage
//
//  Created by Will Tang on 6/8/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "WaiterResultViewController.h"
#import "itemTableViewCell.h"
#import "singleEventTitleCellTableViewCell.h"
#import "NewItemTableViewCell.h"
#import "VintageApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColor.h"
#import "Vintage-Swift.h"
#import "SingleItemViewController.h"
@interface WaiterResultViewController ()

@end

@implementation WaiterResultViewController
{
    NSMutableArray* wineInfoArray;
    NSMutableArray* cellType;
    NSMutableArray* title_tw_array;
    NSMutableArray* title_tw_length_array;
    NSMutableArray* title_en_array;
    NSMutableArray* title_en_length_array;
    NSMutableArray* priceArray;
    NSMutableArray* manufactureArray;
    UIView *imageContainer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popUpView.hidden = YES;
    wineInfoArray = [[NSMutableArray alloc]init];
    title_tw_array = [[NSMutableArray alloc]init];
    title_en_array = [[NSMutableArray alloc]init];
    manufactureArray = [[NSMutableArray alloc]init];
    title_tw_length_array = [[NSMutableArray alloc]init];
    title_en_length_array = [[NSMutableArray alloc]init];
    priceArray = [[NSMutableArray alloc]init];
    cellType = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingWineListInfoNotification:) name:FetchingWaiterResultListNotification object:nil];
    [[VintageApiService sharedInstance]fetchWaiterResultListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] order_by:@"" order:@"" limit:@"30" offset:@"0" country_id:@"" wine_type_id:@"" option_ids:@"1,4,8"];
    self.proccedButton.layer.cornerRadius = 14;
    self.proccedButton.layer.masksToBounds = YES;
    self.proccedButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];
}
- (void)onFetchingWineListInfoNotification:(NSNotification*)notify
{
    cellType = [[notify.object objectForKey:@"wines"]valueForKey:@"id"];
    wineInfoArray = [notify.object objectForKey:@"wines"];
    
    title_tw_array = [wineInfoArray valueForKey:@"title_tw"];
    NSLog(@"generating title_tw array");
    title_en_array = [wineInfoArray valueForKey:@"title_en"];
    NSLog(@"generating title_en array");
    for (int i = 0; i < title_tw_array.count; i++)
    {
        [title_tw_length_array addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[title_tw_array objectAtIndex:i]]]];
        [title_en_length_array addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[title_en_array objectAtIndex:i]]]];
        
        
        if ([[wineInfoArray objectAtIndex:i] valueForKey:@"country_name_tw"] && [[wineInfoArray objectAtIndex:i] valueForKey:@"village_name_tw"] && [[wineInfoArray objectAtIndex:i] valueForKey:@"price"])
        {
            [manufactureArray addObject:[NSNumber numberWithFloat:[self calculateNameTextViewHeight:[NSString stringWithFormat:@"%@ - %@",
                                                                                                     [[wineInfoArray objectAtIndex:i] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:i] valueForKey:@"village_name_tw"]]]]];
            [priceArray addObject:[NSNumber numberWithFloat:[self calculatePriceTextViewHeight:[[wineInfoArray objectAtIndex:i] valueForKey:@"price"]]]];
                    }
        else
        {
            [manufactureArray addObject:@""];
            NSLog(@"calculating non manufacture height");
            [priceArray addObject:@""];
            NSLog(@"calculating non price height");
        }
    }
    
    
    [self.tableView reloadData];
    
    
    
}
- (IBAction)resetAction:(id)sender {
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
- (IBAction)proccedAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showSideBar:(id)sender {
    [self.navigationController showSideMenuView];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIColor*)drawGradientLineWithRGB:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
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
    float superViewHeight = self.view.frame.size.height;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.07)];
    imageContainer = [[UIView alloc]initWithFrame:CGRectMake(headerView.frame.size.width * 0.034375,headerView.frame.size.height * 0.2, headerView.frame.size.height * 0.6, headerView.frame.size.height * 0.6)];
    
    
    if ([[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"id" ]isEqualToString:@"0"])
    {
        NSLog(@"deploying wine type cell");
        
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
        glassImage.image = [UIImage imageNamed:@"img_wineglass.png"];
        glassImage.frame = CGRectMake(0, 0, headerView.frame.size.height * 0.4, headerView.frame.size.height * 0.4);
        [glassImage setCenter:CGPointMake(imageContainer.frame.size.width /2 , imageContainer.frame.size.height / 2)];
        [imageContainer addSubview:glassImage];
        [headerView addSubview:imageContainer];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134 + 5, CGRectGetMidY(headerView.frame)-7, 60, 14)];
        //[title setCenter:CGPointMake(superViewWidth * 0.134 + 5+60, CGRectGetMidX(glassImage.frame.size.height))];
        title.text = [title_tw_array objectAtIndex:indexPath.row];
        title.font = [UIFont boldSystemFontOfSize:14];
        
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
        NSLog(@"deploying wine info cell");
        
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
        NSLog(@"actuall cell height:%f",cell.frame.size.height);
        NSLog(@"expected cell height:%f",[[title_tw_length_array objectAtIndex:indexPath.row]floatValue]+[[title_en_length_array objectAtIndex:indexPath.row]floatValue]+[[priceArray objectAtIndex:indexPath.row]floatValue]+[[manufactureArray objectAtIndex:indexPath.row]floatValue]);
        UITextView *title = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , superViewWidth*0.53125, [[title_tw_length_array objectAtIndex:indexPath.row]floatValue])];
        title.text = [title_tw_array objectAtIndex:indexPath.row];
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = [UIColor blackColor];
        title.userInteractionEnabled = NO;
        title.contentInset = UIEdgeInsetsMake(0,0,0,0);
        [title sizeToFit];
        //[cell.itemImageView setImageWithURL:[NSURL URLWithString:[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"]]];
        [cell.itemImageView setImageWithURL:[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"] placeholderImage:[UIImage  imageNamed:@"img_windglass.jpg"] options:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"downloading image:ExpectedSize:%ld, receivedSize:%ld for index:%ld",(long)expectedSize,(long)receivedSize,(long)indexPath.row);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            cell.itemImageView.image = image;
        }];
        
        
        NSLog(@"pic_url:%@ at index:%ld",[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"],(long)indexPath.row);
        UITextView *subTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) -10 , superViewWidth*0.53125, [[title_en_array objectAtIndex:indexPath.row]floatValue])];
        subTitle.text = [title_en_array objectAtIndex:indexPath.row];
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
        priceLabel.text = [[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"price"];
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.textColor = [UIColor whiteColor];
        [priceLabel sizeToFit];
        [priceLabel setCenter:CGPointMake(priceWrapperView.frame.size.width/2, priceWrapperView.frame.size.height/2)];
        [priceWrapperView addSubview:priceLabel];
        
        UITextView *producerName = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(subTitle.frame), CGRectGetMaxY(priceWrapperView.frame), CGRectGetMinX(cell.itemImageView.frame),  [[manufactureArray objectAtIndex:indexPath.row]floatValue])];
        
        producerName.text = [NSString stringWithFormat:@"%@ - %@",
                             [[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:indexPath.row] valueForKey:@"village_name_tw"]];
        [UIFont systemFontOfSize:14];
        producerName.textColor = [UIColor blackColor];
        producerName.textAlignment = NSTextAlignmentNatural;
        producerName.userInteractionEnabled = NO;
        [producerName sizeToFit];
        [producerName layoutIfNeeded];
        UIView *textWrapperView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.134,0 , CGRectGetMinX(cell.imageWrapper.frame)-superViewWidth * 0.134,CGRectGetMaxY(producerName.frame) - CGRectGetMinY(title.frame) )];
        NSLog(@"CGRectGetMinX(cell.itemImageView.frame)-43:%f",CGRectGetMinX(cell.itemImageView.frame)-43);
        NSLog(@"CGRectGetMinX(cell.itemImageView.frame):%f",CGRectGetMinX(cell.imageWrapper.frame));
        NSLog(@"CGRectGetMinY(cell.itemImageView.frame):%f",CGRectGetMidY(cell.imageWrapper.frame));
        [textWrapperView addSubview:title];
        [textWrapperView addSubview:subTitle];
        [textWrapperView addSubview:priceWrapperView];
        [textWrapperView addSubview:producerName];
        [textWrapperView setCenter:CGPointMake(CGRectGetMidX(textWrapperView.frame), CGRectGetMidY(cell.imageWrapper.frame))];
        NSLog(@"textwrapper center y :%f",CGRectGetMidY(textWrapperView.frame));
        NSLog(@"imageview center y :%f",CGRectGetMidY(cell.imageWrapper.frame));
        //textWrapperView.backgroundColor = [UIColor clearColor];
        [cell addSubview:textWrapperView];
        
        UIView *gradientLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imageContainer.frame), cell.bounds.origin.y, 1, [[title_tw_length_array objectAtIndex:indexPath.row]floatValue]+[[title_en_length_array objectAtIndex:indexPath.row]floatValue]+[[priceArray objectAtIndex:indexPath.row]floatValue]+[[manufactureArray objectAtIndex:indexPath.row]floatValue]+48)];
        switch ([[[wineInfoArray objectAtIndex:indexPath.row]valueForKey:@"wine_type_id"]integerValue]) {
            case 1:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                
                break;
            case 2:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                
                break;
            case 3:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"663ab0" alpha:0.4];
                
                break;
            case 4:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                
                break;
            case 5:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"ef8d01" alpha:0.4];
                
                break;
            case 6:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"eed05a" alpha:0.4];
                
                break;
            case 7:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"8ce3e0" alpha:0.4];
                
                break;
            case 8:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"92e38c" alpha:0.4];
                
                break;
            case 9:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"fcbcd8" alpha:0.4];
                
                break;
            case 10:
                
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                
                break;
            case 11:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                
                break;
            case 12:
                
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"fe557d" alpha:0.4];
                
                break;
            case 13:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"2543d8" alpha:0.4];
                
                break;
            default:
                break;
        }
        [cell addSubview:gradientLine];
        
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
        [self performSegueWithIdentifier:@"waiterToSingle" sender:self];
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"waiterToSingle"])
    {
        SingleItemViewController *vc = [segue destinationViewController];
        vc.twTitleString = [title_tw_array objectAtIndex:self.selectedIdx.row];
        vc.enTitleString = [title_en_array objectAtIndex:self.selectedIdx.row];
        vc.priceString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"price"];
        vc.manufactureString = [NSString stringWithFormat:@"%@ - %@",[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"country_name_tw"],[[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"village_name_tw"]];
        vc.selectedWineInfoDictionary = [wineInfoArray objectAtIndex:self.selectedIdx.row];
        vc.productImageString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"pic_url"];
        vc.windIdString = [[wineInfoArray objectAtIndex:self.selectedIdx.row] valueForKey:@"id"];
    }
}
@end
