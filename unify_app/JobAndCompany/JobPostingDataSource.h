//
//  JobPostingDataSource.h
//  unify_app
//
//  Created by Kate Sohng on 4/22/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobPostingDataSource : NSObject <UITableViewDataSource>

-(id) initWithTableView: (UITableView *) aTableView;
-(void) loadData;

@end
