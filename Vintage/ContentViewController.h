//
//  ContentViewController.h
//  Vintage
//
//  Created by William on 4/20/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"
#import "InfiniteSlideShow.h"
#import <QuartzCore/QuartzCore.h>
#import "mainTableViewCell.h"
#import "tableWithLineViewCell.h"
#import "Vintage-Swift.h"

@interface ContentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,InfiniteSlideShowDatasource,InfiniteSlideShowDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *slidingImageView;
@property (weak, nonatomic) IBOutlet UIView *functionButtonView;
@property UIGestureRecognizer* searchViewRecog;
@property NSString* searchPageIndex;
@property NSMutableArray* photoArray;
@property NSMutableArray* bannerItemArray;
@property NSString *searchString;
@property NSInteger selectedBannerIndex;
@property NSInteger selectedPageIndex;
@property id cellNib;
@property id cellNib2;
@property id cellNib3;

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView;
@end
