//
//  EventViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "EventViewController.h"
#import "Vintage-Swift.h"
#import "EventTableCell.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SingleEventViewController.h"
#import "VintageApiService.h"
@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[VintageApiService sharedInstance]setLastTappedIndex:@"3"];
    self.itemArray = [[NSMutableArray alloc]init];
    //self.itemArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"bannerImageArray"];
    NSLog(@"self.itemArray:%@",self.itemArray);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingSingleEventInfoNotification:) name:FetchingSingleEventNotification object:nil];
    [[VintageApiService sharedInstance]fetchSingleEventInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onFetchingSingleEventInfoNotification:(NSNotification*)notify
{
    self.itemArray = [notify.object objectForKey:@"activities"];
    
    [self.tableView reloadData];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController showSideMenuView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    return self.view.frame.size.height * 0.421;
    return self.view.frame.size.width * 0.75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [cell.bannerImage setImageWithURL:[NSURL URLWithString:[[self.itemArray objectAtIndex:indexPath.row] valueForKey:@"pic_url"]] placeholderImage:[UIImage imageNamed:@"img_default"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedBannerIndex = indexPath.row;
    [self performSegueWithIdentifier:@"showSingleEvent" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSingleEvent"]) {
        SingleEventViewController* vc = [segue destinationViewController];
        //vc.selectedBannerIndex = self.selectedBannerIndex;
        vc.selectedEventArray = [self.itemArray objectAtIndex:self.selectedBannerIndex];
    }
}
@end
