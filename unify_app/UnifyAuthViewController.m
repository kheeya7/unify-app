//
//  UnifyAuthViewController.m
//  unify_app
//
//  Created by Kate Sohng on 2/21/18.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil authUI:(FUIAuth *)authUI {
    return [super initWithNibName:@"FUIAuthPickerViewController" bundle: nibBundleOrNil authUI:authUI];
}

// Same as above. This is needed to workaround the bug on FirebaseUI
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
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
