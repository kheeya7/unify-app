//
//  CompanyDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 4/28/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "CompanyDetailViewController.h"

@interface CompanyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *CompanyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CompanyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderBackgroundImage;

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.CompanyNameLabel setText:self.currentCompany.name];
    
    UIImage *image = [self.currentCompany getImageLogo];
    [self.CompanyLogo setImage: image];
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
