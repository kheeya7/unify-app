//
//  tableViewInScrollViewController.m
//  unify_app
//
//  Created by Shelby Hulbert on 4/26/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "tableViewInScrollViewController.h"

@interface tableViewInScrollViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) float scrollViewContentHeight;
@property (nonatomic) float screenHeight;

@end

@implementation tableViewInScrollViewController
- (void)setup
{

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.screenHeight = screenBounds.size.height;
    self.scrollViewContentHeight = 1200;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollViewContentHeight);
    self.scrollView.delegate = self;
    self.tableView.delegate = self;
    self.scrollView.bounces = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.dataSource = self;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    // THIS WORKS BUT IS A BIT BUGGY
    if (scrollView == self.scrollView) {
        float yOffsetScrollView = self.scrollView.contentOffset.y;
        if (yOffsetScrollView >= 100) {
            NSLog(@"turning OFF scroll view and turning ON tableview");
            self.scrollView.scrollEnabled = NO;
            self.tableView.scrollEnabled = YES;
        }
    }

    if (scrollView == self.tableView) {
        float yOffsetTableView = self.tableView.contentOffset.y;
        NSLog(@"yOffset: %f", yOffsetTableView);
        NSLog(@"scrollView == self.tableView");
        if (yOffsetTableView <= 0) {
            NSLog(@"turning ON scroll view and turning OFF tableview");
            self.scrollView.scrollEnabled = YES;
            self.tableView.scrollEnabled = NO;
        }
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString *content = [NSString stringWithFormat:@"this is cell # %d", indexPath.row];
    cell.textLabel.text = content;
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}


@end
