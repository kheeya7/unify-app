//
//  NotificationViewController.m
//  unify_app
//
//  Created by user139262 on 4/30/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize message;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
