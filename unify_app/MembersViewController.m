//
//  MembersViewController.m
//  unify_app
//
//  Created by rcaligan on 4/9/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "MembersViewController.h"
#import "ProfileViewController.h"
#import "User.h"

@import Firebase;

@interface MembersViewController () {
    dispatch_queue_t imageQueue;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewMembers;

@property (strong, nonatomic) FIRDatabaseReference *refMembers;
@property (strong, nonatomic) NSMutableArray *members;

@end

@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewMembers.rowHeight = 70;
    
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    self.refMembers = [[[FIRDatabase database] reference] child:@"users"];
    
    self.members = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refMembers observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.childrenCount > 0) {
            // cleaar the list
            [self.members removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children) {
                NSDictionary *savedMember = [child value];
                NSString *aKey = [savedMember objectForKey:@"uid"];
                NSString *aName = [savedMember objectForKey:@"displayName"];
                NSString *aEmail = [savedMember objectForKey:@"email"];
                NSString *aOccupation = [savedMember objectForKey:@"occupation"];
                NSURL *aPhotoUrlString = [savedMember objectForKey:@"photoUrl"];
                
                User *user = [[User alloc] init];
                user.uid = aKey;
                user.displayName = aName;
                user.email = aEmail;
                user.occupation = aOccupation;
                user.photoUrl = aPhotoUrlString;
                
                [self.members addObject:user];
            }
            
            [self.tableViewMembers reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//
//    [segue.identifier isEqualToString:@"segueMemberProfile"]; {
//        NSIndexPath *path = [self.tableViewMembers indexPathForSelectedRow];
//        User *user = self.members[path.row];
//
//    ProfileViewController *detailViewController = [segue destinationViewController];
//        detailViewController.currentUser = user;
//    }
//}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    User *user = self.members[indexPath.row];
    
    cell.textLabel.text = user.displayName;
    cell.detailTextLabel.text = user.occupation;
    
    // temporary placeholder
    //cell.imageView.image = [UIImage imageNamed:@"chat-icon"];
    
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    cell.imageView.image = [UIImage imageNamed:@"company-logo-placeholder"];
    
    // dispatch the getting logo and resizing to the custom queue to unblock main queue
    dispatch_async(imageQueue, ^{
        UIImage *image = [user getUserPhoto];
        
        // Resize the image so that icons have same size
        CGSize newSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Since we are modifying the UI, dispatch back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *updateCell = [self.tableViewMembers cellForRowAtIndexPath:indexPath];
            
            // Check if the cell is still visible and not reused by other
            if (updateCell) {
                updateCell.imageView.image = newImage;
                
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2 ;
                cell.imageView.clipsToBounds = YES;
            }
        });
    });
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.members count];
}


@end
