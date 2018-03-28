//
//  JobPosting.h
//  unify_app
//
//  Created by Kate Sohng on 2/18/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobPosting : NSObject

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *company;
@property (nonatomic) NSString *jobDescription;
@property (nonatomic) NSString *companyLogoUrlString;

@end
