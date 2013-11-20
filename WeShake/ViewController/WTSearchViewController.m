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
#import "WTLocationManager.h"
#import "WTLoadMoreCell.h"
#import "SVProgressHUD.h"

@interface WTSearchViewController () {
    BOOL _isShowingMenu;
    NSInteger _selectedSegmentIndex;
}

@property (weak, nonatomic) IBOutlet UIView *shopMenuCategoryContainer;
@property (weak, nonatomic) IBOutlet WTSegmentedControl *shopMenuSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *shopsTableView;
@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) WTSearchMenuViewController *menuViewController;
@property (strong, nonatomic) NSMutableArray *shopList;
@property (assign, nonatomic) BOOL noMoreShops;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *regionButton;

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    
    self.shadowView = [[UIView alloc] initWithFrame:self.shopsTableView.frame];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.0f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShopOptionMenu)];
    [self.shadowView addGestureRecognizer:tapGesture];
    
    self.menuViewController = [[WTSearchMenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    [self.regionButton setTitle:[[WTLocationManager sharedInstance] region]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.shopMenuCategoryContainer removeFromSuperview];
//    [self.view insertSubview:self.shopMenuCategoryContainer aboveSubview:self.shopsTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSearchShopsWithRegion:(NSString *)aRegion
                            area:(NSString *)anArea
                        district:(NSString *)aDistrict
                           genre:(NSString *)aGenre
                         cuisine:(NSString *)aCuisine
                          period:(NSString *)aPeriod
                          budget:(NSString *)aBudget
{
    [[WTShopManager sharedInstance] getSearchShopsWithRegion:aRegion area:anArea district:aDistrict genre:aGenre cuisine:aCuisine period:aPeriod budget:aBudget from:[self.shopList count] count:CountPerRequest sucsess:^(NSArray *shops) {
        if ([shops count] == 0) {
            //刚好加载完所有
            self.noMoreShops = YES;
            [self.shopsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.shopList count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            if ([shops count] < CountPerRequest) {
                self.noMoreShops = YES;
            }
            if ([self.shopList count] == 0) {
                [self.shopList addObjectsFromArray:shops];
                [self.shopsTableView reloadData];
            } else {
                [self.shopList addObjectsFromArray:shops];
                NSMutableArray *insertIndexPaths = [NSMutableArray array];
                for (NSInteger i = [self.shopList count] - [shops count]; i < [self.shopList count]; i++) {
                    [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.shopsTableView beginUpdates];
                [self.shopsTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.shopsTableView endUpdates];
            }
        }
    } failure:^(ErrorType errorCode) {
        switch (errorCode) {
            case NetworkError:
                [self showNetworkError];
                break;
            default:
                break;
        }
    }];
}

- (void)showNetworkError
{
    [SVProgressHUD showErrorWithStatus:@"ネットワークエラー"];
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
            NSLog(@"No option for: %ld", (long)[segmentedControl selectedSegmentIndex]);
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
            self.shadowView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.menuViewController willMoveToParentViewController:nil];
            [self.menuViewController.view removeFromSuperview];
            [self.menuViewController removeFromParentViewController];
            
            [self.shadowView removeFromSuperview];
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
    [self.view insertSubview:self.shadowView aboveSubview:self.shopsTableView];
    [self.menuViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.menuViewController.view.frame = [self frameForMenuViewController];
        self.shadowView.alpha = 0.6f;
    } completion:^(BOOL finished) {
        _isShowingMenu = YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchViewCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.shopList count]) {
        cell = (WTLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if (cell == nil) {
            cell = [WTLoadMoreCell loadMoreCellFromNib];
        }
        
        if (self.noMoreShops) {
            ((WTLoadMoreCell *)cell).indicator.hidden = YES;
            [((WTLoadMoreCell *)cell).indicator stopAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"データがありません";
        } else {
            ((WTLoadMoreCell *)cell).indicator.hidden = NO;
            [((WTLoadMoreCell *)cell).indicator startAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"      ローディング";
            NSString *area = [self.menuViewController.area isEqualToString:@"検索距離"] ? @"Around" : self.menuViewController.area;
            NSString *genre = [self.menuViewController.genre isEqualToString:@"全部"] ? @"All" : self.menuViewController.genre;
            [self getSearchShopsWithRegion:self.menuViewController.region area:area district:self.menuViewController.district genre:genre cuisine:self.menuViewController.cuisine period:self.menuViewController.period budget:self.menuViewController.budget];
        }
    } else {
        cell = (WTSearchViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[WTSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        WTShop *shop = [self.shopList objectAtIndex:indexPath.row];
        [(WTSearchViewCell *)cell setupSearchViewCellWithShop:shop];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == [self.shopList count] ? 44 : 105;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SearchViewToShopView"]) {
        NSIndexPath *selectedRowIndex = [self.shopsTableView indexPathForSelectedRow];
        [[segue destinationViewController] setShop:[self.shopList objectAtIndex:selectedRowIndex.row]];
    } else if ([segue.identifier isEqualToString:@"SearchToRegionView"]) {
        ((WTRegionViewController *)[(UINavigationController *)[segue destinationViewController] viewControllers][0]).delegate = self;
    }
}

#pragma mark - WTSearchMenuViewDelegate

- (void)didSelectNewSearchConditionWithRegion:(NSString *)aRegion
                                         area:(NSString *)anArea
                                     district:(NSString *)aDistrict
                                        genre:(NSString *)aGenre
                                      cuisine:(NSString *)aCuisine
                                       period:(NSString *)aPeriod
                                       budget:(NSString *)aBudget
{
    _selectedSegmentIndex = self.shopMenuSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    [self dismissShopOptionMenu];
    [self.shopList removeAllObjects];
    self.noMoreShops = NO;
    [self.shopsTableView reloadData];
//    [self getSearchShopsWithRegion:aRegion area:anArea district:aDistrict genre:aGenre cuisine:aCuisine period:aPeriod budget:aBudget];
}

- (void)didSelectNewSearchConditionNotImplemented
{
    [self dismissShopOptionMenu];
}


#pragma mark - region delegate

- (void)didSelectRegion:(NSString *)aRegion
{
    [self.regionButton setTitle:aRegion];
    [self.menuViewController setRegion:aRegion];
    [self.menuViewController setArea:@"All"];
    
    [self.shopList removeAllObjects];
    self.noMoreShops = NO;
    [self.shopsTableView reloadData];
}

@end
