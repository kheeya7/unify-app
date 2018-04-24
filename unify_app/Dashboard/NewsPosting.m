//
//  NewsPosting.m
//  unify_app
//
//  Created by Kate Sohng on 4/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "NewsPosting.h"

@implementation NewsPosting

- (id) initWithKey:(NSString *)aKey
              name:(NSString *)aName
              time:(NSString *)aTimestamp
              post:(NSString *)aPost {
    if (self = [super init]) {
        self.key = aKey;
        self.name = aName;
        self.timestamp = aTimestamp;
        self.postText = aPost;
    }
    
    return self;
}



@end
