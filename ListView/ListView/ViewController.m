//
//  ViewController.m
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ViewController.h"

// NSObject
#import "NetworkManager.h"
#import "ItemModel.h"

// View
#import "ItemTableViewCell.h"

static NSString *cellIdentifier = @"ItemTableViewCell";

@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set spinner
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity startAnimating];
    [self.activity hidesWhenStopped];
    [self.activity setColor:[UIColor redColor]];
    self.activity.center = self.view.center;
    [self.view addSubview:self.activity];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addTableView];
    if (self.tableItems == nil) {
        [self fetchDetails];
    }
}

#pragma mark - UI setup
-(void)addTableView {
    
    // init table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // add clear bg color for spinner visible
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    NSDictionary *views = @{@"tableView":self.tableView};

    // tableviw auto layout
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[tableView]|" options:0 metrics:nil views:views]];
    
    // dynamic height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = nil;
    
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

    [cell setDetails:[self.tableItems objectAtIndex:indexPath.row]];
    
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
        // add white bg color for tableview display
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
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
    
    if ([details objectForKey:@"title"]) {
        self.title = [details objectForKey:@"title"];
    }
    
    if (self.tableItems == nil) {
        self.tableItems = [NSMutableArray array];
    }
    
    if ([details objectForKey:@"rows"]) {
        self.tableItems = nil;
        self.tableItems = [ItemModel getModelArrayFromJson:[details objectForKey:@"rows"]];
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
