//
//  SignInViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/18/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "UnifyAuthViewController.h"

@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface SignInViewController ()

@end

@implementation SignInViewController

bool shouldShowAuthUI = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (shouldShowAuthUI) {
        FUIAuth *authUI = [FUIAuth defaultAuthUI];
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self;
        
        NSArray<id<FUIAuthProvider>> *providers = @[
                                                    [[FUIGoogleAuth alloc] init],
                                                    ];
        
        authUI.providers = providers;
        
        UnifyAuthViewController *authViewController = [[UnifyAuthViewController alloc] initWithAuthUI:authUI];
        
        [self presentViewController:authViewController animated:YES completion:nil];
        
        shouldShowAuthUI = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
         error:(nullable NSError *)error {
    User *loggedInUser = [[User alloc] initWithId:user.uid
                                      displayName:user.displayName
                                            email:user.email
                                         photoUrl:user.photoURL];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentUser = loggedInUser;
    
    FIRDatabaseReference *usersDBRef = [[[FIRDatabase database] reference] child:@"users"];
    [[usersDBRef child:loggedInUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            // If user is already saved, just move to the main
            [self performSegueWithIdentifier:@"SegueToMain" sender:self];
        } else {
            // If user is not saved, go to additional profile setting
            [self performSegueWithIdentifier:@"SegueToAdditionalProfile" sender:self];
        }
    }];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[FUIAuth defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */


@end
