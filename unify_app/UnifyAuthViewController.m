//
//  UnifyAuthViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/20/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "UnifyAuthViewController.h"

@interface UnifyAuthViewController ()

@end

@implementation UnifyAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int width = UIScreen.mainScreen.bounds.size.width;
    int height = UIScreen.mainScreen.bounds.size.height;
    
    UIImageView* imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    imageViewBackground.image = [UIImage imageNamed:@"background"];
    
    imageViewBackground.contentMode = UIViewContentModeScaleAspectFill;
    
    [[self view] insertSubview:imageViewBackground atIndex:0];
}

// As of 02/20 There is a bug on FirebaseUI where the init for the custom AuthViewController fails
// I followed the workaround suggestion on the following thread:
// https://github.com/firebase/FirebaseUI-iOS/issues/128
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil authUI:(FUIAuth *)authUI {
    return [super initWithNibName:@"FUIAuthPickerViewController" bundle: nibBundleOrNil authUI:authUI];
}

// Same as above. This is needed to workaround the bug on FirebaseUI
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}
@end
