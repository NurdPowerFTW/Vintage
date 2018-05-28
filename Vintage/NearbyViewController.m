//
//  NearbyViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "NearbyViewController.h"
#import "Vintage-Swift.h"
#import "itemTableViewCell.h"
#import "singleEventTitleCellTableViewCell.h"
#import "NewItemTableViewCell.h"
#import "VintageApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"
#import "Vintage-Swift.h"
#import "SingleItemViewController.h"
#import "ShopTableViewCell.h"
#import "shopLocation.h"
#import "customCalloutView.h"
#import "singleShopViewController.h"
#import "Annotation.h"
#import "SCLAlertView.h"
@implementation NearbyViewController
{
    NSMutableArray* shopInfoArray;
    NSMutableArray* cellType;
    NSMutableArray* latitudeArray;
    NSMutableArray* logitudeArray;
    NSMutableArray* areaInfo;
    NSMutableArray* cityArray;
    UIView *imageContainer;
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[VintageApiService sharedInstance]setLastTappedIndex:@"2"];
    self.mapView.hidden = YES;
    shopInfoArray = [[NSMutableArray alloc]init];
    cellType = [[NSMutableArray alloc]init];
    latitudeArray = [[NSMutableArray alloc]init];
    logitudeArray = [[NSMutableArray alloc]init];
    areaInfo = [[NSMutableArray alloc]init];
    cityArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchNearbyShopListNotification:) name:FetchNearbyShopListNotification object:nil];
    [[VintageApiService sharedInstance]fetchNearbyShopListInfo:@""];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingCityInfoNotification:) name:FetchingCityInfoNotification object:nil];
    [[VintageApiService sharedInstance]fetchCityListInfo];
    self.shopListButton.selected = YES;
    self.mapListButton.selected = NO;
    [self.shopListButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
    [self.view bringSubviewToFront:self.pickerView];
    self.pickerView.hidden = YES;
    
    
    self.areaPickerView.delegate = self;
    self.areaPickerView.dataSource = self;
    
    
}
-(void)onFetchNearbyShopListNotification:(NSNotification*)notify
{
    cellType = [[notify.object objectForKey:@"stores"]valueForKey:@"id"];
    shopInfoArray = [notify.object objectForKey:@"stores"];
    [self updateAnnotations];
    [self.tableView reloadData];
    if (cellType.count <= 1)
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
        [alert showWarning:self title:NSLocalizedString(@"此區域無商店", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
    }
}
- (void)onFetchingCityInfoNotification:(NSNotification*)notify
{
    areaInfo = [notify.object objectForKey:@"counties"];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"])
    {
        [cityArray insertObject:@"All Stores" atIndex:0];
        [cityArray addObjectsFromArray:[areaInfo valueForKey:@"title_en"]];
       
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        
        [cityArray insertObject:@"全部店家" atIndex:0];
        [cityArray addObjectsFromArray:[areaInfo valueForKey:@"title_cn"]];
        
    }
    else
    {
        [cityArray insertObject:@"全部店家" atIndex:0];
        [cityArray addObjectsFromArray:[areaInfo valueForKey:@"title_tw"]];
       
    }
    
    [self.areaPickerView reloadAllComponents];
}
#pragma mark - CLLocationManager

- (void) findMyCurrentLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services Enabled....");
        
        
    }
    else
    {
        double latitude = 25.021603;
        double longitude = 121.541045;
        
        CLLocation* defaultLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [self setMyLocation:defaultLocation];
        NSLog(@"Location Services Are Not Enabled....");
        
    }
    
}
- (void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation*) newLocation fromLocation:(CLLocation*) oldLocation
{
    NSLog(@"didUpdateToLocation");
    [self setMyLocation:newLocation];
    
    CLLocationCoordinate2D _coordinate = self.locationManager.location.coordinate;
    MKCoordinateRegion extentsRegion = MKCoordinateRegionMakeWithDistance(_coordinate, 800, 800);
    [self.mapView setRegion:extentsRegion animated:NO];
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
    
}
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return cityArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [cityArray objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 3000, 3000);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
- (IBAction)pickerCancelAction:(id)sender {
    self.pickerView.hidden = YES;
    
}
- (IBAction)pickerConfirmAction:(id)sender {
    
    self.cityName = [cityArray objectAtIndex:self.selectedRow];
    
    if ([self.cityName isEqualToString:NSLocalizedString(@"全部店家", nil)])
    {
        [[VintageApiService sharedInstance]fetchNearbyShopListInfo:@""];
    }
    for (int i = 0; i < cityArray.count; i++) {
        if ([self.cityName isEqualToString:[cityArray objectAtIndex:i]])
        {

            [[VintageApiService sharedInstance]fetchNearbyShopListInfo:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    self.pickerView.hidden = YES;
    
    
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

- (IBAction)shopListPressed:(id)sender {
    if (self.shopListButton.selected == NO)
    {
        self.areaPickerButton.hidden = NO;
        self.shopListButton.selected = YES;
        self.mapListButton.selected = NO;
        self.tableView.hidden = NO;
        self.mapView.hidden = YES;
        [self.shopListButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
        [self.mapListButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"F4F4F4"]] forState:UIControlStateSelected];
    }
    
}
- (IBAction)mapListPressed:(id)sender {
    if (self.mapListButton.selected == NO)
    {
        self.mapView.delegate = self;
        self.areaPickerButton.hidden = YES;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = 10; // or whatever
        [self.locationManager startUpdatingLocation];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        
        self.mapView.showsUserLocation = YES;
        [self.mapView setMapType:MKMapTypeStandard];
        [self.mapView setZoomEnabled:YES];
        [self.mapView setScrollEnabled:YES];
        self.mapListButton.selected = YES;
        self.shopListButton.selected = NO;
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
        [self.mapListButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"EAEAEA"]] forState:UIControlStateSelected];
        [self.shopListButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"F4F4F4"]] forState:UIControlStateSelected];
        //CLLocation *location = [[CLLocation alloc]initWithLatitude:25.0485638 longitude:121.5167871];
        self.mapView.showsUserLocation = YES;
    }
    
}
- (IBAction)pickerButtonPressed:(id)sender {
    self.pickerView.hidden = NO;
}
- (void)updateAnnotations
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    for (int i = 0; i < shopInfoArray.count; i++) {
        if (![[cellType objectAtIndex:i]isEqualToString:@"0"])
        {
            NSNumber *latitude = [[shopInfoArray objectAtIndex:i]valueForKey:@"latitude"];
            NSNumber *longitude = [[shopInfoArray objectAtIndex:i]valueForKey:@"longitude"];
            NSString *shopTitle = [NSString new];
            NSString *shopSubTitle = [NSString new];
            NSString *address = [NSString new];
            NSString *phoneNumber = [NSString new];
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            if ([language isEqualToString:@"en"])
            {
                shopTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"title_en"];
                shopSubTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"subtitle_en"];
                address = [[shopInfoArray objectAtIndex:i]valueForKey:@"address_en"];
                phoneNumber = [[shopInfoArray objectAtIndex:i]valueForKey:@"phone_en"];
            }
            else if ([language isEqualToString:@"zh-Hans"])
            {
                shopTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"title_cn"];
                shopSubTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"subtitle_cn"];
                address = [[shopInfoArray objectAtIndex:i]valueForKey:@"address_cn"];
                phoneNumber = [[shopInfoArray objectAtIndex:i]valueForKey:@"phone_cn"];
            }
            else
            {
                shopTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"title_tw"];
                shopSubTitle = [[shopInfoArray objectAtIndex:i]valueForKey:@"subtitle_tw"];
                address = [[shopInfoArray objectAtIndex:i]valueForKey:@"address_tw"];
                phoneNumber = [[shopInfoArray objectAtIndex:i]valueForKey:@"phone_tw"];
            }
            
            
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latitude.doubleValue;
            coordinate.longitude = longitude.doubleValue;
            //shopLocation *annotation = [[shopLocation alloc]initWithName:shopTitle SubTitle:shopSubTitle address:address coordinate:coordinate phoneNumber:phoneNumber];
            Annotation *myAnnotation = [[Annotation alloc]init];
            myAnnotation.title = shopTitle;
            myAnnotation.subTitle = shopSubTitle;
            myAnnotation.coordinate = coordinate;
            myAnnotation.tag = i;
            [self.mapView addAnnotation:myAnnotation];
        }
        
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier] ;
    }
    annotationView.canShowCallout = YES;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    Annotation* annotateObject = (Annotation*) annotation;
    rightButton.tag = annotateObject.tag;
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    annotationView.image = [UIImage imageNamed:@"img_landmarks"];
    annotationView.annotation = annotation;
    annotationView.opaque = NO;
    
    return annotationView;
        
    
}
- (void) showDetails:(UIButton*) sender
{
    int tag = (int)sender.tag;
    self.selectedBannerIndex = tag;
    [self performSegueWithIdentifier:@"showSingleShop" sender:self];
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    customCalloutView* calloutView = (customCalloutView*)[[[NSBundle mainBundle]loadNibNamed:@"customCalloutView" owner:self options:nil]objectAtIndex:0];
    calloutView.title.text = view.annotation.title;
    
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController showSideMenuView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[cellType objectAtIndex:indexPath.row]isEqualToString:@"0"])
    {
        return self.view.frame.size.height * 0.0704;
    }
    else if (indexPath.row == [shopInfoArray count]-1)
    {
        return self.view.frame.size.height * 0.185 +30;
    }
    else
    {
        return self.view.frame.size.height * 0.185 +20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];

    float superViewWidth = self.view.frame.size.width;
    float superViewHeight = self.view.frame.size.height;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.07)];
    imageContainer = [[UIView alloc]initWithFrame:CGRectMake(headerView.frame.size.width * 0.034375,headerView.frame.size.height * 0.2, headerView.frame.size.height * 0.6, headerView.frame.size.height * 0.6)];
    UILabel *sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134, CGRectGetMidY(headerView.frame)-7, superViewHeight*0.1875, superViewHeight*0.0387323943662)];
    UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.044, 0 , CGRectGetHeight(sectionTitle.frame), CGRectGetHeight(sectionTitle.frame))];
    
    if ([[cellType objectAtIndex:indexPath.row]isEqualToString:@"0"])
    {
        
        singleEventTitleCellTableViewCell* cell;
        static NSString *cellIdentifier = @"NewItemTableViewCell";
        cell = (singleEventTitleCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib)
            {
                self.cellNib = [UINib nibWithNibName:@"singleEventTitleCellTableViewCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        cell.titleLabel.hidden = YES;
        cell.subtitleLabel.hidden = YES;
        cell.bottomLine.hidden  = YES;
        
        
        
        
        //[title setCenter:CGPointMake(superViewWidth * 0.134 + 5+60, CGRectGetMidX(glassImage.frame.size.height))];
        if ([language isEqualToString:@"en"]) {
            sectionTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            sectionTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_cn"];
        }
        else
        {
            sectionTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_tw"];
        }
        
        sectionTitle.font = [UIFont boldSystemFontOfSize:14];
        
        outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
        outerRingView.layer.masksToBounds = YES;
        outerRingView.center = CGPointMake(CGRectGetMidX(outerRingView.frame), CGRectGetMidY(sectionTitle.frame));
        
        
        UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
        innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
        innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
        innerRingView.layer.masksToBounds = YES;
        
        
        
        UIView *gradientTopLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
        UIView *gradientBotLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, self.view.frame.size.height * 0.0704-CGRectGetMaxY(outerRingView.frame))];
        if (indexPath.row > 0)
        {
            switch ([[[shopInfoArray objectAtIndex:indexPath.row - 1]valueForKey:@"county_id"]integerValue]) {
                case 1:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                    break;
                case 2:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:0.4];
                    break;
                case 3:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:0.4];
                    break;
                case 4:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:0.4];
                    break;
                case 5:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                    break;
                case 6:
                    gradientTopLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                    break;
                default:
                    break;
            }
        }
        switch ([[[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"county_id"]integerValue]) {
            case 1:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                break;
            case 2:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:0.4];
                break;
            case 3:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:0.4];
                break;
            case 4:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:0.4];
                break;
            case 5:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                break;
            case 6:
                outerRingView.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
                innerRingView.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:1.0];
                gradientBotLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                break;
            default:
                break;
        }
        
        
        
        if (indexPath.row != 0)
        {
            [cell addSubview:gradientTopLine];
        }
        [cell addSubview:outerRingView];
        [outerRingView addSubview:innerRingView];
        [cell addSubview:gradientBotLine];
        [headerView addSubview:sectionTitle];
        [cell addSubview:headerView];
        
        
        return cell;
    }
    else
    {
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
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134, CGRectGetMinY(cell.photoImageVIew.frame), 130, superViewHeight*0.0616)];
        if ([language isEqualToString:@"en"]) {
            title.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            title.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_cn"];
        }
        else
        {
            title.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"title_tw"];
        }
        
        title.font = [UIFont boldSystemFontOfSize:14];
        title.numberOfLines = 2;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        //title.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        [cell addSubview:title];
        
        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134, CGRectGetMaxY(title.frame)+5,130, superViewHeight*0.02113)];
        if ([language isEqualToString:@"en"]) {
            subTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"subtitle_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            subTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"subtitle_cn"];
        }
        else
        {
            subTitle.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"subtitle_tw"];
        }
        
        subTitle.font = [UIFont boldSystemFontOfSize:12];
        //subTitle.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        [cell addSubview:subTitle];
        
        UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134, CGRectGetMaxY(cell.frame) - (superViewHeight*0.0634), 130, superViewHeight*0.0634)];
        if ([language isEqualToString:@"en"]) {
            address.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"address_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            address.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"address_cn"];
        }
        else
        {
            address.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"address_tw"];
        }
        
        address.font = [UIFont systemFontOfSize:12];
        address.numberOfLines = 2;
        //address.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        [cell addSubview:address];
        UILabel *phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.134, CGRectGetMidY(address.frame)-superViewHeight*0.0634-5, 130, superViewHeight*0.0634)];
        phoneNumber.text = [[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"phone_tw"];
        phoneNumber.font = [UIFont systemFontOfSize:12];
        //phoneNumber.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        [cell addSubview:phoneNumber];
        
        
        
        
        [cell.photoImageVIew sd_setImageWithURL:[[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"img_ios_default"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
        {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (image)
            {
                CGRect rect = CGRectMake(0,0,cell.photoImageVIew.frame.size.width ,cell.photoImageVIew.frame.size.height);
                UIGraphicsBeginImageContext(rect.size);
                [image drawInRect:rect];
                UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *imageData = UIImagePNGRepresentation(picture1);
                UIImage *img=[UIImage imageWithData:imageData];
                cell.photoImageVIew.image = img;
            }
            else
            {
                cell.photoImageVIew.image = [UIImage imageNamed:@"img_ios_default"];
            }
            
        }];
        UIView *gradientLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, self.view.frame.size.height * 0.185+20)];
        UIView *bottomDot = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(gradientLine.frame), CGRectGetMaxY(gradientLine.frame), 7, 7)];
        bottomDot.layer.cornerRadius = bottomDot.bounds.size.width/2;
        bottomDot.layer.masksToBounds = YES;
        [bottomDot setCenter:CGPointMake(CGRectGetMidX(gradientLine.frame), CGRectGetMaxY(gradientLine.frame))];
        switch ([[[shopInfoArray objectAtIndex:indexPath.row]valueForKey:@"county_id"]integerValue]) {
            case 1:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:0.7];
                break;
            case 2:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"591b48" alpha:0.7];
                break;
            case 3:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"4b0469" alpha:0.7];
                break;
            case 4:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"040469" alpha:0.7];
                break;
            case 5:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"1b86bd" alpha:0.7];
                
                break;
            case 6:
                gradientLine.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.4];
                bottomDot.backgroundColor = [UIColor colorWithHexString:@"0a9d98" alpha:0.7];
                break;
            default:
                break;
        }
        [cell addSubview:gradientLine];
        if (indexPath.row == shopInfoArray.count-1) {
            [cell addSubview:bottomDot];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedBannerIndex = indexPath.row;
    [self performSegueWithIdentifier:@"showSingleShop" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSingleShop"]) {
        singleShopViewController* vc = [segue destinationViewController];
        //vc.selectedBannerIndex = self.selectedBannerIndex;
        vc.selectedEventArray = [shopInfoArray objectAtIndex:self.selectedBannerIndex];
    }
}
@end
