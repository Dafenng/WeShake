//
//  WTSearchMenuViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchMenuViewController.h"
#import "WTLocationManager.h"

#define kMASTERTABLEVIEWTAG 1001
#define kSUBTABLEVIEWTAG 2002

@interface WTSearchMenuViewController ()

@property (strong, nonatomic) UITableView *masterTableView;
@property (strong, nonatomic) UITableView *subTableView;

@property (strong, nonatomic) NSArray *regions;
@property (strong, nonatomic) NSArray *allAreas;
@property (strong, nonatomic) NSMutableArray *areas;
@property (strong, nonatomic) NSMutableArray *districts;

@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSMutableArray *cuisines;

@property (strong, nonatomic) NSArray *periods;
@property (strong, nonatomic) NSMutableArray *budgets;

@property (copy, nonatomic) NSString *tmpArea;
@property (copy, nonatomic) NSString *tmpGenre;
@property (copy, nonatomic) NSString *tmpPeriod;

@end

@implementation WTSearchMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _region = [[WTLocationManager sharedInstance] region];
        _area = @"All";
        if ([[WTLocationManager sharedInstance] regionIsGPSRegion]) {
            _area = @"Around";
        }
        
        _district = @"1000";
        
        _genre = @"All";
        _cuisine = @"";
        
        _period = @"All";
        _budget = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    self.masterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 300) style:UITableViewStylePlain];
//    self.masterTableView.backgroundColor = [UIColor yellowColor];
    self.subTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width, 300) style:UITableViewStylePlain];
//    self.subTableView.backgroundColor = [UIColor greenColor];
    self.masterTableView.tag = kMASTERTABLEVIEWTAG;
    self.subTableView.tag = kSUBTABLEVIEWTAG;
    self.masterTableView.dataSource = self;
    self.masterTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.subTableView.delegate = self;
    [self.view addSubview:self.masterTableView];
    [self.view addSubview:self.subTableView];
    
    self.regions = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region_area.plist" ofType:nil]];
    self.allAreas = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area_district.plist" ofType:nil]];
    self.genres = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"genre_cuisine.plist" ofType:nil]];
    self.periods = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"period_budget.plist" ofType:nil]];
    
    self.areas = [NSMutableArray array];
    self.districts = [NSMutableArray array];
    self.cuisines = [NSMutableArray array];
    self.budgets = [NSMutableArray array];
    
    //TODO: Region需要使用地理位置获取
    
    self.tmpArea = self.area;
    self.tmpGenre = self.genre;
    self.tmpPeriod = self.period;
    
    [self getAreasInRegion:self.region];
    [self getDistrictsInArea:self.area];
    [self getCuisinesInGenre:self.genre];
    [self getBudgetsInPeriod:self.period];
}

- (NSDictionary *)areaAroundDict
{
    return @{@"1000m": @"1000",
             @"2000m": @"2000",
             @"3000m": @"3000",
             @"4000m": @"4000",
             @"5000m": @"5000",
             @"6000m": @"6000"
             };
}

- (NSDictionary *)budgetDict
{
    return @{@"~¥1000": @"500",
             @"¥1000~¥2000": @"1500",
             @"¥2000~¥3000": @"2500",
             @"¥3000~¥4000": @"3500",
             @"¥4000~¥5000": @"4500",
             @"¥5000~¥6000": @"5500",
             @"¥6000~¥7000": @"6500",
             @"¥7000~¥8000": @"7500",
             @"¥8000~¥9000": @"8500",
             @"¥9000~¥10000": @"9500",
             @"¥10000~": @"10500"
             };
}

- (void)getAreasInRegion:(NSString *)region
{
    __block NSArray *areasArr;
    [self.regions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"Prefecture"] isEqualToString:region]) {
            areasArr = [obj objectForKey:@"Areas"];
            *stop = YES;
        }
    }];
    
    [self.areas removeAllObjects];
    [self.areas addObjectsFromArray:areasArr];
}

- (void)getDistrictsInArea:(NSString *)area
{
    __block NSArray *districtsArr;
    [self.allAreas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"Area"] isEqualToString:area]) {
            districtsArr = [obj objectForKey:@"Districts"];
            *stop = YES;
        }
    }];
    
    [self.districts removeAllObjects];
    [self.districts addObjectsFromArray:districtsArr];
}

