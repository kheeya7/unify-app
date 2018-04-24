//
//  NewsPosting.h
//  unify_app
//
//  Created by Kate Sohng on 4/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPosting : NSObject

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *timestamp;
@property (nonatomic) NSString *postText;

- (id) initWithKey: (NSString *)aKey
              name: (NSString *)aName
              time: (NSString *)aTimestamp
              post: (NSString *)aPost;

@end
