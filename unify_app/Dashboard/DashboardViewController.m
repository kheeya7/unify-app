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
#import "NewsPosting.h"
#import "NewsPostingCell.h"

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
    
    self.postings = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if(snapshot.childrenCount > 0) {
            // clear the list
            [self.postings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children){
                NSDictionary *savedNewsPosting = [child value];
                NSString *aKey = [savedNewsPosting objectForKey:@"id"];
                NSString *aName = [savedNewsPosting objectForKey:@"user"];
                NSString *aTimestamp = [savedNewsPosting objectForKey:@"postTime"];
                NSString *aPost = [savedNewsPosting objectForKey:@"postText"];
                
                NewsPosting *newsPosting = [[NewsPosting alloc] initWithKey:aKey name:aName time:aTimestamp post:aPost];
                
                [self.postings addObject:newsPosting];
            }
            [[self tableView] reloadData];
        }
    }];
    
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
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath: (nonnull NSIndexPath *)indexPath {
    
    NewsPostingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NewsPosting *newsPosting = [self postings][indexPath.row];
    
    cell.nameLabel.text = [newsPosting name];
    cell.timeStampLabel.text = [newsPosting timestamp];
    cell.newsTextView.text = [newsPosting postText];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postings count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0;
}

@end
