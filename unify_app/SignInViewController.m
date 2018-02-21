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
        
        UnifyAuthViewController* authViewController = [UnifyAuthViewController alloc];
        [authViewController initWithAuthUI:authUI];
        
        // UINavigationController *authViewController = [authUI authViewController];
        
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
    
    [self performSegueWithIdentifier:@"SegueAfterSignIn" sender:self];
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
