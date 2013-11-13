//
//  WTFavorViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTFavorViewController.h"
#import "WTSearchViewCell.h"
#import "WTLoadMoreCell.h"
#import "WTUser.h"
#import "WTDataDef.h"
#import "WTHttpEngine.h"
#import "WTLocationManager.h"
#import "WTShopViewController.h"

@interface WTFavorViewController ()

@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (strong, nonatomic) NSMutableArray *shopList;
@property (assign, nonatomic) BOOL noMoreShops;

@end

@implementation WTFavorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self getFavorShops];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFavorShops
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"process": @"favor",
                             
                             @"user_id": [[WTUser sharedInstance] userId],
                             @"start" : @([self.shopList count]),
                             @"count" : @(CountPerRequest)
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *favorShopList = [NSMutableArray array];
        [(NSArray *)[responseObject objectForKey:@"shops"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
            [favorShopList addObject:shop];
        }];
        [self handleFavorShops:favorShopList];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Favor error");
    }];

}

- (void)handleFavorShops:(NSArray *)shops
{
    if ([shops count] == 0) {
        //刚好加载完所有
        self.noMoreShops = YES;
        [self.shopTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.shopList count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if ([shops count] < CountPerRequest) {
            self.noMoreShops = YES;
        }
        if ([self.shopList count] == 0) {
            [self.shopList addObjectsFromArray:shops];
            [self.shopTableView reloadData];
        } else {
            [self.shopList addObjectsFromArray:shops];
            NSMutableArray *insertIndexPaths = [NSMutableArray array];
            for (NSInteger i = [self.shopList count] - [shops count]; i < [self.shopList count]; i++) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.shopTableView beginUpdates];
            [self.shopTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.shopTableView endUpdates];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FavorViewToShopView"]) {
        NSIndexPath *selectedRowIndex = [self.shopTableView indexPathForSelectedRow];
        [[segue destinationViewController] setShop:[self.shopList objectAtIndex:selectedRowIndex.row]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavorViewCell";
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
            ((WTLoadMoreCell *)cell).status.text = @"No More";
        } else {
            ((WTLoadMoreCell *)cell).indicator.hidden = NO;
            [((WTLoadMoreCell *)cell).indicator startAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"Loading";
            //            [self getSearchShops];
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

@end
