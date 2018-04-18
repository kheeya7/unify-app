//
//  JobsAndCompaniesViewController.m
//  unify_app
//
//  Created by Savannah Schuchardt on 4/18/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "JobsAndCompaniesViewController.h"
#import "JobPostingDetailViewController.h"
#import "JobPosting.h"
#import "Company.h"

@import Firebase;

@interface JobsAndCompaniesViewController (){
    dispatch_queue_t imageQueue;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// jobs
@property (strong, nonatomic) FIRDatabaseReference *refJobPostings;
@property (strong, nonatomic) NSMutableArray *jobPostings;

// companies
@property (strong, nonatomic) FIRDatabaseReference *refCompaniesPostings;
@property (strong, nonatomic) NSMutableArray *companies;

@end

@implementation JobsAndCompaniesViewController
#pragma mark - setup
- (void)setupJobs
{
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
            
            [self.tableView reloadData];
        }
    }];
}
- (void)setupCompanies
{
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    self.refCompaniesPostings = [[[FIRDatabase database] reference] child:@"companies"];
    
    self.companies = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refCompaniesPostings observeEventType:FIRDataEventTypeValue
                                      withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.childrenCount > 0) {
            // cleaar the list
            [self.companies removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children) {
                NSDictionary *companyDict = [child value];
                NSString *aKey = [companyDict objectForKey:@"id"];
                NSString *name = [companyDict objectForKey:@"name"];
                NSString *companyDescription = [companyDict objectForKey:@"description"];
                NSString *aCompanyLogoUrlString = [companyDict objectForKey:@"logo"];
                NSString *location = [companyDict objectForKey:@"location"];
                
                Company *company = [[Company alloc] init];
                company.key = aKey;
                company.name = name;
                company.companyDescription = companyDescription;
                company.companyLogoUrlString = aCompanyLogoUrlString;
                company.location = location;
                
                [self.companies addObject:company];
            }
        }
    }];
}
#pragma mark - tableview data source and data delegate methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:0];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *detail = (UILabel *)[cell viewWithTag:2];
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        JobPosting *jobPosting = self.jobPostings[indexPath.row];
        
        title.text = jobPosting.title;
        detail.text = jobPosting.company;
        
        // temporary placeholder
        //cell.imageView.image = [UIImage imageNamed:@"chat-icon"];
        
        if (!imageQueue) {
            imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
        }
        
        imageView.image = [UIImage imageNamed:@"company-logo-placeholder"];
        
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
                UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Check if the cell is still visible and not reused by other
                if (updateCell) {
                    UIImageView *imageView = (UIImageView *)[updateCell viewWithTag:0];
                    imageView.image = newImage;
                }
            });
        });
        
    } else {
        
        Company *company = self.companies[indexPath.row];
        
        cell.textLabel.text = company.name;
        cell.detailTextLabel.text = company.location;
        
        // temporary placeholder
        //cell.imageView.image = [UIImage imageNamed:@"chat-icon"];
        
        if (!imageQueue) {
            imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
        }
        
        cell.imageView.image = [UIImage imageNamed:@"company-logo-placeholder"];
        
        // dispatch the getting logo and resizing to the custom queue to unblock main queue
        dispatch_async(imageQueue, ^{
            UIImage *image = [company getImageLogo];
            
            // Resize the image so that icons have same size
            CGSize newSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // Since we are modifying the UI, dispatch back on the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Check if the cell is still visible and not reused by other
                if (updateCell) {
                    updateCell.imageView.image = newImage;
                }
            });
        });
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return [self.jobPostings count];
    } else {
        return [self.companies count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
#pragma mark - actions

- (IBAction)segmentControlChanged:(UISegmentedControl *)sender
{
    [self.tableView reloadData];
}
#pragma mark - inherited methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // setup jobs and company data models
    [self setupJobs];
    [self setupCompanies];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pulloutSegue"]) {
        
    } else if ([segue.identifier isEqualToString:@"segueJobDetailView"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        JobPosting *jobPosting = self.jobPostings[path.row];
        
        JobPostingDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.currentJobPosting = jobPosting;
    }
}
@end
