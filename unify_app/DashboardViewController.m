//
//  DashboardViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/19/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "newsPost.h"

@import Firebase;

@interface DashboardViewController ()

// table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// posting news
@property (weak, nonatomic) IBOutlet UITextField *postNewsTextField;


// news feed
@property (strong, nonatomic) NSMutableArray *postings;

@property (strong, nonatomic) FIRDatabaseReference *refPostings;

@end

@implementation DashboardViewController

#pragma mark - setup
- (void)downloadPosts
{
    self.refPostings = [[[FIRDatabase database] reference] child:@"News"];
    
    [self.refPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        
        if (snapshot.childrenCount > 0) {
            
            // cleaar the list
            [self.postings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children) {
                
                NSArray *birds = [child value];
                
                if ([birds isKindOfClass:[NSMutableArray class]]) {
                    
                    
                    for (NSDictionary *birdDict in birds) {
                        NSString *dateString = birdDict[@"date"];
                        newsPost *post = [[newsPost alloc] initWithDate:dateString];
                        post.postText = birdDict[@"family"];
                        NSLog(@"added post to array");
                        [self.postings addObject:post];
                    }
                    
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}
- (void)setup
{
    
    self.postings = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.postNewsTextField.delegate = self;
    
//    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//    User *currentUser = appDelegate.currentUser;
//
//    [self displayNameLabel].text = [NSString stringWithFormat:@"Hi! %@", currentUser.displayName];
//    [self emailLabel].text = currentUser.email;
//
//    NSData *data = [NSData dataWithContentsOfURL:currentUser.photoUrl];
//    UIImage *image = [UIImage imageWithData:data];
//
//    [self.photoView setImage:image];
}
- (void)postNewsItem:(NSString *)newsToPost
{
//    FIRDatabaseReference *usersDBRef = [[[FIRDatabase database] reference] child:@"News"];
    
    // Creating a news post to send to the DB
    
    // Create date string
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
        
    // Get current user
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    User *currentUser = appDelegate.currentUser;

    newsPost *post = [[newsPost alloc] initWithDate:dateString];
    post.user = currentUser.displayName;
    post.postText = newsToPost;
    
    __weak DashboardViewController *weakSelf = self;
    
    [self.refPostings setValue:[post getDictionaryFormat] withCompletionBlock:^(NSError * _Nullable error,FIRDatabaseReference * _Nonnull ref) {
        
        // after the user is saved, we navigate to the main
        NSLog(@"news post uploaded successfully");
        [weakSelf.tableView reloadData];
    
    }];
    
}
#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self postNewsItem:textField.text];
    return YES;
}
#pragma mark - table view delegate and data source methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    newsPost *thisPost = self.postings[indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:0];
    UILabel *nameLabel = [cell viewWithTag:1];
    UILabel *dateLabel = [cell viewWithTag:2];
    UITextView *postBody = [cell viewWithTag:3];
    
//    [imageView setImage:thisPost.userImage];
//    nameLabel.text = thisPost.user;
//    dateLabel.text = thisPost.date // figure out how to format
    postBody.text = thisPost.postText;
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.postings.count;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0;
}
#pragma mark - inherited methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self downloadPosts];
}

@end
