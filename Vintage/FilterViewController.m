//
//  FilterViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "FilterViewController.h"
#import "HexColors.h"

@interface FilterViewController()
{
    NSString *orderBy;
    NSString *order;
    NSMutableArray *selectedCountries;
    NSMutableArray *selectedWineTypes;
    NSArray *filterCountries;
    NSArray *filterWineTypes;

}
@end

@implementation FilterViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    filterCountries = [defaults valueForKey:@"filterCountries"];
    filterWineTypes = [defaults valueForKey:@"filterWineTypes"];

    if ([defaults valueForKey:@"previousSelectedWineTypes"])
    {
        selectedWineTypes = [defaults valueForKey:@"previousSelectedWineTypes"];
        selectedCountries = [defaults valueForKey:@"previousSelectedCountries"];
        orderBy = [defaults valueForKey:@"previousOrderBy"];
        order = [defaults valueForKey:@"previousOrder"];
    }
    else
    {
        selectedWineTypes = [NSMutableArray new];
        selectedCountries = [NSMutableArray new];
        [self selectAllWineTypesAndAllCountries];
        orderBy = @"wine_type_id";
        order = @"ASC";
    }
    self.alertView.hidden = YES;
    
}
- (void)selectAllWineTypesAndAllCountries
{
    [selectedCountries removeAllObjects];
    for(NSDictionary *country in filterCountries)
    {
        [selectedCountries addObject:[country valueForKey:@"id"]];
    }
    
    [selectedWineTypes removeAllObjects];
    for(NSDictionary *wineTypes in filterWineTypes)
    {
        [selectedWineTypes addObject:[wineTypes valueForKey:@"id"]];
    }
    
    NSLog(@"selectedCountries:%@",selectedCountries);
    NSLog(@"selectedWineTypes:%@",selectedWineTypes);

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return [filterWineTypes count];
    }
    else
    {
        return [filterCountries count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return NSLocalizedString(@"商品排序", nil) ;
            break;
        case 2:
            return NSLocalizedString(@"酒類選擇", nil);
            break;
        case 3:
            return NSLocalizedString(@"產地", nil);
            break;
        default:
            return NSLocalizedString(@"", nil);
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* CellIdentifier = @"FilterTableViewCell";
    FilterTableViewCell* cell;
    cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        if (!self.CellNib)
        {
            self.CellNib = [UINib nibWithNibName:@"FilterTableViewCell" bundle:nil];
            
        }
        NSArray* bundleObjects = [self.CellNib instantiateWithOwner:self options:nil];
        cell = [bundleObjects objectAtIndex:0];
    }
    if (indexPath.section == 0)
    {
        cell.cellButton.tag = 0;
        if ([selectedCountries count] == [filterCountries count] && [selectedWineTypes count] == [filterWineTypes count])
        {
            cell.cellButton.selected = YES;
        }
        else
        {
            cell.cellButton.selected = NO;
        }
        cell.itemLabel.text = NSLocalizedString(@"瀏覽全部商品", nil);
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.cellButton.tag = 1;
            if ([orderBy isEqualToString:@"wine_type_id"])
            {
                cell.cellButton.selected = YES;
            }
            else
            {
                cell.cellButton.selected = NO;
            }
            cell.itemLabel.text = NSLocalizedString(@"依酒類排序", nil);
        }
        else if (indexPath.row == 1)
        {
            cell.cellButton.tag = 2;
            if ([orderBy isEqualToString:@"wine_type_id"])
            {
                cell.cellButton.selected = NO;
            }
            else
            {
                if ([order isEqualToString:@"ASC"])
                {
                    cell.cellButton.selected = NO;
                }
                else
                {
                    cell.cellButton.selected = YES;
                }
            }
            cell.itemLabel.text = NSLocalizedString(@"價格由高至低排序", nil);
            
        }
        else
        {
            cell.cellButton.tag = 3;
            if ([orderBy isEqualToString:@"wine_type_id"])
            {
                cell.cellButton.selected = NO;
            }
            else
            {
                if ([order isEqualToString:@"ASC"])
                {
                    cell.cellButton.selected = YES;
                }
                else
                {
                    cell.cellButton.selected = NO;
                }
            }
            cell.itemLabel.text = NSLocalizedString(@"價格由低至高排序", nil);
        }
        
    }
    else if (indexPath.section == 2)
    {
        NSString *wineTypeID = [[filterWineTypes objectAtIndex:indexPath.row] valueForKey:@"id"];
        cell.cellButton.tag = [wineTypeID intValue];
        
        if ([selectedWineTypes containsObject:wineTypeID])
        {
            cell.cellButton.selected = YES;
        }
        else
        {
            cell.cellButton.selected = NO;
        }
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"en"])
        {
            cell.itemLabel.text =[[filterWineTypes objectAtIndex:indexPath.row] valueForKey:@"name_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            cell.itemLabel.text =[[filterWineTypes objectAtIndex:indexPath.row] valueForKey:@"name_cn"];
        }
        else
        {
            cell.itemLabel.text =[[filterWineTypes objectAtIndex:indexPath.row] valueForKey:@"name_tw"];
        }

    }
    else
    {
        NSString *countryID = [[filterCountries objectAtIndex:indexPath.row] valueForKey:@"id"];
        cell.cellButton.tag = [countryID intValue];
        
        if ([selectedCountries containsObject:countryID])
        {
            cell.cellButton.selected = YES;
        }
        else
        {
            cell.cellButton.selected = NO;
        }
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"en"])
        {
            cell.itemLabel.text =[[filterCountries objectAtIndex:indexPath.row] valueForKey:@"name_en"];
        }
        else if ([language isEqualToString:@"zh-Hans"])
        {
            cell.itemLabel.text =[[filterCountries objectAtIndex:indexPath.row] valueForKey:@"name_cn"];
        }
        else
        {
            cell.itemLabel.text =[[filterCountries objectAtIndex:indexPath.row] valueForKey:@"name_tw"];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FilterTableViewCell* cell = (FilterTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        if ([selectedCountries count]==[filterCountries count] && [selectedWineTypes count]==[filterWineTypes count])
        {
            [selectedCountries removeAllObjects];
            [selectedWineTypes removeAllObjects];
        }
        else
        {
            [self selectAllWineTypesAndAllCountries];
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            orderBy = @"wine_type_id";
            order = @"ASC";
        }
        else if(indexPath.row == 1)
        {
            orderBy = @"price";
            order = @"DESC";
        }
        else
        {
            orderBy = @"price";
            order = @"ASC";
        }
    }
    else if (indexPath.section == 2)
    {
        NSString *wineTypeID = [[filterWineTypes objectAtIndex:indexPath.row] valueForKey:@"id"];
        if ([selectedWineTypes containsObject:wineTypeID])
        {
            [selectedWineTypes removeObject:wineTypeID];
        }
        else
        {
            [selectedWineTypes addObject:wineTypeID];
        }
    }
    else
    {
        NSString *countryID = [[filterCountries objectAtIndex:indexPath.row] valueForKey:@"id"];
        if ([selectedCountries containsObject:countryID])
        {
            [selectedCountries removeObject:countryID];
        }
        else
        {
            [selectedCountries addObject:countryID];
        }
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmAction:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"filtWithAllOptions"];
    [defaults removeObjectForKey:@"filtOrder"];
    [defaults removeObjectForKey:@"filtWithWineType"];
    [defaults removeObjectForKey:@"filtWithRegion"];

    if ([selectedCountries count] == [filterCountries count] && [selectedWineTypes count] == [filterWineTypes count])
    {
        [defaults setObject:@"selected" forKey:@"filtWithAllOptions"];
    }
    else
    {
        [defaults setObject:@"notSelected" forKey:@"filtWithAllOptions"];
    }
    [defaults setObject:orderBy forKey:@"filtOrderBy"];
    [defaults setObject:order forKey:@"filtOrder"];
    
    NSLog(@"selectedWineTypes:%@",selectedWineTypes);
    if (selectedWineTypes.count != 0)
    {
        NSString* wineTypeIDs = [selectedWineTypes componentsJoinedByString:@","];
        NSLog(@"wineTypeIDs:%@",wineTypeIDs);

        [defaults setObject:wineTypeIDs forKey:@"filtWithWineType"];
    }
  
    if (selectedCountries.count != 0)
    {
        NSString* regionTypeIDs = [selectedCountries componentsJoinedByString:@","];
        [defaults setObject:regionTypeIDs forKey:@"filtWithRegion"];
    }
    
    [defaults setObject:@"on" forKey:@"filterSwitch"];
    [defaults setObject:@"on" forKey:@"filtFirstTime"];
    [defaults setObject:selectedWineTypes forKey:@"previousSelectedWineTypes"];
    [defaults setObject:selectedCountries forKey:@"previousSelectedCountries"];
    [defaults setObject:orderBy forKey:@"previousOrderBy"];
    [defaults setObject:order forKey:@"previousOrder"];
    [defaults synchronize];
    NSLog(@"defaults:%@",[defaults dictionaryRepresentation]);
    
    if (selectedWineTypes.count == 0)
    {
        self.alertView.hidden = NO;
        self.alertLabel.text = NSLocalizedString(@"請至少選擇一種酒類", nil);
        self.alertView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.alertView.bounds
                                         byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(5.0f, 5.0f)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.alertView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.alertView.layer.mask = maskLayer;
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(removeNotification:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else if (selectedCountries.count == 0)
    {
        self.alertView.hidden = NO;
        self.alertLabel.text = NSLocalizedString(@"請至少選擇一個產地", nil);
        self.alertView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.alertView.bounds
                                         byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(5.0f, 5.0f)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.alertView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.alertView.layer.mask = maskLayer;
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(removeNotification:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)removeNotification:(id)sender
{
    self.alertView.hidden = YES;
}
@end
