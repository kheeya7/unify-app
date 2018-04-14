//
//  ChatViewController.m
//  unify_app
//
//  Created by Kate Sohng on 4/13/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "ChatViewController.h"

@import Firebase;

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextField *chatMessageInput;

@property (strong, nonatomic) FIRDatabaseReference *refChat;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation ChatViewController

- (IBAction)onSend:(id)sender {
    [self addMessageToChat];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refChat = [[[FIRDatabase database] reference] child:@"globalChat"];
    
    self.messages = [[NSMutableArray alloc] initWithCapacity:50];
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.refChat observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.childrenCount > 0) {
            [self.messages removeAllObjects];
            
            for (FIRDataSnapshot* child in snapshot.children) {
                NSDictionary *savedMessage = [child value];
                
                [self.messages addObject: savedMessage];
            }
            
            [self.chatTableView reloadData];
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
                              @"sender": @"kate"
                              };
    [[self.refChat child:key] setValue: message];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReceiver"];
    
    NSDictionary *message = self.messages[indexPath.row];
    
    cell.textLabel.text = [message objectForKey:@"messageBody"];
    cell.detailTextLabel.text = [message objectForKey:@"sender"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

@end
