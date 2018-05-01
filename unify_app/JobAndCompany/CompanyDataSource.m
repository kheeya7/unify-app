//
//  CompanyDataSource.m
//  unify_app
//
//  Created by Kate Sohng on 4/22/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "CompanyDataSource.h"
#import "Company.h"

@import Firebase;

@interface CompanyDataSource (){
    dispatch_queue_t imageQueue;
}

@property (strong, nonatomic) FIRDatabaseReference *refCompaniesPostings;
@property (strong, nonatomic) NSMutableArray *companies;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation CompanyDataSource

- (id) initWithTableView: (UITableView *)aTableCView {
    if (self = [super init]) {
        self.tableView = aTableCView;
    }
    return self;
}

- (Company *) getCompanyAtRow:(NSInteger)index {
    return self.companies[index];
}

- (void) loadData {
    if (!imageQueue) {
        imageQueue = dispatch_queue_create("imageLoadQueue", NULL);
    }
    
    self.refCompaniesPostings = [[[FIRDatabase database] reference] child:@"companies"];
    
    self.companies = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self.refCompaniesPostings observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        if(snapshot.childrenCount > 0) {
            // clear the list
            [self.companies removeAllObjects];
            
            // itrate through data
            for (FIRDataSnapshot* child in snapshot.children){
                NSDictionary *companyDict = [child value];
                NSString *aKey = [companyDict objectForKey:@"id"];
                NSString *aName = [companyDict objectForKey:@"name"];
                NSString *aCompanyDescription = [companyDict objectForKey:@"description"];
                NSString *aCompanyLogoUrlString = [companyDict objectForKey:@"logo"];
                NSString *aLocation = [companyDict objectForKey:@"location"];
                NSString *aBackgroundImageString = [companyDict objectForKey:@"backgroundPhoto"];
                
                Company *company = [[Company alloc] init];
                company.key = aKey;
                company.name = aName;
                company.companyDescription = aCompanyDescription;
                company.companyLogoUrlString = aCompanyLogoUrlString;
                company.location = aLocation;
                company.companyBackground = aBackgroundImageString;
                
                [self.companies addObject:company];
            }
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview data source and data delegate methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell"];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:0];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *detail = (UILabel *)[cell viewWithTag:2];
    
    Company *company = self.companies[indexPath.row];
    
    title.text = company.name;
    detail.text = company.location;
    
    imageView.image = [UIImage imageNamed:@"company-logo-placeholder"];
    
    // dispatch the getting logo and resizing to the custom queue to unblock main queue
    dispatch_async(imageQueue, ^{
        UIImage *image = [company getImageLogo];
        
        // Resize the image so that icons have same size
        CGSize newSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Since we are modifying the UI, dispatch bak on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell* updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Check if the cell is still visible and not reused by other
            if (updateCell) {
                UIImageView* imageView = (UIImageView *)[updateCell viewWithTag:0];
                imageView.image = newImage;
            }
        });
    });
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.companies count];
}

@end
