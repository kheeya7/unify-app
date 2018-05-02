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
        self.age = @"";
        self.linkedIn = @"";
        self.interest = @"";
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
                           @"photoUrl":self.photoUrl,
                           @"age":self.age,
                           @"linkedIn":self.linkedIn,
                           @"interest":self.interest
                           };
    return dict;
}

- (UIImage *) getUserPhoto {
    NSString *logoUrlString = self.photoUrl;
    
    if (logoUrlString != nil && logoUrlString.length > 0) {
        NSString *httpsUrlString = [logoUrlString stringByReplacingOccurrencesOfString:@"http:"withString:@"https:"];
        NSURL *imageUrl = [NSURL URLWithString: httpsUrlString];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageUrl];
        UIImage *image = [UIImage imageWithData: imageData];
        
        return image;
    } else {
        return [UIImage imageNamed:@"company-logo-placeholder"];
    }
}

@end
