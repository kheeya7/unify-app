//
//  newsPost.m
//  unify_app
//
//  Created by Shelby Hulbert on 4/23/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import "newsPost.h"

@implementation newsPost

- (instancetype)initWithDate:(NSString *)dateString
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        self.dateString = dateString;
        self.date = [dateFormatter dateFromString:dateString];
    }
    return self;
}

- (NSDictionary *)getDictionaryFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *longDateString = [NSString stringWithFormat:@"%lu", (long unsigned)[self.date timeIntervalSinceReferenceDate]];
    
    NSDictionary *subDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
    self.user, @"user",
    self.dateString, @"date",
    self.postText, @"postText",
    nil];
    
    NSDictionary *rootDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:subDictionary, longDateString, nil];
    
    return rootDictionary;
}

@end
