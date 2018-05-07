//
//  MembersDetailViewController.m
//  unify_app
//
//  Created by Savannah Schuchardt on 5/5/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#include <stdlib.h>
#import "MembersDetailViewController.h"
//#import "MembersViewController.h"
//#import "DashboardViewController.h"
//#import "AppDelegate.h"
//#import "User.h"
#import "NewsPosting.h"
#import "RecentActivityCell.h"

@import Firebase;
@import FirebaseStorage;

@interface MembersDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (nonatomic) float scrollViewContentHeight;
@property (nonatomic) float screenHeight;

@property (strong, nonatomic) NSMutableArray *postings;
@property (strong, nonatomic) FIRDatabaseReference *refPostings;

@end

@implementation MembersDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // posting stuff
    self.refPostings = [[[FIRDatabase database] reference] child:@"news"];
    
    self.postings = [[NSMutableArray alloc] initWithCapacity:50];
    
    
//    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//
//    self.currentUser = appDelegate.currentUser;
//
//    [self displayNameLabel].text = self.currentUser.displayName;
//    [self emailLabel].text = self.currentUser.email;
//    [self bioLabel].text = self.currentUser.additionalDetail;
//
//    NSData *data = [NSData dataWithContentsOfURL:self.currentUser.photoUrl];
//    UIImage *image = [UIImage imageWithData:data];
//
//    [self.photoView setImage:image];
    
    
    [self.displayNameLabel setText:[self.currentUser displayName]];
    [self.emailLabel setText:[self.currentUser email]];
    [self.bioLabel setText:[self.currentUser additionalDetail]];
    
    UIImage *image = [self.currentUser getUserPhoto];
    [self.photoView setImage:image];
    
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2 ;
    self.photoView.clipsToBounds = YES;
    
    [self setup];
    [self loadRecentActivityData];
}


//posting stuff
- (void)loadRecentActivityData {
    [self.refPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if(snapshot.childrenCount > 0) {
            // clear the list
            [self.postings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children){
                // get only posting that has matching uid
                NSDictionary *savedNewsPosting = [child value];
                
                NSString *aUid = [savedNewsPosting objectForKey:@"uid"];
                
                if ([self.currentUser.uid isEqualToString:aUid]) {
                    NSString *aKey = [savedNewsPosting objectForKey:@"id"];
                    NSString *aName = [savedNewsPosting objectForKey:@"user"];
                    NSString *aTimestamp = [savedNewsPosting objectForKey:@"postTime"];
                    NSString *aPost = [savedNewsPosting objectForKey:@"postText"];
                    NSString *aPhotoUrl = [savedNewsPosting objectForKey:@"userPhotoUrl"];
                    
                    NewsPosting *newsPosting = [[NewsPosting alloc] initWithKey:aKey name:aName time:aTimestamp post:aPost userPhotoUrl:aPhotoUrl];
                    
                    [self.postings insertObject:newsPosting atIndex:0];
                }
            }
            [[self tableView] reloadData];
        }
    }];
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
    return self.postings.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postingCell"];
    
    NewsPosting *newsPosting = [self postings][indexPath.row];
    
    UIImage *photo = [newsPosting getUserPhoto];
    
    cell.userName.text = [newsPosting name];
    cell.timePosted.text = [newsPosting timestamp];
    cell.content.text = [newsPosting postText];
    cell.profilePicture.image = photo;
    
    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2 ;
    cell.profilePicture.clipsToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end