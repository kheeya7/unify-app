//
//  JobPostingDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/25/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#include <stdlib.h>
#import "JobPostingDetailViewController.h"

@import Firebase;
@import FirebaseStorage;

@interface JobPostingDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIWebView *jobDescriptionWebView;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void)setBackgroundImage;

@end

@implementation JobPostingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.titleLabel setText:[self.currentJobPosting title]];
    [self.companyLabel setText:[self.currentJobPosting company]];
    
    [self.jobDescriptionWebView loadHTMLString:self.currentJobPosting.jobDescription baseURL:(nil)];
    
    UIImage *image = [self.currentJobPosting getImageLogo];
    [self.companyLogoImageView2 setImage:image];
    
    [self setBackgroundImage];
}

- (void)setBackgroundImage {
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];
    
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];
    
    // We have image numbered from 1 to 14.
    // Since arc4random_uniform(14) generates random number from 0 to 13, we do plus 1.
    int randomImageNumber = arc4random_uniform(14) + 1;
    NSString *imageFileName = [NSString stringWithFormat:@"unify-%d.jpg", randomImageNumber];
    FIRStorageReference *imageRef = [storageRef child:imageFileName];
    
    [imageRef dataWithMaxSize:1000000 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(error);
        } else {
            UIImage *image = [UIImage imageWithData: data];
            [self.backgroundImageView setImage:image];
        }
    }];
}

- (IBAction)applyButton:(id)sender {
   // NSLog(self.currentJobPosting.originUrlString);
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentJobPosting.originUrlString]];
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
