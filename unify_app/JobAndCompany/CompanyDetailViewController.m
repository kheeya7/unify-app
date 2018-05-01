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
