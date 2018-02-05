#import <UIKit/UIKit.h>

@interface JobPostingListViewController : UITableViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *itemText;
- (IBAction)onAdd:(id)sender;

@end
