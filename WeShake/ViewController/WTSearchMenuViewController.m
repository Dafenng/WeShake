//
//  WTSearchMenuViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchMenuViewController.h"

#define kMASTERTABLEVIEWTAG 1001
#define kSUBTABLEVIEWTAG 2002

@interface WTSearchMenuViewController ()
{
    NSArray *_locationArr;
    NSArray *_cuisineArr;
    NSArray *_budgetArr;
}

@property (strong, nonatomic) UITableView *masterTableView;
@property (strong, nonatomic) UITableView *subTableView;

@end

@implementation WTSearchMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    _locationArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
    _cuisineArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShopTypesAndCuisineTypes.plist" ofType:nil]];
    _budgetArr = @[@"50", @"100", @"150", @"200"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (self.menuType == SHOP_MENU_BUDGET) {
        self.masterTableView.hidden = YES;
        [self.subTableView reloadData];
    } else {
        self.masterTableView.hidden = NO;
        [self.masterTableView reloadData];
        [self.subTableView reloadData];
    }
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
            return [_locationArr count];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            return [_cuisineArr count];
        }
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            NSInteger index = [self.masterTableView indexPathForSelectedRow].row;
            NSDictionary *locDic = [_locationArr objectAtIndex:index];
            NSArray *cities = [locDic objectForKey:@"Cities"];
            return [cities count];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            NSInteger index = [self.masterTableView indexPathForSelectedRow].row;
            NSDictionary *cuiDic = [_cuisineArr objectAtIndex:index];
            NSArray *cuis = [cuiDic objectForKey:@"CuisineTypes"];
            return [cuis count];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            return [_budgetArr count];
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
            NSDictionary *stateDic = [_locationArr objectAtIndex:indexPath.row];
            cell.textLabel.text = [stateDic objectForKey:@"State"];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            NSDictionary *shopDic = [_cuisineArr objectAtIndex:indexPath.row];
            cell.textLabel.text = [shopDic objectForKey:@"ShopType"];
        }
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            NSDictionary *stateDic = [_locationArr objectAtIndex:[self.masterTableView indexPathForSelectedRow].row];
            NSArray *cities = [stateDic objectForKey:@"Cities"];
            NSDictionary *cityDic = [cities objectAtIndex:indexPath.row];
            cell.textLabel.text = [cityDic objectForKey:@"city"];
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            NSDictionary *shopDic = [_cuisineArr objectAtIndex:[self.masterTableView indexPathForSelectedRow].row];
            NSArray *shops = [shopDic objectForKey:@"CuisineTypes"];
            NSDictionary *cuiDic = [shops objectAtIndex:indexPath.row];
            cell.textLabel.text = [cuiDic objectForKey:@"cuisineType"];
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            cell.textLabel.text = [_budgetArr objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMASTERTABLEVIEWTAG) {
        [self.subTableView reloadData];
    } else if (tableView.tag == kSUBTABLEVIEWTAG) {
        if (self.menuType == SHOP_MENU_LOCATION) {
            NSDictionary *stateDic = [_locationArr objectAtIndex:[self.masterTableView indexPathForSelectedRow].row];
            NSArray *cities = [stateDic objectForKey:@"Cities"];
            NSDictionary *cityDic = [cities objectAtIndex:indexPath.row];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionWithLatitude:longitude:)]) {
                [self.delegate didSelectNewSearchConditionWithLatitude:[(NSNumber *)[cityDic objectForKey:@"lat"] doubleValue] longitude:[(NSNumber *)[cityDic objectForKey:@"lon"] doubleValue]];
            }
        } else if (self.menuType == SHOP_MENU_CUISINE) {
            //TODO:暂未实现类型搜索
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionNotImplemented)]) {
                [self.delegate didSelectNewSearchConditionNotImplemented];
            }
        } else if (self.menuType == SHOP_MENU_BUDGET) {
            //TODO:暂未实现预算搜索
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectNewSearchConditionNotImplemented)]) {
                [self.delegate didSelectNewSearchConditionNotImplemented];
            }
        }
    }
}

@end
