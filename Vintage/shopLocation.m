//
//  shopLocation.m
//  Vintage
//
//  Created by Will Tang on 6/14/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "shopLocation.h"
#import <AddressBook/AddressBook.h>

@interface shopLocation()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation shopLocation

- (id)initWithName:(NSString*)title SubTitle:(NSString*)Subtitle address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate phoneNumber:(NSString*)phoneNumber{
    if ((self = [super init])) {
        if ([title isKindOfClass:[NSString class]]) {
            self.title = title;
        } else {
            self.title = @"Unknown charge";
        }
        self.subTitle = Subtitle;
        self.phoneNumber = phoneNumber;
        self.address = address;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subTitle {
    return _subTitle;
}
- (NSString *)phoneNumber {
    return _phoneNumber;
}
- (NSString *)address {
    return _address;
}
- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
