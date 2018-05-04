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
#import "RecentActivityCell.h"

@import Firebase;

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) User *currentUser;

@property (nonatomic) float scrollViewContentHeight;
@property (nonatomic) float screenHeight;

@property (strong, nonatomic) NSMutableArray *postings;
@property (strong, nonatomic) FIRDatabaseReference *refPostings;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refPostings = [[[FIRDatabase database] reference] child:@"news"];
    
    self.postings = [[NSMutableArray alloc] initWithCapacity:50];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    [self displayNameLabel].text = [NSString stringWithFormat:@"%@", self.currentUser.displayName];
    [self emailLabel].text = self.currentUser.email;
    
    NSData *data = [NSData dataWithContentsOfURL:self.currentUser.photoUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    [self.photoView setImage:image];
    
    [self setup];
    [self loadWhatsNewData];
}

- (void)loadWhatsNewData {
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
    return 250;
}
@end
