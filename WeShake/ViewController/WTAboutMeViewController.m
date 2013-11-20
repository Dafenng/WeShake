//
//  WTAboutMeViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTAboutMeViewController.h"
#import "WTAccountManager.h"
#import "WTUser.h"
#import "UIImageView+AFNetworking.h"
#import "WTSharePostCell.h"
#import "WTHttpEngine.h"
#import "WTDataDef.h"
#import "WTLoadMoreCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface WTAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL noMorePost;

@end

@implementation WTAboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _posts = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _posts = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.usernameLabel.text = [[WTUser sharedInstance] username];
    [self.avatarImageview setImageWithURL:[NSURL URLWithString:[[WTUser sharedInstance] avatar]] placeholderImage:[UIImage imageNamed:@"default_profile_male.png"]];
    
    self.avatarImageview.layer.cornerRadius = 32.f;
    self.avatarImageview.layer.masksToBounds = YES;
    
//    [self getSharePosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNoPosts
{
    
}

- (void)getSharePosts
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%ld/posts", (long)[[[WTUser sharedInstance] userId] integerValue]];
    NSDictionary *params = @{
                             @"start": @([self.posts count]),
                             @"count": @(CountPerRequest),
                             @"user_id": [[WTUser sharedInstance] userId],
                             @"auth_token": [[WTUser sharedInstance] authToken]};
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSInteger postCount = [(NSArray *)[responseObject objectForKey:@"posts"] count];
        if (postCount == 0) {
            self.noMorePost = YES;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.posts count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [(NSArray *)[responseObject objectForKey:@"posts"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WTPost *post = [MTLJSONAdapter modelOfClass:WTPost.class fromJSONDictionary:obj error:nil];
                [self.posts addObject:post];
            }];
            
            if ([self.posts count] - postCount == 0) {
                [self.tableView reloadData];
            } else {
                if (postCount < CountPerRequest) {
                    self.noMorePost = YES;
                }
                NSMutableArray *insertIndexPaths = [NSMutableArray array];
                for (NSInteger i = [self.posts count] - postCount; i < [self.posts count]; i++) {
                    [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
        
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SharePostCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.posts count]) {
        cell = (WTLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if (cell == nil) {
            cell = [WTLoadMoreCell loadMoreCellFromNib];
        }
        
        if (self.noMorePost) {
            ((WTLoadMoreCell *)cell).indicator.hidden = YES;
            [((WTLoadMoreCell *)cell).indicator stopAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"データがありません";
        } else {
            ((WTLoadMoreCell *)cell).indicator.hidden = NO;
            [((WTLoadMoreCell *)cell).indicator startAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"      ローディング";
            [self getSharePosts];
        }
    } else {
        cell = (WTSharePostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[WTSharePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        WTPost *post = self.posts[indexPath.row];
        [(WTSharePostCell *)cell initWithPost:post];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == [self.posts count] ? 44 : 290;;
}

@end
