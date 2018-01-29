#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>
#import "JobPostingService.h"
#import "QSAppDelegate.h"

#pragma mark * Private interace


@interface JobPostingService()

@property (nonatomic, strong)   MSSyncTable *syncTable;

@end


#pragma mark * Implementation


@implementation JobPostingService


+ (JobPostingService *)defaultService
{
    // Create a singleton instance of JobPostingService
    static JobPostingService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[JobPostingService alloc] init];
    });
    
    return service;
}

-(JobPostingService *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key   
        self.client = [MSClient clientWithApplicationURLString:@"https://unify-app.azurewebsites.net"];
    
        QSAppDelegate *delegate = (QSAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        self.store = [[MSCoreDataStore alloc] initWithManagedObjectContext:context];
        
        self.client.syncContext = [[MSSyncContext alloc] initWithDelegate:nil dataSource:self.store callback:nil];
        
        // Create an MSSyncTable instance to allow us to work with the JobPosting table
        self.syncTable = [_client syncTableWithName:@"JobPosting"];
    }
    
    return self;
}

-(void)addItem:(NSDictionary *)item completion:(QSCompletionBlock)completion
{
    // Insert the item into the JobPosting table and add to the items array on completion
    [self.syncTable insert:item completion:^(NSDictionary *result, NSError *error)
    {
        [self logErrorIfNotNil:error];
    
        [self syncData: ^{
            // Let the caller know that we finished
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }];
    }];
}

-(void)completeItem:(NSDictionary *)item completion:(QSCompletionBlock)completion
{
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [item mutableCopy];
    [mutable setObject:@YES forKey:@"complete"];
    
    // Update the item in the JobPosting table and remove from the items array on completion
    [self.syncTable update:mutable completion:^(NSError *error)
    {
        [self logErrorIfNotNil:error];
        
        [self syncData: ^{
            // Let the caller know that we finished
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }];
    }];
}

-(void)syncData:(QSCompletionBlock)completion
{
    // push all changes in the sync context, then pull new data
    [self.client.syncContext pushWithCompletion:^(NSError *error) {
        [self logErrorIfNotNil:error];
        [self pullData:completion];
    }];
}

-(void)pullData:(QSCompletionBlock)completion
{
    MSQuery *query = [self.syncTable query];
    
    // Pulls data from the remote server into the local table.
    // We're pulling all items and filtering in the view
    // query ID is used for incremental sync
    [self.syncTable pullWithQuery:query queryId:@"allJobPostingItems" completion:^(NSError *error) {
        [self logErrorIfNotNil:error];
        
        // Let the caller know that we have finished
        if (completion != nil) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    }];
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
    }
}

@end
