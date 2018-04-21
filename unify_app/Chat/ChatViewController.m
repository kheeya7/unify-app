//
//  ChatViewController.m
//  unify_app
//
//  Created by Kate Sohng on 4/13/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "ChatViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "ChatSenderCell.h"
#import "ChatReceiverCell.h"

@import Firebase;

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextField *chatMessageInput;

@property (strong, nonatomic) FIRDatabaseReference *refChat;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) User *currentUser;

@end

@implementation ChatViewController

- (IBAction)onSend:(id)sender {
    [self addMessageToChat];
    self.chatMessageInput.text = @"";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refChat = [[[FIRDatabase database] reference] child:@"globalChat"];
    
    self.messages = [[NSMutableArray alloc] initWithCapacity:50];
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.currentUser = appDelegate.currentUser;
    
    [self listenForNewMessage];
}

-(void)listenForNewMessage {
    [self.refChat observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        
        NSDictionary *newMessage = snapshot.value;
        
        [self.messages addObject: newMessage];
        
        [self.chatTableView reloadData];
        
        //Auto scroll-up when the message hit the bottom of the chat
        if (self.messages.count > 0)
        {
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMessageToChat {
    NSString *key = [[self.refChat childByAutoId] key];
    
    NSDictionary *message = @{
                              @"id": key,
                              @"messageBody": self.chatMessageInput.text,
                              @"sender": self.currentUser.displayName,
                              @"senderUid":
                                  self.currentUser.uid,
                              @"messageTime":
                                  [self getTimestampString]
                              };
    [[self.refChat child:key] setValue: message];
}

- (NSString *)getTimestampString {
    // Get current device time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Display in 12HR/24HR (ie.11:25pm or 23:25) format according to User Setting
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    return currentTime;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary *message = self.messages[indexPath.row];
    
    if ([[message objectForKey:@"senderUid"] isEqualToString:self.currentUser.uid]) {
        ChatSenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSender"];
        
        cell.messageLabel.text = [message objectForKey:@"messageBody"];
        cell.timeStampLabel.text = [message objectForKey:@"messageTime"];
        
        return cell;
    } else {
        ChatReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReceiver"];
        
        cell.messageLabel.text = [message objectForKey:@"messageBody"];
        cell.detailTextLabel.text = [message objectForKey:@"sender"];
        cell.timeStampLabel.text = [message objectForKey:@"messageTime"];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = self.messages[indexPath.row];
    
    if ([[message objectForKey:@"senderUid"] isEqualToString:self.currentUser.uid])
    {
        return 55.0;
    } else {
        return 65.0;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

@end
