//
//  PulloutMenuViewController.m
//  unify_app
//
//  Created by rcaligan on 4/9/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "PulloutMenuViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "UnifyAuthViewController.h"

@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface PulloutMenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *membersField;
@property (weak, nonatomic) IBOutlet UIButton *myGroupsField;
@property (weak, nonatomic) IBOutlet UIButton *savedJobsField;
@property (weak, nonatomic) IBOutlet UIButton *aboutField;
@property (weak, nonatomic) IBOutlet UIButton *editProfileField;
@property (weak, nonatomic) IBOutlet UIButton *contactUsField;

- (BOOL)signOut:(NSError *_Nullable *_Nullable)error;

@end

@implementation PulloutMenuViewController

- (IBAction)logoutClick:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.currentUser = nil;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        SignInViewController *signInVC = (SignInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"signInView"];
        signInVC.modalPresentationStyle = UIModalPresentationPopover;
        [signInVC resetSignInView];
        
        [self presentViewController:signInVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.membersField.layer.borderWidth = 1.0f;
    self.membersField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.membersField.layer.cornerRadius = 8;
    
    self.myGroupsField.layer.borderWidth = 1.0f;
    self.myGroupsField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.myGroupsField.layer.cornerRadius = 8;
    
    self.savedJobsField.layer.borderWidth = 1.0f;
    self.savedJobsField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.savedJobsField.layer.cornerRadius = 8;
    
    self.aboutField.layer.borderWidth = 1.0f;
    self.aboutField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.aboutField.layer.cornerRadius = 8;
    
    self.editProfileField.layer.borderWidth = 1.0f;
    self.editProfileField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.editProfileField.layer.cornerRadius = 8;
    
    self.contactUsField.layer.borderWidth = 1.0f;
    self.contactUsField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.contactUsField.layer.cornerRadius = 8;
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
