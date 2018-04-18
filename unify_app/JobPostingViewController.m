//
//  JobPostingViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/17/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "JobPostingViewController.h"
#import "JobPostingDetailViewController.h"

@import Firebase;

@interface JobPostingViewController (){
    dispatch_queue_t imageQueue;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewJobPostings;
@property (strong, nonatomic) FIRDatabaseReference *refJobPostings;
@property (strong, nonatomic) NSMutableArray *jobPostings;

@end

@implementation JobPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    self.refJobPostings = [[[FIRDatabase database] reference] child:@"jobPostings"];
    
    self.jobPostings = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refJobPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.childrenCount > 0) {
            // cleaar the list
            [self.jobPostings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children) {
                NSDictionary *savedJobPosting = [child value];
                NSString *aKey = [savedJobPosting objectForKey:@"id"];
                NSString *aTitle = [savedJobPosting objectForKey:@"title"];
                NSString *aCompany = [savedJobPosting objectForKey:@"company"];
                NSString *aJobDescription = [savedJobPosting objectForKey:@"jobDescription"];
                NSString *aCompanyLogoUrlString = [savedJobPosting objectForKey:@"companyLogo"];
                
                JobPosting *jobPosting = [[JobPosting alloc] init];
                jobPosting.key = aKey;
                jobPosting.title = aTitle;
                jobPosting.company = aCompany; 
                jobPosting.jobDescription = aJobDescription;
                jobPosting.companyLogoUrlString = aCompanyLogoUrlString;
                
                [self.jobPostings addObject:jobPosting];
            }
            
            [self.tableViewJobPostings reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pulloutSegue"]) {
        
    } else if ([segue.identifier isEqualToString:@"segueJobDetailView"]) {
        NSIndexPath *path = [self.tableViewJobPostings indexPathForSelectedRow];
        JobPosting *jobPosting = self.jobPostings[path.row];
        
        JobPostingDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.currentJobPosting = jobPosting;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    JobPosting *jobPosting = self.jobPostings[indexPath.row];
    
    cell.textLabel.text = jobPosting.title;
    cell.detailTextLabel.text = jobPosting.company;
    
    // temporary placeholder
    //cell.imageView.image = [UIImage imageNamed:@"chat-icon"];
    
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    cell.imageView.image = [UIImage imageNamed:@"company-logo-placeholder"];
    
    // dispatch the getting logo and resizing to the custom queue to unblock main queue
    dispatch_async(imageQueue, ^{
        UIImage *image = [jobPosting getImageLogo];
        
        // Resize the image so that icons have same size
        CGSize newSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Since we are modifying the UI, dispatch back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *updateCell = [self.tableViewJobPostings cellForRowAtIndexPath:indexPath];
            
            // Check if the cell is still visible and not reused by other
            if (updateCell) {
                updateCell.imageView.image = newImage;
            }
        });
    });
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jobPostings count];
}

@end
