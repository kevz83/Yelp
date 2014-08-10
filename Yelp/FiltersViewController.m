//
//  FiltersViewController.m
//  Yelp
//
//  Created by Kevin Shah on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "Filters.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *expanded;
@property (nonatomic, strong) NSMutableDictionary *selections;

//@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.expanded = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    [self navigationBarConstruction];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
   // self.selections = [defaults objectForKey:@"selections"];
    NSData *data = [defaults objectForKey:@"selections"];
    self.selections = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(!self.selections)
        self.selections = [NSMutableDictionary dictionary];

    [self.tableView reloadData];
}

- (void)navigationBarConstruction
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor redColor];
    navBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButton:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 20, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Filters";
    navBar.topItem.titleView = titleLabel;
}

- (void)cancelButton:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchButton:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.selections];
    [defaults setObject:data forKey:@"selections"];
    
   // [defaults setObject:self.selections forKey:@"selections"];
    [defaults synchronize];
    
    [self.delegate filtersSearch:self.selections];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [Filters filters].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *rowDictionary = [Filters filters][section];
    
    if([rowDictionary[@"type"]  isEqual: @"single"] )
    {
        return [self.expanded[@(section)] boolValue] ? ((NSArray *)rowDictionary[@"values"]).count : 1;
    }
    else
    {
        if([rowDictionary[@"type"] isEqual: @"multiple"] &&
           !self.expanded[@(section)])
        {
            return 4;
        }
        
        return ((NSArray *)rowDictionary[@"values"]).count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary *rowDictionary = [Filters filters][indexPath.section];
    NSString *internalTitle = rowDictionary[@"internal_title"];
    
    BOOL isExpanded = [self.expanded[@(indexPath.section)] boolValue ];
    
    if(rowDictionary[@"master_title"])
    {
        UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switch1 addTarget:self action:@selector(switched:) forControlEvents:(UIControlEventValueChanged)];
        
        NSString *filterKey = rowDictionary[@"values"][0][@"internal_title"];
        
        [switch1 setOn:[self.selections[filterKey] boolValue] animated:YES];
        
        cell.accessoryView = switch1;
        cell.textLabel.text = rowDictionary[@"values"][0][@"title"];
    }
    else
    {
        if([rowDictionary[@"type"] isEqualToString:@"single"])
        {
            
            NSString *selection = self.selections[internalTitle][@"display_name"];
            
            if(!isExpanded && selection)
            {
                cell.textLabel.text = selection;
            }
            else
            {
                NSString *cellValue = rowDictionary[@"values"][indexPath.row][@"display_name"];
                
                if([cellValue isEqualToString:selection])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                cell.textLabel.text = cellValue;
            }
        }
        else if([rowDictionary[@"type"] isEqualToString:@"multiple"])
        {
            if(!isExpanded && indexPath.row == 3)
            {
        
                cell.textLabel.text =  @"See All";
            }
            else
            {
                NSMutableArray *selectionArray = self.selections[internalTitle];
                NSString *cellValue = rowDictionary[@"values"][indexPath.row][@"internal_name"];
                
                if([self arrayMatch:selectionArray forString:cellValue])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                cell.textLabel.text =  rowDictionary[@"values"][indexPath.row][@"display_name"];
            }
        }
        else
        {
            cell.textLabel.text =  rowDictionary[@"values"][indexPath.row][@"display_name"];
        }
    }

    return cell;
}

- (BOOL)arrayMatch:(NSMutableArray *)array forString:(NSString *)selection
{
    for(NSMutableDictionary *dict in array)
    {
        NSString *localValue = dict[@"internal_name"];
        
        if([selection isEqualToString:localValue])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)switched:(id)sender
{
    if([sender isOn])
    {
        self.selections[@"deals_filter"] = @"1";
    }
    else
    {
        self.selections[@"deals_filter"] = @"0";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *rowDictionary = [Filters filters][section];
    
    if(rowDictionary[@"master_title"])
    {
        return rowDictionary[@"master_title"];
    }
    else
    {
        return rowDictionary[@"title"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *filter = [Filters filters];
    NSMutableArray *values = filter[indexPath.section][@"values"];
    
    BOOL isExpanded = [self.expanded[@(indexPath.section)] boolValue];
    
    if([filter[indexPath.section][@"type"]  isEqual: @"single"])
    {
        if(isExpanded)
        {
            self.selections[filter[indexPath.section][@"internal_title"]] = values[indexPath.row];
        }
        
        self.expanded[@(indexPath.section)] = @(![self.expanded[@(indexPath.section)] boolValue]);
    }
    
    if([filter[indexPath.section][@"type"] isEqual: @"multiple"])
    {
        if(isExpanded)
        {
            NSMutableArray *result =  self.selections[filter[indexPath.section][@"internal_title"]];
            if(!result)
            {
                result = [[NSMutableArray alloc] init];
                self.selections[filter[indexPath.section][@"internal_title"]] = result;
            }
            
            NSString *cellValue = values[indexPath.row][@"internal_name"];
            if([self arrayMatch:result forString:cellValue])
            {
                [result removeObject:values[indexPath.row]];
            }
            else
            {
                [result addObject:values[indexPath.row]];
            }
        }
        self.expanded[@(indexPath.section)] = @YES;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    
    return headerView;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


@end
