//
//  NewsPostingCell.h
//  unify_app
//
//  Created by Kate Sohng on 4/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsPostingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;

@end
