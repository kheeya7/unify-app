#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>
#import <Foundation/Foundation.h>


#pragma mark * Block Definitions

typedef void (^QSCompletionBlock) (void);

#pragma mark * JobPostingService public interface


@interface JobPostingService : NSObject

@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSCoreDataStore *store;

+ (JobPostingService *)defaultService;

- (void)addItem:(NSDictionary *)item
     completion:(QSCompletionBlock)completion;

- (void)completeItem:(NSDictionary *)item
          completion:(QSCompletionBlock)completion;

- (void)syncData:(QSCompletionBlock)completion;

@end
