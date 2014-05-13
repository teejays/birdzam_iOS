//
//  ResultTableViewController.m
//  Hello
//
//  Created by Talha Ansari on 5/9/14.
//  Copyright (c) 2014 Jingwei Zhang. All rights reserved.
//

#import "ResultTableViewController.h"

@interface ResultTableViewController ()

@end

@implementation ResultTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _species = [_res allKeys];
    _prob = [_res allValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    NSLog(@"numberOfSectionsInTableView");
//    return [self.res count];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"titleForHeaderInSection");
//    return [[self.res allKeys] objectAtIndex:section];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
    //    NSString *rank = [self tableView:tableView titleForHeaderInSection:section];
    //    return [[self.res valueForKey:rank] count];
    NSInteger numRows = [_res count];
    NSString *numRowsString = [NSString stringWithFormat:@"%d",numRows];
    NSLog(@"%@",numRowsString);
    return numRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"something" forIndexPath:indexPath];
    
    // Configure the cell...
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"specieCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *key = [NSString stringWithFormat:@"%d",(indexPath.row)];
    NSLog(@"%@",key);
    NSString *value = [self.res valueForKey:key];
    NSString *valueAsString = [NSString stringWithFormat:@"%d. %@",indexPath.row+1, value];
    //NSLog(@"%@",valueAsString);
    
//    NSString *p1 = [_species objectAtIndex:indexPath.row];
//    //NSString *p2 = [_prob objectAtIndex:indexPath.row]; // For displaying the probabilities
//    NSString *valueAsString = [NSString stringWithFormat:@"%d. %@",indexPath.row+1, p1];
//    NSLog(@"%@",valueAsString);
    cell.imageView.image = [UIImage imageNamed:@"logo_5.png"];
    cell.textLabel.text = valueAsString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
