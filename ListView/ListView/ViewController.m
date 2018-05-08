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

@property (nonatomic, strong) NSArray *tableItems;

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
                // pass the img to your imageview
                cell.itemImageView.image = img;
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
-(void)fetchDetails {
    typeof(self) weakSelf = self;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:APIPath]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               
                               NSString *iso = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                               NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
                               
                               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dutf8
                                                                                    options:0
                                                                                      error:&error];
                               if (json != nil) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [weakSelf updateDetail:json];
                                   });
                                   
                               } else {
                                   NSLog(@"error: %@", error);
                               }
                           }];
}

-(void)updateDetail:(NSDictionary *)details {
    
    if ([details objectForKey:@"title"]) {
        self.naviBar.topItem.title = [details objectForKey:@"title"];
    }
    
    if ([details objectForKey:@"rows"]) {
        self.tableItems = [details objectForKey:@"rows"];
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
