//
//  Annotation.h
//  Vintage
//
//  Created by Will Tang on 7/11/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* subTitle;
@property NSInteger tag;

@end
