//
//  JobPostingDataSource.m
//  unify_app
//
//  Created by Kate Sohng on 4/22/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "JobPostingDataSource.h"
#import "JobPosting.h"

@import Firebase;

@interface JobPostingDataSource (){
    dispatch_queue_t imageQueue;
}

@property (strong, nonatomic) FIRDatabaseReference *refJobPostings;
@property (strong, nonatomic) NSMutableArray *jobPostings;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation JobPostingDataSource

-(id) initWithTableView:(UITableView *)aTableView {
    if (self = [super init]) {
        self.tableView = aTableView;
    }
    return self;
}

- (JobPosting *) getJobPostingAtRow:(NSInteger)index {
    return self.jobPostings[index];
}

- (void) loadData {
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    self.refJobPostings = [[[FIRDatabase database] reference] child:@"jobPostings"];
    
    self.jobPostings = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refJobPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.childrenCount > 0) {
            // clear the list
            [self.jobPostings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot *child in snapshot.children) {
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
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - tableview data source and data delegate methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"jobPostingCell"];
    
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:0];
    UILabel* title = (UILabel *)[cell viewWithTag:1];
    UILabel* detail = (UILabel *)[cell viewWithTag:2];
    
    JobPosting *jobPosting = self.jobPostings[indexPath.row];
    
    title.text = jobPosting.title;
    detail.text = jobPosting.company;
   
    imageView.image = [UIImage imageNamed: @"company-logo-placeholder"];
    
    // Dispatch the getting logo and resizing to the custom queue to unblock main queue
    dispatch_async(imageQueue, ^{
        UIImage* image = [jobPosting getImageLogo];
        
        // Resize the image so that icons have same size
        CGSize newSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0,0,newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Since we are modifying the UI, dispatch back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Check if the cell is still visible and not reused by other
            if (updateCell){
                UIImageView *imageView = (UIImageView *)[updateCell viewWithTag:0];
                imageView.image = newImage;
            }
        });
    });
    return cell;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jobPostings count];
}

@end
