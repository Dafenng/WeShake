//
//  WTSearchViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-11.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchViewController.h"
#import "WTSegmentedControl.h"
#import "WTSearchViewCell.h"
#include "WTShopManager.h"
#import "WTShopViewController.h"
#import <objc/runtime.h>

@interface WTSearchViewController () {
    BOOL _isShowingMenu;
    NSInteger _selectedSegmentIndex;
}

@property (weak, nonatomic) IBOutlet UIView *shopMenuCategoryContainer;
@property (weak, nonatomic) IBOutlet WTSegmentedControl *shopMenuSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *shopsTableView;
@property (strong, nonatomic) WTSearchMenuViewController *menuViewController;
@property (strong, nonatomic) NSArray *shopList;

@end

@implementation WTSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shopList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _selectedSegmentIndex = self.shopMenuSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    CGRect frame = self.shopMenuSegmentControl.frame;
    frame.size.height = 28;
    self.shopMenuSegmentControl.frame = frame;
    
    self.menuViewController = [[WTSearchMenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    //TODO:需要改为默认全部shop
    [self getSearchShopsWithConditionOfLatitude:35.690415 longitude:139.700211];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSearchShopsWithConditionOfLatitude:(double)laittude longitude:(double)longitude
{
    [[WTShopManager sharedInstance] getSearchShopsWithConditionOfLatitude:laittude longitude:longitude succsee:^(NSArray *shops) {
        self.shopList = [NSArray arrayWithArray:shops];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.shopList = [NSMutableArray arrayWithArray:[self.shopList sortedArrayUsingDescriptors:sortDescriptors]];
        [self.shopsTableView reloadData];
    } failure:^(NSString *error) {
        NSLog(@"Search error");
    }];
}

- (IBAction)shopMenuSegmentControlValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    if (_selectedSegmentIndex == [segmentedControl selectedSegmentIndex]) {
        _selectedSegmentIndex = self.shopMenuSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    } else {
        _selectedSegmentIndex = self.shopMenuSegmentControl.selectedSegmentIndex;
    }
    
    switch (_selectedSegmentIndex) {
        case SHOP_MENU_LOCATION:
            [self showShopOptionMenu:SHOP_MENU_LOCATION];
            break;
        case SHOP_MENU_CUISINE:
            [self showShopOptionMenu:SHOP_MENU_CUISINE];
            break;
        case SHOP_MENU_BUDGET:
            [self showShopOptionMenu:SHOP_MENU_BUDGET];
            break;
        case UISegmentedControlNoSegment:
            [self dismissShopOptionMenu];
            break;
        default:
            NSLog(@"No option for: %d", [segmentedControl selectedSegmentIndex]);
    }
}

- (CGRect)frameForHiddenMenuViewController
{
    CGRect menuCategoryFrame = self.shopMenuCategoryContainer.frame;
    return CGRectMake(0, menuCategoryFrame.origin.y + menuCategoryFrame.size.height - 300, 320, 300);
}

- (CGRect)frameForMenuViewController
{
    CGRect menuCategoryFrame = self.shopMenuCategoryContainer.frame;
    return CGRectMake(0, menuCategoryFrame.origin.y + menuCategoryFrame.size.height, 320, 300);
}

- (void)dismissShopOptionMenu
{
    if (_isShowingMenu) {
        [UIView animateWithDuration:0.2f animations:^{
            self.menuViewController.view.frame = [self frameForHiddenMenuViewController];
        } completion:^(BOOL finished) {
            [self.menuViewController willMoveToParentViewController:nil];
            [self.menuViewController.view removeFromSuperview];
            [self.menuViewController removeFromParentViewController];
            _isShowingMenu = NO;
        }];
    }
}

- (void)showShopOptionMenu:(NSInteger)menuType
{
    self.menuViewController.menuType = menuType;
    [self addChildViewController:self.menuViewController];
    self.menuViewController.view.frame = [self frameForHiddenMenuViewController];
    [self.view insertSubview:self.menuViewController.view belowSubview:self.shopMenuCategoryContainer];
    [self.menuViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.menuViewController.view.frame = [self frameForMenuViewController];
    } completion:^(BOOL finished) {
        _isShowingMenu = YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchViewCell";
    WTSearchViewCell *cell = (WTSearchViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WTSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    WTShop *shop = [self.shopList objectAtIndex:indexPath.row];
    [cell setupSearchViewCellWithShop:shop];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    NSIndexPath *selectedRowIndex = [self.shopsTableView indexPathForSelectedRow];
    WTShopViewController *shopViewController = [segue destinationViewController];
    shopViewController.shop = [self.shopList objectAtIndex:selectedRowIndex.row];
}



#pragma mark - WTSearchMenuViewDelegate

- (void)didSelectNewSearchConditionWithLatitude:(double)latitude longitude:(double)longitude
{
    _selectedSegmentIndex = self.shopMenuSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    [self dismissShopOptionMenu];
    [self getSearchShopsWithConditionOfLatitude:latitude longitude:longitude];
}

- (void)didSelectNewSearchConditionNotImplemented
{
    [self dismissShopOptionMenu];
}

@end
