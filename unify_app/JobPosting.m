//
//  JobPosting.m
//  unify_app
//
//  Created by Kate Sohng on 2/18/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "JobPosting.h"

@implementation JobPosting

- (id) initWithKey: (NSString *)aKey
             title: (NSString *)aTitle
           company: (NSString *)aCompany {
    if (self = [super init]) {
        self.key = aKey;
        self.title = aTitle;
        self.company = aCompany;
    }
    
    return self;
}

@end
