//
//  WTSearchViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-11.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchViewController.h"
#import "WTSegmentedControl.h"

@interface WTSearchViewController () {
    BOOL _isShowingMenu;
    NSInteger _selectedSegmentIndex;
}

@property (weak, nonatomic) IBOutlet UIView *shopMenuCategoryContainer;
@property (weak, nonatomic) IBOutlet WTSegmentedControl *shopMenuSegmentControl;
@property (strong, nonatomic) WTSearchMenuViewController *menuViewController;

@end

@implementation WTSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showShopOptionMenu:(NSInteger)optionType
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - WTSearchMenuViewDelegate

- (void)didSelectNewSearchConditionWithLatitude:(double)latitude longitude:(double)longitude
{
    [self dismissShopOptionMenu];
}

- (void)didSelectNewSearchConditionNotImplemented
{
    [self dismissShopOptionMenu];
}

@end
