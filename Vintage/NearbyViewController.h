//
//  NearbyViewController.h
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
@interface NearbyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *shopListButton;
@property (weak, nonatomic) IBOutlet UIButton *mapListButton;
@property (weak, nonatomic) IBOutlet UIPickerView *areaPickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *areaPickerButton;
@property CLLocation* myLocation;
@property NSString* cityName;
@property NSInteger selectedRow;
@property NSInteger selectedBannerIndex;
@property id cellNib;
@property id cellNib2;
@end
