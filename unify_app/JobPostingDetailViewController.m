//
//  JobPostingDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/25/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "JobPostingDetailViewController.h"

@interface JobPostingDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel2;
@property (weak, nonatomic) IBOutlet UIWebView *jobDescriptionWebView;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImageView2;

@end

@implementation JobPostingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.titleLabel setText:[self.currentJobPosting title]];
    [self.companyLabel setText:[self.currentJobPosting company]];
    [self.companyLabel2 setText:[self.currentJobPosting company]];
    [self.jobDescriptionWebView loadHTMLString:self.currentJobPosting.jobDescription baseURL:(nil)];
    
    NSString *logoUrlString = [[self currentJobPosting] companyLogoUrlString];
    NSString *httpsUrlString = [logoUrlString stringByReplacingOccurrencesOfString:@"http:"withString:@"https:"];
    NSURL *imageUrl = [NSURL URLWithString: httpsUrlString];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageUrl];
    UIImage *image = [UIImage imageWithData: imageData];
    [self.companyLogoImageView setImage:image];
    UIImage *image2 = [UIImage imageWithData: imageData];
    [self.companyLogoImageView2 setImage:image2];

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
