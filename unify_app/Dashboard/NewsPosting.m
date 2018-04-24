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
              post:(NSString *)aPost
      userPhotoUrl:(NSString *)aPhotoUrl{
    if (self = [super init]) {
        self.key = aKey;
        self.name = aName;
        self.timestamp = aTimestamp;
        self.postText = aPost;
        self.photoUrl = aPhotoUrl;
    }
    
    return self;
}

- (UIImage *) getUserPhoto {
    NSString *userPhotoUrlString = self.photoUrl;
    
    if (userPhotoUrlString != nil && userPhotoUrlString.length > 0) {
        NSString *httpsUrlString = [userPhotoUrlString stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
        NSURL *photoUrl = [NSURL URLWithString:httpsUrlString];
        NSData *photoData = [[NSData alloc] initWithContentsOfURL: photoUrl];
        UIImage *userImage = [UIImage imageWithData:photoData];
        
        return userImage;
        
    } else {
        // User-photo-placeholder image will be added later
        return [UIImage imageNamed:@"company-logo-placeholder"];
    }
}

@end
