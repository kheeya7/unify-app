//
//  JobPostingDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/4/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "JobPostingDetailViewController.h"

@interface JobPostingDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIWebView *jobDescriptionWebView;

@end

@implementation JobPostingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // update the view
    [self configureView];
}

- (void) configureView {
    // Update the detailed job posting
    if (self.jobPostingItem) {
        self.titleLabel.text = [self.jobPostingItem valueForKey:@"title"];
        self.companyLabel.text = [self.jobPostingItem valueForKey:@"company"];
        [self.jobDescriptionWebView loadHTMLString:[self.jobPostingItem valueForKey:@"jobDescription"] baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
