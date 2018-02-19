//
//  JobPostingViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/17/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "JobPostingViewController.h"

@import Firebase;

@interface JobPostingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldJobTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCompanyName;
@property (weak, nonatomic) IBOutlet UITableView *tableViewJobPostings;

@property (strong, nonatomic) FIRDatabaseReference *refJobPostings;

@property (strong, nonatomic) NSMutableArray *jobPostings;

@end

@implementation JobPostingViewController

- (IBAction)onAddJobPosting:(id)sender {
    [self addJobPosting];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refJobPostings = [[[FIRDatabase database] reference] child:@"jobPostings"];
    
    self.jobPostings = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refJobPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.childrenCount > 0) {
            // cleaar the list
            [self.jobPostings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children) {
                NSDictionary *savedJobPosting = [child value];
                NSString *aKey = [savedJobPosting objectForKey:@"id"];
                NSString *aTitle = [savedJobPosting objectForKey:@"title"];
                NSString *aCompany = [savedJobPosting objectForKey:@"company"];
                
                JobPosting *jobPosting = [[JobPosting alloc] initWithKey:aKey title:aTitle company:aCompany];
                
                [self.jobPostings addObject:jobPosting];
            }
            
            [[self tableViewJobPostings] reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addJobPosting {
    NSString *key = [[self.refJobPostings childByAutoId] key];
    
    NSDictionary *jobPosting = @{
                                 @"id": key,
                                 @"title": self.textFieldJobTitle.text,
                                 @"company": self.textFieldCompanyName.text
                                };
    
    [[self.refJobPostings child:key] setValue: jobPosting];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    JobPosting *jobPosting = [self jobPostings][indexPath.row];
    
    cell.textLabel.text = [jobPosting title];
    cell.detailTextLabel.text = [jobPosting company];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jobPostings count];
}

@end
