//
//  JobsAndCompaniesViewController.m
//  unify_app
//
//  Created by Savannah Schuchardt on 4/18/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "JobsAndCompaniesViewController.h"
#import "JobPostingDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "JobPostingDataSource.h"
#import "CompanyDataSource.h"
#import "Company.h"

@import Firebase;

@interface JobsAndCompaniesViewController (){
    dispatch_queue_t imageQueue;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JobPostingDataSource *jobPostingDataSource;
@property (strong, nonatomic) CompanyDataSource *companyDataSource;

@end

@implementation JobsAndCompaniesViewController

#pragma mark - inherited methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.jobPostingDataSource = [[JobPostingDataSource alloc] initWithTableView:self.tableView];
    self.companyDataSource = [[CompanyDataSource alloc] initWithTableView:self.tableView];
    
    // setup table view
    self.tableView.delegate = self;
    
    // set the job posting as the first data source
    self.tableView.dataSource = self.jobPostingDataSource;
    
    [self.jobPostingDataSource loadData];
}

#pragma mark - actions
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.tableView.dataSource = self.jobPostingDataSource;
        [self.jobPostingDataSource loadData];
    } else {
        self.tableView.dataSource = self.companyDataSource;
        [self.companyDataSource loadData];
    }
}

#pragma mark - tableview data source and data delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isMemberOfClass:[JobPostingDetailViewController class]]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        JobPosting *jobPosting = [self.jobPostingDataSource getJobPostingAtRow:path.row];
        
        JobPostingDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.currentJobPosting = jobPosting;
    } else if ([segue.destinationViewController isMemberOfClass:[CompanyDetailViewController class]]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Company *company = [self.companyDataSource getCompanyAtRow:path.row];
        
        CompanyDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.currentCompany = company;
    }
}

@end
