//
//  ResultTableViewController.m
//  Hello
//
//  Created by Talha Ansari on 5/9/14.
//  Copyright (c) 2014 Jingwei Zhang. All rights reserved.
//

#import "ResultTableViewController.h"
#import "SpecieViewController.h"

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
    

    
//    NSFileManager *filemgr;
//    NSString *documentsPath;
//    
//    filemgr = [[NSFileManager alloc] init];
//    documentsPath = [filemgr currentDirectoryPath];
//    //documentsPath = [documentsPath stringByAppendingPathComponent:@""];
//    
//    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath
//                                                                        error:NULL];
//    NSLog(@"%@",documentsPath);
//    NSLog(@"Num files: %d",[dirs count]);
//    NSString *test = [dirs objectAtIndex:4];
//    NSLog(@"test %@", test);
//    
//    NSURL *containingURL = [[NSBundle mainBundle] resourceURL];
//    NSURL *imageURL = [containingURL URLByAppendingPathComponent:@"Images" isDirectory:YES];
//    NSFileManager *localFileManager = [[NSFileManager alloc] init];
//    NSArray *content = [localFileManager contentsOfDirectoryAtURL:imageURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:NULL];
//    NSUInteger imageCount = [content count];
//    NSLog(@"test2 %d", imageCount);
//    cell.imageView.image = [UIImage imageNamed:imageName];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",value];
    
    UIImage *thumbnail = [UIImage imageNamed:imageName];
    if (thumbnail == nil) {
        thumbnail = [UIImage imageNamed:@"logo_5.png"] ;
    }
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [thumbnail drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = valueAsString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showSpecie" sender:indexPath];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue2....");
    if ([segue.identifier isEqualToString:@"showSpecie"]) {
        NSLog(@"prepareForSegue2: identifier found..");
        SpecieViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = sender;
        NSString *key = [NSString stringWithFormat:@"%d",(indexPath.row)];
        NSLog(@"%@",key);
        NSString *value = [self.res valueForKey:key];
        NSLog(@"%@",value);
        //NSString *valueAsString = [NSString stringWithFormat:@"%d. %@",indexPath.row+1, value];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",value];
        UIImage *thumbnail = [UIImage imageNamed:imageName];
        if (thumbnail == nil) {
            thumbnail = [UIImage imageNamed:@"logo_5.png"] ;
        }
        detailViewController.image = thumbnail;
    }
}

@end
