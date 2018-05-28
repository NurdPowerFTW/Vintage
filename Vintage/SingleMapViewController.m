//
//  SingleMapViewController.m
//  Vintage
//
//  Created by Will Tang on 7/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SingleMapViewController.h"
#import "Annotation.h"
@interface SingleMapViewController ()

@end

@implementation SingleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
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
    
    
    
    [self updateAnnotations];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateAnnotations
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    Annotation *myAnnotation = [[Annotation alloc]init];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"])
    {
        myAnnotation.title = [self.selectedItemArray valueForKey:@"title_en"];
        myAnnotation.subTitle = [self.selectedItemArray valueForKey:@"subtitle_en"];
        
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        
        myAnnotation.title = [self.selectedItemArray valueForKey:@"title_cn"];
        myAnnotation.subTitle = [self.selectedItemArray valueForKey:@"subtitle_cn"];
        
    }
    else
    {
        myAnnotation.title = [self.selectedItemArray valueForKey:@"title_tw"];
        myAnnotation.subTitle = [self.selectedItemArray valueForKey:@"subtitle_tw"];
        
    }
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.selectedItemArray valueForKey:@"latitude"]doubleValue];
    coordinate.longitude = [[self.selectedItemArray valueForKey:@"longitude"]doubleValue];
    
    
    myAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:myAnnotation];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 3000, 3000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
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

    annotationView.image = [UIImage imageNamed:@"img_landmarks"];
    annotationView.annotation = annotation;
    annotationView.opaque = NO;
    
    return annotationView;
    
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
