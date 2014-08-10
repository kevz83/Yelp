//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "FiltersViewController.h"
#import "Filters.h"
#import <CoreLocation/CoreLocation.h>
#import <Mantle.h>
#import "Place.h"
#import "MapViewController.h"
#import "ListViewCell.h"
#import "UIImageView+AFNetworking.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *responseObj;

//@property (nonatomic, strong) ListViewCell *stubCell;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        self.responseObj = [[NSMutableArray alloc]init];
        
       /* [self.client searchWithTerm:@"Indian" success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self navigationBarConstruction];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
     [self.tableView registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:@"ListViewCell"];
    
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)navigationBarConstruction
{
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor redColor];
    navBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(setFilter:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(maps:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.responseObj.count == 0)
    {
        return 1;
    }

    return self.responseObj.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ListViewCell"];
    
    if(self.responseObj.count > 0)
    {
        Place *currentPlace = self.responseObj[indexPath.row];
        
        listCell.name.text = currentPlace.name;
        listCell.address.text = currentPlace.address;
        listCell.tags.text = currentPlace.categories;
        listCell.count.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1 ];
        listCell.distance.text = [NSString stringWithFormat:@"%.02f mi",currentPlace.distance/1609];
        listCell.reviewsCount.text = [NSString stringWithFormat:@"%@ reviews",currentPlace.reviewCount];
        [listCell.placeImage setImageWithURL:[NSURL URLWithString:currentPlace.photo]];
        [listCell.rating setImageWithURL:[NSURL URLWithString:currentPlace.rating]];
        
        return listCell;
        
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"No matching results found";
        
        return cell;
    }
    
}

/*- (ListViewCell *)stubCell {
    if (!_stubCell) {
        _stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"ListViewCell"];
    }
    return _stubCell;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
 //   CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
 //   return size.height+1;
    
    return 126;
}

- (void)maps:(id)sender
{
    NSString *className = NSStringFromClass([MapViewController class]);
    MapViewController *mapVC = [[MapViewController alloc]initWithNibName:className bundle:nil places:self.responseObj];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)setFilter:(id)sender
{
    FiltersViewController *filterVC = [[FiltersViewController alloc] init];
    
    UINavigationController *filterNavController = [[UINavigationController alloc]initWithRootViewController:filterVC];
    filterVC.delegate = self;
    
    [self presentViewController:filterNavController animated:YES completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

- (void)yelpAPICall:(NSString *)term searchFilters:(NSDictionary *)filters
{
    [self.client searchWithTerm:term searchFilters:filters searchLocation:self.currentLocation
                        success:^(AFHTTPRequestOperation *operation, id response)
    {
        NSLog(@"response: %@", response);
        NSError *error;
        
        [self.responseObj removeAllObjects];
        
        [self.responseObj addObjectsFromArray:[MTLJSONAdapter
                                               modelsOfClass:Place.class
                                               fromJSONArray:response[@"businesses"]
                                               error:&error]];
        
        [self.tableView reloadData];
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
    NSData *data = [defaults objectForKey:@"selections"];
    
    NSMutableDictionary *selections = [NSMutableDictionary dictionary];
    selections = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableDictionary *filters = [Filters processFilterData:selections];
    
    [self yelpAPICall:searchBar.text searchFilters:filters];
    
    
}

- (void)filtersSearch:(NSMutableDictionary *)filters
{
    NSMutableDictionary *searchFilters = [Filters processFilterData:filters];
    
    [self yelpAPICall:self.searchBar.text searchFilters:searchFilters];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
