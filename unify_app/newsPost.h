//
//  newsPost.h
//  unify_app
//
//  Created by Shelby Hulbert on 4/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsPost : NSObject

@property (strong, nonatomic) UIImage *userImage;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *postText;

- (instancetype)initWithDate:(NSString *)dateString;
- (NSDictionary *)getDictionaryFormat;

@end
