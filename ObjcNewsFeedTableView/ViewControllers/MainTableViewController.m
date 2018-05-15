//
//  MainTableTableViewController.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#define kNewsFeedURL @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

#import "MainTableViewController.h"
#import "NewsBuilder.h"
#import "NewsTableViewCell.h"
#import "News.h"
#import "Hudloading.h"

@interface MainTableViewController ()
@property(nonatomic,strong)NSArray * newsFeed;
@property(nonatomic,strong)UIRefreshControl * refreshControl;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Set up the TableView
    self.newsTable = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    _newsTable.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _newsTable.delegate = self;
    _newsTable.dataSource = self;
    
    [self.view addSubview:_newsTable];
    
    //Refresh Button
    UIBarButtonItem * button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTheData)];
    self.navigationItem.leftBarButtonItem = button;
    
    //Add the refresh Control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTheData) forControlEvents:UIControlEventValueChanged];
    [self.newsTable addSubview:self.refreshControl];
    
    //Call the makeRequest to request the data
    [self makeDataRequests];
}

-(void)refreshTheData{
    //Initialize the hudloading view
    
    Hudloading * hudloading
    = [Hudloading hudloadingInView:[self.view.window.subviews objectAtIndex:0]];
    //Make dataRequest
    [self makeDataRequests];
    [self.refreshControl endRefreshing];
    // update tableview
    [self.newsTable performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
    //Remove hudloading from superView
    [hudloading
     performSelector:@selector(removeView)
     withObject:nil
     afterDelay:1.0];
}

-(void)makeDataRequests{
    
    NSError * error;
    //Grab the string handle
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:kNewsFeedURL]encoding:NSISOLatin1StringEncoding error:&error];
    
    //Get the NSData from the string
    NSData *retrievedData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //Get the jsonObject
    id jsonObject = [NSJSONSerialization JSONObjectWithData:retrievedData options:kNilOptions error:&error];
    
    if(error){
        //Error Handling
        //Show the alertController
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error Alert"  message:error.localizedDescription  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        //Parse the jsonObject and create an array and store the dictionary
        self.title = [jsonObject objectForKey:@"title"];
        self.newsFeed = [NewsBuilder newsFromJSON:jsonObject];
    }
    
    [self.newsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsFeed count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * CellIdentifier = @"NewsCell";
    NewsTableViewCell * cell = nil;
    cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc]initWithReuseIdentifier:CellIdentifier];
    }
    
    News * news = _newsFeed[indexPath.row];
    cell.news = news;
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsTableViewCell minimumHeight];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    News * news = self.newsFeed[indexPath.row];
    
    CGFloat calculatedHeight = 0;
    
    calculatedHeight = [NewsTableViewCell heightForNews:news constrainedToWidth:CGRectGetWidth(self.newsTable.bounds)];
    
    return calculatedHeight;
}



@end
