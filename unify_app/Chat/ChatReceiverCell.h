//
//  ChatReceiverCell.h
//  unify_app
//
//  Created by Kate Sohng on 4/21/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatReceiverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@end
