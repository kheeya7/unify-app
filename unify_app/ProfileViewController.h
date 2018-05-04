//
//  ProfileViewController.h
//  unify_app
//
//  Created by Savannah Schuchardt on 3/28/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *userPostings;

//@property (weak, nonatomic) User *currentUser;

@end
