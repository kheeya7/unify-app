//
//  User.m
//  unify_app
//
//  Created by Kate Sohng on 2/19/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithId: (NSString *)aUid
      displayName: (NSString *)aDisplayName
            email: (NSString *)aEmail
         photoUrl: (NSURL *)aPhotoUrl {
    if (self = [super init]) {
        self.uid = aUid;
        self.displayName = aDisplayName;
        self.email = aEmail;
        self.photoUrl = aPhotoUrl;
        self.nickName = @"";
        self.occupation = @"";
        self.additionalDetail = @"";
    }    
    return self;
}

- (NSDictionary *) getDictionaryFormat {
    NSDictionary *dict = @{
                           @"uid":self.uid,
                           @"displayName":self.displayName,
                           @"nickName":self.nickName,
                           @"email":self.email,
                           @"occupation":self.occupation,
                           @"additionalDetail":self.additionalDetail,
                           @"photoUrl":[self.photoUrl absoluteString]
                           };
    return dict;
}

@end
