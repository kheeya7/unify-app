//
//  CompanyDataSource.h
//  unify_app
//
//  Created by Kate Sohng on 4/22/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface CompanyDataSource : NSObject <UITableViewDataSource>

- (id) initWithTableView: (UITableView *) aTableCView;
- (void) loadData;
-(Company *) getCompanyAtRow: (NSInteger) index;

@end
