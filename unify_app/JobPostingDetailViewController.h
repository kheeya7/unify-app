//
//  JobPostingDetailViewController.h
//  unify_app
//
//  Created by Kate Sohng on 2/4/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JobPostingDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObject *jobPostingItem;

@end
