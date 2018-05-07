//
//  CompanyDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 4/28/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyDataSource.h"
#import "Company.h"

@import Firebase;
@import FirebaseStorage;

@interface CompanyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *CompanyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CompanyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderBackgroundImage;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView4;

- (void)setBackgroundImage;

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.CompanyNameLabel setText:self.currentCompany.name];
    
    UIImage *image = [self.currentCompany getImageLogo];
    [self.CompanyLogo setImage: image];
    
    [self setBackgroundImage];
    
    self.progressView.progress = self.currentCompany.femaleRatio.floatValue / 100;
    
    [self setBadges];
}

- (void)setBadges {
    if (self.currentCompany.badges != nil) {
        for(NSNumber *aBadgeNumber in self.currentCompany.badges) {
            if (aBadgeNumber.intValue == 1) {
                self.badgeImageView1.alpha = 1;
            } else if (aBadgeNumber.intValue == 2) {
                self.badgeImageView2.alpha = 1;
            } else if (aBadgeNumber.intValue == 3) {
                self.badgeImageView3.alpha = 1;
            } else if (aBadgeNumber.intValue == 4) {
                self.badgeImageView4.alpha = 1;
            }
        }
    }
}

- (void)setBackgroundImage {
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];
    
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];
    
    NSString *imageFileName = [self.currentCompany companyBackground];
    FIRStorageReference *imageRef = [storageRef child:imageFileName];
    
    [imageRef dataWithMaxSize:2000000 completion:^(NSData * _Nullable data, NSError * _Nullable error){
        if (error != nil) {
            // NSLog(error);
        } else {
            UIImage *image = [UIImage imageWithData: data];
            [self.HeaderBackgroundImage setImage: image];
        }
    }];
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
