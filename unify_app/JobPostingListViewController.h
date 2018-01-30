// Header file for job posting list view controller

#import <UIKit/UIKit.h>

@interface JobPostingListViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemText;
- (IBAction)onAdd:(id)sender;

@end
