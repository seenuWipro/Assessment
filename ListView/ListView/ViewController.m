//
//  ViewController.m
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "ItemTableViewCell.h"

static NSString *cellIdentifier = @"ItemTableViewCell";

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // dynamic height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = nil;
    
    // pull down refresh
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tableItems == nil) {
        [self fetchDetails];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = (ItemTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.titleLabel.text = @"";
    cell.descriptionLabel.text = @"";
    cell.itemImageView.image = nil;

    NSDictionary *dict = [self.tableItems objectAtIndex:indexPath.row];
    
    if ([dict objectForKey:@"title"] && [dict objectForKey:@"title"] != [NSNull null]) {
        cell.titleLabel.text = [dict objectForKey:@"title"];
    }
    
    if ([dict objectForKey:@"description"] && [dict objectForKey:@"description"] != [NSNull null]) {
        cell.descriptionLabel.text = [dict objectForKey:@"description"];
    }
    
    if ([dict objectForKey:@"imageHref"] && [dict objectForKey:@"imageHref"] != [NSNull null]) {
        NSString *strImgURLAsString = [dict objectForKey:@"imageHref"];
        [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
        [cell setImageFromURL:imgURL];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}

#pragma mark - Fetch details

- (void)refreshTable {
    [self.tableItems removeAllObjects];
    [self.tableView reloadData];
    [self fetchDetails];
}

-(void)fetchDetails {
    typeof(self) weakSelf = self;
    
    [NetworkManager fetchDetails:^(NSDictionary *result, NSError *error) {
        [weakSelf.activity stopAnimating];
        [[weakSelf tableView] reloadData];
        [[weakSelf refreshControl] performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
        
        if (result != nil) {
            [weakSelf updateDetail:result];
        } else {
            
            NSString *title = @"Error";
            NSString *message = @"Something went wrong. Please try again";

            if ([UIAlertController class]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
        }
    }];
}

-(void)updateDetail:(NSDictionary *)details {
    
    if (self.tableItems == nil) {
        self.tableItems = [NSMutableArray array];
    }
    
    if ([details objectForKey:@"title"]) {
        self.naviBar.topItem.title = [details objectForKey:@"title"];
    }
    
    if ([details objectForKey:@"rows"]) {
        for (NSDictionary *dict in [details objectForKey:@"rows"]) {
            if ([dict objectForKey:@"title"] != [NSNull null] || [dict objectForKey:@"description"] != [NSNull null] || [dict objectForKey:@"imageHref"] != [NSNull null]) {
                [self.tableItems addObject:dict];
            }
        }
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
