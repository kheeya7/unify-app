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

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation JobPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
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
