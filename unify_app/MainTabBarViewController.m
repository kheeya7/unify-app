//
//  MainTabBarViewController.m
//  unify_app
//
//  Created by Kate Sohng on 3/5/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "NewsPosting.h"
#import "ProfileViewController.h"
@import Firebase;

@interface MainTabBarViewController ()


@property (strong, nonatomic) NSMutableArray *allPostings;
@property (strong, nonatomic) NSMutableArray *userPostings;

@property (strong, nonatomic) FIRDatabaseReference *refPostings;
@property (weak, nonatomic) User *currentUser;


@end

@implementation MainTabBarViewController

- (void)setup
{
    self.selectedIndex = 2;
    
    self.refPostings = [[[FIRDatabase database] reference] child:@"news"];
    
    self.allPostings = [[NSMutableArray alloc] initWithCapacity:50];
    self.userPostings = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    NSData *data = [NSData dataWithContentsOfURL:(self.currentUser.photoUrl)];
    
    [self listenForNews];
    
}
-(void)listenForNews {
    [self.refPostings observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if(snapshot.childrenCount > 0) {
            // clear the list
            [self.allPostings removeAllObjects];
            
            // iterate through data
            for (FIRDataSnapshot* child in snapshot.children){
                NSDictionary *savedNewsPosting = [child value];
                NSString *aKey = [savedNewsPosting objectForKey:@"id"];
                NSString *aName = [savedNewsPosting objectForKey:@"user"];
                NSString *aTimestamp = [savedNewsPosting objectForKey:@"postTime"];
                NSString *aPost = [savedNewsPosting objectForKey:@"postText"];
                NSString *aPhotoUrl = [savedNewsPosting objectForKey:@"userPhotoUrl"];
                
                NewsPosting *newsPosting = [[NewsPosting alloc] initWithKey:aKey name:aName time:aTimestamp post:aPost userPhotoUrl:aPhotoUrl];
                
                [self.allPostings insertObject:newsPosting atIndex:0];
            }
            [self filterPostingsByUser];
            [self passDataToChildViewControllers];
        }
    }];
}
- (void)filterPostingsByUser
{
    for (NewsPosting *posting in self.allPostings) {
        if ([posting.name isEqualToString:self.currentUser.displayName]) {
            [self.userPostings addObject:posting];
        }
    }
}
- (void)passDataToChildViewControllers
{
    for (UIViewController *childVC in self.childViewControllers) {
        
        if ([childVC isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *navVC = (UINavigationController *)childVC;
            
            if ([navVC.topViewController isKindOfClass:[ProfileViewController class]]) {
                ProfileViewController *profileVC = (ProfileViewController *)navVC.topViewController;
                profileVC.userPostings = self.userPostings;
            }
            
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}



@end