- (void)getCuisinesInGenre:(NSString *)genre
{
    __block NSArray *cuisinesArr;
    [self.genres enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"Genre"] isEqualToString:genre]) {
            cuisinesArr = [obj objectForKey:@"Cuisines"];
            *stop = YES;
        }
    }];
    
    [self.cuisines removeAllObjects];
    [self.cuisines addObjectsFromArray:cuisinesArr];
}

- (void)getBudgetsInPeriod:(NSString *)period
{
    __block NSArray *budgetsArr;
    [self.periods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"Period"] isEqualToString:period]) {
            budgetsArr = [obj objectForKey:@"Budget"];
            *stop = YES;
        }
    }];
    
    [self.budgets removeAllObjects];
    [self.budgets addObjectsFromArray:budgetsArr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [self.masterTableView reloadData];
    [self.subTableView reloadData];
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
    if (tableView.tag == kMASTERTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            return [self.areas count];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            return [self.genres count];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            return [self.periods count];
        }
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            return [self.districts count];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            return [self.cuisines count];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            return [self.budgets count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView.tag == kMASTERTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            cell.textLabel.text = ((NSDictionary *)self.areas[indexPath.row])[@"area"];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            cell.textLabel.text =  ((NSDictionary *)self.genres[indexPath.row])[@"Genre"];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            cell.textLabel.text =  ((NSDictionary *)self.periods[indexPath.row])[@"Period"];
        }
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            cell.textLabel.text =  ((NSDictionary *)self.districts[indexPath.row])[@"district"];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            cell.textLabel.text =  ((NSDictionary *)self.cuisines[indexPath.row])[@"cuisine"];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            cell.textLabel.text =  self.budgets[indexPath.row];
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMASTERTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            self.tmpArea = ((NSDictionary *)self.areas[indexPath.row])[@"area"];
            [self getDistrictsInArea:self.tmpArea];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            self.tmpGenre = ((NSDictionary *)self.genres[indexPath.row])[@"Genre"];
            [self getCuisinesInGenre:self.tmpGenre];
            if (indexPath.row == 0) {
                self.genre = self.tmpGenre;
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithRegion:area:district:genre:cuisine:period:budget:)]) {
                    [self.delegate didSelectNewSearchConditionWithRegion:self.region area:self.area district:self.district genre:self.genre cuisine:self.cuisine period:self.period budget:self.budget];
                }
            }
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            self.tmpPeriod = ((NSDictionary *)self.periods[indexPath.row])[@"Period"];
            [self getBudgetsInPeriod:self.tmpPeriod];
            if (indexPath.row == 0) {
                self.period = self.tmpPeriod;
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithRegion:area:district:genre:cuisine:period:budget:)]) {
                    [self.delegate didSelectNewSearchConditionWithRegion:self.region area:self.area district:self.district genre:self.genre cuisine:self.cuisine period:self.period budget:self.budget];
                }
            }
        }
        [self.subTableView reloadData];
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            self.area = self.tmpArea;
            if ([self.area isEqualToString:@"Around"]) {
                self.district = [self areaAroundDict][((NSDictionary *)self.districts[indexPath.row])[@"district"]];
            } else {
                self.district = ((NSDictionary *)self.districts[indexPath.row])[@"district"];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithRegion:area:district:genre:cuisine:period:budget:)]) {
                [self.delegate didSelectNewSearchConditionWithRegion:self.region area:self.area district:self.district genre:self.genre cuisine:self.cuisine period:self.period budget:self.budget];
            }
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            self.genre = self.tmpGenre;
            self.cuisine = ((NSDictionary *)self.cuisines[indexPath.row])[@"cuisine"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithRegion:area:district:genre:cuisine:period:budget:)]) {
                [self.delegate didSelectNewSearchConditionWithRegion:self.region area:self.area district:self.district genre:self.genre cuisine:self.cuisine period:self.period budget:self.budget];
            }
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            self.period = self.tmpPeriod;
            self.budget = [self budgetDict][self.budgets[indexPath.row]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithRegion:area:district:genre:cuisine:period:budget:)]) {
                [self.delegate didSelectNewSearchConditionWithRegion:self.region area:self.area district:self.district genre:self.genre cuisine:self.cuisine period:self.period budget:self.budget];
            }
        }
    }
}

@end
