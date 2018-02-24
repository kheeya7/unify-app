//
//  NewUserProfileViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "NewUserProfileViewController.h"

@interface NewUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *yourNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *occupationField;
@property (weak, nonatomic) IBOutlet UITextView *additionalDetailField;

@end

@implementation NewUserProfileViewController
- (IBAction)skipButton:(id)sender {
    [self performSegueWithIdentifier:@"SegueToMain2" sender:self];
}
- (IBAction)saveButton:(id)sender {
        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
