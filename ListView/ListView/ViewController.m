//
//  ViewController.m
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ViewController.h"
#import "ItemTableViewCell.h"

static NSString *cellIdentifier = @"ItemTableViewCell";
static NSString *APIPath = @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json";

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UINavigationBar *naviBar;

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
    
    [self fetchDetails];
    
    // pull down refresh
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
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
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                UIImage *img = [[UIImage alloc] initWithData:data];
                // validate for refresh imageview
                if (cell.itemImageView) {
                    cell.itemImageView.image = img;
                }
            }else{
                NSLog(@"%@",connectionError);
            }
        }];
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
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:APIPath]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               
                               NSString *iso = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                               NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
                               
                               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dutf8 options:0 error:&error];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   [weakSelf.refreshControl endRefreshing];

                                   if (json != nil) {
                                       [weakSelf updateDetail:json];
                                       
                                   } else {
                                       NSLog(@"error: %@", error);
                                   }
                               });
                           }];
}

-(void)updateDetail:(NSDictionary *)details {
    
    if ([details objectForKey:@"title"]) {
        self.naviBar.topItem.title = [details objectForKey:@"title"];
    }
    
    self.tableItems = [NSMutableArray array];
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
