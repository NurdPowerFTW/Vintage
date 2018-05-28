//
//  SearchViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableButtonCell.h"
#import "SearchTableLabelCell.h"
@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputView.layer.cornerRadius = 18;
    self.inputView.layer.masksToBounds = YES;
    self.defaults =[[NSUserDefaults alloc]init];
    [self.defaults removeObjectForKey:@"searchString"];
    [self.defaults setObject:@"off" forKey:@"searchFirstTime"];
    [self.defaults synchronize];
    NSLog(@"searchHistory:%@",[self.defaults objectForKey:@"searchHistory"]);
    if ([self.defaults objectForKey:@"searchHistory"] )
    {
        self.searchItemArray = [[NSMutableArray alloc]initWithArray:[self.defaults objectForKey:@"searchHistory"]];
    }
    else
    {
        self.searchItemArray = [[NSMutableArray alloc]init];
    }
    self.inputField.delegate = self;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"input:%@",self.inputField.text);
    //[textField resignFirstResponder];
    if(![self.inputField.text isEqualToString:@""])
    {
        if (![self.searchItemArray containsObject:self.inputField.text])
        {
            self.searchItemArray = [[[self.searchItemArray reverseObjectEnumerator]allObjects]mutableCopy];
            [self.searchItemArray addObject:self.inputField.text];
            self.searchItemArray = [[[self.searchItemArray reverseObjectEnumerator]allObjects]mutableCopy];
        }
        
        [self.defaults setObject:self.inputField.text forKey:@"searchString"];
        [self.defaults setObject:self.searchItemArray forKey:@"searchHistory"];
        [self.defaults setObject:@"on" forKey:@"searchSwitch"];
        [self.defaults setObject:@"on" forKey:@"searchFirstTime"];
        [self.defaults synchronize];
        NSLog(@"searchString:%@",[self.defaults objectForKey:@"searchString"]);
        [self.tableView reloadData];
        if ([self.pageIndex isEqualToString:@"0"]) {
            [self performSegueWithIdentifier:@"searchToResult" sender:self];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return NO;
}
- (IBAction)backAction:(id)sender
{
    if ([self.pageIndex isEqualToString:@"0"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)filterAction:(id)sender {
    [self performSegueWithIdentifier:@"searchToFIlter" sender:self];
}
- (IBAction)eraseInputAction:(id)sender {
    self.inputField.text = @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.searchItemArray.count == 0)
        {
            NSLog(@"searchItemArray is empty");
            return 0;
        }
        else
        {
            return self.searchItemArray.count;
        }
    }
    else
    {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height * 0.113;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SearchTableButtonCell* cell;
        static NSString *cellIdentifier = @"SearchTableButtonCell";
        cell = (SearchTableButtonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib)
            {
                self.cellNib = [UINib nibWithNibName:@"SearchTableButtonCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        cell.magIconVIew.hidden = YES;
        if (self.searchItemArray.count!=0)
        {
            cell.magIconVIew.hidden = NO;
            cell.resultTextLabel.text = [self.searchItemArray objectAtIndex:indexPath.row];
        }
        
        
        return cell;
    }
    else
    {
        SearchTableLabelCell* cell;
        static NSString *cellIdentifier = @"SearchTableLabelCell";
        cell = (SearchTableLabelCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            if (!self.cellNib2)
            {
                self.cellNib2 = [UINib nibWithNibName:@"SearchTableLabelCell" bundle:nil];
                
            }
            NSArray* bundleObjects = [self.cellNib2 instantiateWithOwner:self options:nil];
            cell = [bundleObjects objectAtIndex:0];
        }
        if (indexPath.section == 1 && indexPath.row == 0 && self.searchItemArray.count!=0)
            cell.eraseLabel.text = NSLocalizedString(@"清除搜尋歷史紀錄", nil);
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        [self.defaults removeObjectForKey:@"searchHistory"];
        [self.searchItemArray removeAllObjects];
        [self.tableView reloadData];
    }
    else
    {
        [self.defaults setObject:[self.searchItemArray objectAtIndex:indexPath.row] forKey:@"searchString"];
        [self.defaults setObject:@"on" forKey:@"searchSwitch"];
        [self.defaults setObject:@"on" forKey:@"searchFirstTime"];
        [self.defaults synchronize];
        NSLog(@"searchString:%@",[self.defaults objectForKey:@"searchString"]);
        if ([self.pageIndex isEqualToString:@"0"]) {
            [self performSegueWithIdentifier:@"searchToResult" sender:self];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

@end
