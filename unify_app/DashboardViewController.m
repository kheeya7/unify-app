//
//  DashboardViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/19/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    User *currentUser = appDelegate.currentUser;
    
    [self displayNameLabel].text = [NSString stringWithFormat:@"Hi! %@", currentUser.displayName];
    [self emailLabel].text = currentUser.email;
    
    NSData *data = [NSData dataWithContentsOfURL:currentUser.photoUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    [self.photoView setImage:image];
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
