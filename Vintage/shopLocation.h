//
//  shopLocation.h
//  Vintage
//
//  Created by Will Tang on 6/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface shopLocation : NSObject

- (id)initWithName:(NSString*)title SubTitle:(NSString*)Subtitle address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate phoneNumber:(NSString*)phoneNumber;
- (MKMapItem*)mapItem;
@end
