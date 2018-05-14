//
//  CompanyDetailViewController.m
//  unify_app
//
//  Created by Kate Sohng on 4/28/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyDataSource.h"
#import "Company.h"
#import "BadgeViewController.h"

@import Firebase;
@import FirebaseStorage;

@interface CompanyDetailViewController() <UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *CompanyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CompanyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderBackgroundImage;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView4;
@property (weak, nonatomic) IBOutlet UILabel *companyDescription;

@property (strong, nonatomic) BadgeViewController *badgeViewController;

- (void)setBackgroundImage;

@end

@implementation CompanyDetailViewController
- (IBAction)onBadgeClicked:(id)sender {
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"badgeView"];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.delegate = self;
    
    // in case we don't have a bar button as reference
    popController.sourceView = self.view;
    popController.sourceRect = CGRectMake(30, 50, 10, 10);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.badgeViewController = [[BadgeViewController alloc] init];
    
    [self.CompanyNameLabel setText:self.currentCompany.name];
    
    [self.companyDescription sizeToFit];
    [self.companyDescription  setText:self.currentCompany.companyDescription];
    
    UIImage *image = [self.currentCompany getImageLogo];
    [self.CompanyLogo setImage: image];
    
    [self setBackgroundImage];
    
    self.progressView.progress = self.currentCompany.femaleRatio.floatValue / 100;
    self.progressView2.progress = self.currentCompany.wouldRecommend.floatValue / 100;
   
    [self setBadges];
}

- (void)setBadges {
    if (self.currentCompany.badges != nil) {
        for(NSNumber *aBadgeNumber in self.currentCompany.badges) {
            if (aBadgeNumber.intValue == 1) {
                self.badgeImageView1.alpha = 1;
            } else if (aBadgeNumber.intValue == 2) {
                self.badgeImageView2.alpha = 1;
            } else if (aBadgeNumber.intValue == 4) {
                self.badgeImageView4.alpha = 1;
            }
        }
    }
}

- (void)setBackgroundImage {
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];
    
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];
    
    NSString *imageFileName = [self.currentCompany companyBackground];
    FIRStorageReference *imageRef = [storageRef child:imageFileName];
    
    [imageRef dataWithMaxSize:2000000 completion:^(NSData * _Nullable data, NSError * _Nullable error){
        if (error != nil) {
            // NSLog(error);
        } else {
            UIImage *image = [UIImage imageWithData: data];
            [self.HeaderBackgroundImage setImage: image];
        }
    }];
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

# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
}


@end
