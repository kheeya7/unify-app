//
//  User.h
//  unify_app
//
//  Created by Kate Sohng on 2/19/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSURL *photoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *occupation;
@property (nonatomic) NSString *additionalDetail;
@property (nonatomic) NSString *age;
@property (nonatomic) NSString *linkedIn;
@property (nonatomic) NSString *interest;


- (id) initWithId: (NSString *)aUid
      displayName: (NSString *)aDisplayName
            email: (NSString *)aEmail
         photoUrl: (NSString *)aPhotoUrl;

- (NSDictionary *) getDictionaryFormat;

- (UIImage *) getUserPhoto;

@end
