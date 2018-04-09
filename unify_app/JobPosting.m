//
//  JobPosting.m
//  unify_app
//
//  Created by Kate Sohng on 2/18/18.
//  Copyright © 2018 MobileServices. All rights reserved.
//

#import "JobPosting.h"

@implementation JobPosting

- (UIImage *) getImageLogo {
    NSString *logoUrlString = self.companyLogoUrlString;
    
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
