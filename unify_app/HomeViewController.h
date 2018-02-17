//
//  HomeViewController.h
//  unify_app
//
//  Created by Kate Sohng on 2/16/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UIKit;
@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface HomeViewController : UIViewController <FUIAuthDelegate, FIRAuthUIDelegate>

@end
