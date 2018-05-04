//
//  RecentActivityCell.h
//  unify_app
//
//  Created by Kate Sohng on 5/3/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timePosted;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end
