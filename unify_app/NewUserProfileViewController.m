//
//  NewUserProfileViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "NewUserProfileViewController.h"
@import Firebase;

@interface NewUserProfileViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *yourNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *occupationField;
@property (weak, nonatomic) IBOutlet UITextView *additionalDetailField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *linkedInField;
@property (weak, nonatomic) IBOutlet UITextField *interestField;
@property BOOL moved;

@end

@implementation NewUserProfileViewController
- (IBAction)skipButton:(id)sender {
    [self performSegueWithIdentifier:@"SegueToMain2" sender:self];
}
- (IBAction)saveButton:(id)sender {
    // getting the AppDelegate object
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    User *currentUser = appDelegate.currentUser;
    
    // set the user properties from the user input
    currentUser.displayName = [self yourNameField].text;
    currentUser.nickName = [self nickNameField].text;
    currentUser.email = [self emailField].text;
    currentUser.occupation = [self occupationField].text;
    currentUser.additionalDetail = [self additionalDetailField].text;
    currentUser.age = [self ageField].text;
    currentUser.linkedIn = [self linkedInField].text;
    currentUser.interest = [self interestField].text;
    
    FIRDatabaseReference *usersDBRef = [[[FIRDatabase database] reference] child:@"users"];
    
    [[usersDBRef child:currentUser.uid] setValue:[currentUser getDictionaryFormat] withCompletionBlock:^(NSError * _Nullable error,FIRDatabaseReference * _Nonnull ref){
        // after the user is saved, we navigate to the main
        [self performSegueWithIdentifier:@"SegueToMain2" sender:self];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    User *currentUser = appDelegate.currentUser;

    [self.nickNameField resignFirstResponder];
    
    [self yourNameField].text = currentUser.displayName;
    [self emailField].text = currentUser.email;
    
    self.additionalDetailField.layer.borderWidth = 1.0f;
    self.additionalDetailField.layer.borderColor = [[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:0.30] CGColor];
    self.additionalDetailField.layer.cornerRadius = 8;
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

#pragma mark - text input box keyboard navigation
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if(self.moved) {
        [self animateViewToPosition:self.view directionUP:NO];
    }
    self.moved = NO;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.nickNameField) {
        return;
    }

    if(!self.moved) {
        [self animateViewToPosition:self.view directionUP:YES];
        self.moved = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if(self.moved) {
        [self animateViewToPosition:self.view directionUP:NO];
    }
    self.moved = NO;
}

-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up {
    
    const int movementDistance = -210; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}

@end
