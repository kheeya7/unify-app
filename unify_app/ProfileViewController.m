//
//  ProfileViewController.m
//  unify_app
//
//  Created by Savannah Schuchardt on 3/28/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "ProfileViewController.h"
#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "NewsPosting.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) User *currentUser;

@property (nonatomic) float scrollViewContentHeight;
@property (nonatomic) float screenHeight;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.userPostings);
    
    for (NewsPosting *post in self.userPostings) {
        NSLog(@"post user: %@", post.name);
    }
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    [self displayNameLabel].text = [NSString stringWithFormat:@"%@", self.currentUser.displayName];
    [self emailLabel].text = self.currentUser.email;
    
    NSData *data = [NSData dataWithContentsOfURL:self.currentUser.photoUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    [self.photoView setImage:image];
    
    [self setup];
}
- (void)setup
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.screenHeight = screenBounds.size.height;
    self.scrollViewContentHeight = 1200;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollViewContentHeight);
    self.scrollView.delegate = self;
    self.tableView.delegate = self;
    self.scrollView.bounces = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.dataSource = self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // THIS WORKS BUT IS A BIT BUGGY
    if (scrollView == self.scrollView) {
        float yOffsetScrollView = self.scrollView.contentOffset.y;
        if (yOffsetScrollView >= 100) {
            NSLog(@"turning OFF scroll view and turning ON tableview");
            self.scrollView.scrollEnabled = NO;
            self.tableView.scrollEnabled = YES;
        }
    }
    
    if (scrollView == self.tableView) {
        float yOffsetTableView = self.tableView.contentOffset.y;
        NSLog(@"yOffset: %f", yOffsetTableView);
        NSLog(@"scrollView == self.tableView");
        if (yOffsetTableView <= 0) {
            NSLog(@"turning ON scroll view and turning OFF tableview");
            self.scrollView.scrollEnabled = YES;
            self.tableView.scrollEnabled = NO;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userPostings.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsPosting *thisPost = self.userPostings[indexPath.row];
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
//    }
    
    UILabel *label = [cell viewWithTag:0];
//    UITextView *textView = [cell viewWithTag:1];
//    textView.text = thisPost.postText;
    NSLog(@"adding %@ to table", thisPost.postText);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
@end
