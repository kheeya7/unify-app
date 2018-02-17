//
//  HomeViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/16/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "HomeViewController.h"
#import "QSAppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
bool didShowAuthUI = false;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!didShowAuthUI) {
        didShowAuthUI = true;

        FUIAuth *authUI = [FUIAuth defaultAuthUI];
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self;
        
        NSArray<id<FUIAuthProvider>> *providers = @[
                                                    [[FUIGoogleAuth alloc] init],
                                                    ];
        authUI.providers = providers;
        
        UIViewController *authViewController = [authUI authViewController];
        
        [self presentViewController:authViewController animated: YES completion: nil];
    }
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
         error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
    NSLog([user displayName]);
    
    // TODO: needs to navigate to the next controller
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[FUIAuth defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
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
