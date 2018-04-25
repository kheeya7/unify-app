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
#import "newsPost.h"

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

//- (IBAction)onAddNewsPosting:(id)sender {
//   [self addNewsPosting];
//}

#pragma mark - inherited methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refPostings = [[[FIRDatabase database] reference] child:@"news"];
    
    self.postings = [[NSMutableArray alloc] initWithCapacity:50];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    NSData *data = [NSData dataWithContentsOfURL:(self.currentUser.photoUrl)];
    UIImage *image = [UIImage imageWithData:data];
    
    [self.photoView setImage:image];
    
    //Let the DashboardViewController be the delegate of the message input, so that we can handle return key
    self.postNewsTextField.delegate = self;
    
    [self listenForNews];
    }

-(void)listenForNews {
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
                NSString *aPhotoUrl = [savedNewsPosting objectForKey:@"userPhotoUrl"];
                
                NewsPosting *newsPosting = [[NewsPosting alloc] initWithKey:aKey name:aName time:aTimestamp post:aPost userPhotoUrl:aPhotoUrl];
                
                [self.postings insertObject:newsPosting atIndex:0];
            }
            [[self tableView] reloadData];
        }
    }];
}

#pragma mark - setup

- (void)addNewsPosting{
    
    NSString *key = [[self.refPostings childByAutoId] key];
    
    NSDictionary *newsPosting = @{
                                  @"id": key,
                                  @"postText":self.postNewsTextField.text,
                                  @"user": self.currentUser.displayName,
                                  @"postTime":[self getTimestampString],
                                  @"userPhotoUrl": self.currentUser.photoUrl.absoluteString
                                  };
    [[self.refPostings child:key] setValue:newsPosting];
    
    self.postNewsTextField.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *) newsTextField {
    if (newsTextField == self.postNewsTextField) {
        [newsTextField resignFirstResponder];
        [self addNewsPosting];
        return NO;
    }
    return YES;
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

#pragma mark - table view delegate and data source methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath: (nonnull NSIndexPath *)indexPath {
    
    NewsPostingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NewsPosting *newsPosting = [self postings][indexPath.row];
    
    UIImage *photo = [newsPosting getUserPhoto];
    
    cell.nameLabel.text = [newsPosting name];
    cell.timeStampLabel.text = [newsPosting timestamp];
    cell.newsTextView.text = [newsPosting postText];
    cell.photoImageView.image = photo;
    
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2 ;
    self.photoView.clipsToBounds = YES;
    
    cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width / 2 ;
    cell.photoImageView.clipsToBounds = YES;
    
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
