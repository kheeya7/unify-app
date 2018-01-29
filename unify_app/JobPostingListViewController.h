#import <UIKit/UIKit.h>

@interface JobPostingListViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemText;
- (IBAction)onAdd:(id)sender;

@end
