//
//  WTRegionViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTRegionViewController.h"
#import "WTLocationManager.h"
#import "WTDataDef.h"

@interface WTRegionViewController ()

@property (strong, nonatomic) NSMutableArray *displayRegions;
@property (copy, nonatomic) NSString *gpsRegion;
@property (strong, nonatomic) IBOutlet UITableView *regionTableView;

@end

@implementation WTRegionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _displayRegions = [NSMutableArray array];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRegion:) name:Region_Update_Notification object:nil];
    
    self.gpsRegion = [[WTLocationManager sharedInstance] gpsRegion];
    self.gpsRegion = self.gpsRegion ? self.gpsRegion : @"GPS追跡中...";
    [self.displayRegions addObject: self.gpsRegion];
    NSArray *regions = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region_area.plist" ofType:nil]];
    [regions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.displayRegions addObject:obj[@"Prefecture"]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Region_Update_Notification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayRegions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RegionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"現在地：%@", self.gpsRegion];
    } else {
        cell.textLabel.text = self.displayRegions[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[WTLocationManager sharedInstance] updateRegion:self.displayRegions[indexPath.row]];
//    [[WTLocationManager sharedInstance] saveLocation];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRegion:)]) {
        [self.delegate didSelectRegion:self.displayRegions[indexPath.row]];
    }
     
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification

- (void)updateRegion:(NSNotification *)aNotification
{
    self.gpsRegion = aNotification.object;
    [self.regionTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}



@end
