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
//#import "newsPost.h"

@import Firebase;

@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextField *postNewsTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *postings;
@property (strong, nonatomic) FIRDatabaseReference *refPostings;
@property (weak, nonatomic) User *currentUser;

@end

@implementation DashboardViewController

- (IBAction)onAddNewsPosting:(id)sender {
    [self addNewsPosting];
}

#pragma mark - inherited methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refPostings = [[[FIRDatabase database] reference] child:@"news"];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    NSData *data = [NSData dataWithContentsOfURL:(self.currentUser.photoUrl)];
    UIImage *image = [UIImage imageWithData:data];
    
    [self.photoView setImage:image];
    }

#pragma mark - setup
- (void)addNewsPosting{
    
    NSString *key = [[self.refPostings childByAutoId] key];
    
    NSDictionary *newsPosting = @{
                                  @"id": key,
                                  @"postText":self.postNewsTextField.text,
                                  @"user": self.currentUser.displayName,
                                  @"postTime":[self getTimestampString]
                                  };
    [[self.refPostings child:key] setValue:newsPosting];
}

- (NSString *)getTimestampString {
    // Get current device time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Display in 12hr/24hr format according to User Setting
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    return currentTime;
}


#pragma mark - text field delegate

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self postNewsItem:textField.text];
//    return YES;
//}

#pragma mark - table view delegate and data source methods
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    newsPost *thisPost = self.postings[indexPath.row];
    
//    UIImageView *imageView = [cell viewWithTag:0];
//    UILabel *nameLabel = [cell viewWithTag:1];
//    UILabel *dateLabel = [cell viewWithTag:2];
//    UITextView *postBody = [cell viewWithTag:3];
    
        //    [imageView setImage:thisPost.userImage];
        //    nameLabel.text = thisPost.user;
        //    dateLabel.text = thisPost.date // figure out how to format
//    postBody.text = thisPost.postText;
    
//   return cell;
    
//}

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

@end
