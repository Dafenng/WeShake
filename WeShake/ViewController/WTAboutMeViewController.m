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

@interface WTAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *posts;

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
    [self.avatarImageview setImageWithURL:[NSURL URLWithString:[[WTUser sharedInstance] avatar]] placeholderImage:nil];
    
    [self getSharePosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSharePosts
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%d/posts", [[[WTUser sharedInstance] userId] integerValue]];
    NSDictionary *params = @{
                             @"user_id": [[WTUser sharedInstance] userId],
                             @"auth_token": [[WTUser sharedInstance] authToken]};
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [(NSArray *)responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTPost *post = [MTLJSONAdapter modelOfClass:WTPost.class fromJSONDictionary:obj error:nil];
            [self.posts addObject:post];
        }];
        [self.tableView reloadData];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取SharePost列表失败");
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SharePostCell";
    WTSharePostCell *cell = (WTSharePostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WTSharePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    WTPost *post = self.posts[indexPath.row];
    [(WTSharePostCell *)cell initWithPost:post];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

@end
