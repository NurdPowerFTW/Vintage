//
//  singleShopViewController.m
//  Vintage
//
//  Created by Will Tang on 6/15/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "singleShopViewController.h"
#import "singleEventTitleCellTableViewCell.h"
#import "singleEventDescriptionCell.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "VintageApiService.h"
#import "EventTableCell.h"
#import "HexColors.h"
#import "SingleMapViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface singleShopViewController ()

@end

@implementation singleShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"])
    {
        self.topBarTitle.text = [self.selectedEventArray valueForKey:@"title_en"];
        
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        
        self.topBarTitle.text = [self.selectedEventArray valueForKey:@"title_cn"];
        
    }
    else
    {
        self.topBarTitle.text = [self.selectedEventArray valueForKey:@"title_tw"];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"singleToMap"]) {
        SingleMapViewController* vc = [segue destinationViewController];
        vc.selectedItemArray = self.selectedEventArray;
    }
    
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
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_en"]];
            
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_cn"]];
            
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_tw"]];
            
        }
        
    }
    else if (indexPath.row == 3)
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_en"]];
            
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_cn"]];
            
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_tw"]];
            
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
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_en"]];
            
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_cn"]];
            
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_tw"]];
            
        }
        
    }
    else
    {
        if ([language isEqualToString:@"en"])
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"contact_email_en"]] + self.view.frame.size.height * 0.1;
            
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"contact_email_cn"]]+ self.view.frame.size.height * 0.1;
            
        }
        else
        {
            return [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"contact_email_tw"]]+ self.view.frame.size.height * 0.1;
            
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
        
        [cell.bannerImage sd_setImageWithURL:[self.selectedEventArray valueForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"img_ios_default"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (image)
             {
                 CGRect rect = CGRectMake(0,0,cell.bannerImage.frame.size.width ,cell.bannerImage.frame.size.height);
                 UIGraphicsBeginImageContext(rect.size);
                 [image drawInRect:rect];
                 UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 NSData *imageData = UIImagePNGRepresentation(picture1);
                 UIImage *img=[UIImage imageWithData:imageData];
                 cell.bannerImage.image = img;
             }
             else
             {
                 cell.bannerImage.image = [UIImage imageNamed:@"img_ios_default"];
             }
             
         }];
        
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
            cell.titleLabel.text = NSLocalizedString(@"關於", nil) ;
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"about_en"];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"about_cn"];
                
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"about_tw"];
                
            }
            
            cell.subTitle.font = [UIFont systemFontOfSize:14];
            cell.subTitle.textColor = [UIColor colorWithHexString:@"948d8d"];
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
            UIView *gradientLineBottom;
            if ([language isEqualToString:@"en"])
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_en"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_cn"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"about_tw"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
            [cell addSubview:gradientLineBottom];
            
        }
        else if (indexPath.row == 3)
        {
            cell.titleLabel.text =NSLocalizedString(@"服務地址", nil) ;
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"address_en"];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"address_cn"];
                
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"address_tw"];
                
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
            UIView *gradientLineBottom;
            if ([language isEqualToString:@"en"])
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_en"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_cn"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"address_tw"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            
            gradientLineBottom.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
            [cell addSubview:gradientLineBottom];
        }
        else if (indexPath.row == 4)
        {
            cell.titleLabel.text = NSLocalizedString(@"服務電話", nil);
            cell.subTitle.text = [self.selectedEventArray valueForKey:@"phone_tw"];
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
            cell.titleLabel.text =NSLocalizedString(@"服務時間", nil) ;
            if ([language isEqualToString:@"en"])
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"service_time_en"];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"service_time_cn"];
                
            }
            else
            {
                cell.subTitle.text = [self.selectedEventArray valueForKey:@"service_time_tw"];
                
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
            UIView *gradientLineBottom;
            if ([language isEqualToString:@"en"])
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_en"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_cn"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            else
            {
                gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"service_time_tw"]]-CGRectGetMaxY(outerRingView.frame))];
                
            }
            
            gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
            [cell addSubview:gradientLineBottom];
        }
        else
        {
            cell.titleLabel.text = NSLocalizedString(@"電子信箱", nil);
            cell.subTitle.text = [self.selectedEventArray valueForKey:@"contact_email_tw"];
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
            UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedEventArray valueForKey:@"contact_email_tw"]]-CGRectGetMaxY(outerRingView.frame))];
            gradientLineBottom.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
            UIView *bottomDot = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame), 7, 7)];
            bottomDot.layer.cornerRadius = bottomDot.bounds.size.width/2;
            bottomDot.layer.masksToBounds = YES;
            [bottomDot setCenter:CGPointMake(CGRectGetMidX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame))];
            bottomDot.backgroundColor =[UIColor colorWithHexString:@"0a9d98" alpha:0.7];
            [cell addSubview:bottomDot];
            [cell addSubview:gradientLineBottom];
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)callAction:(id)sender {
    NSString *phNo = [self.selectedEventArray valueForKey:@"phone_tw"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}
- (IBAction)mapAction:(id)sender {
    [self performSegueWithIdentifier:@"singleToMap" sender:self];
}

@end
