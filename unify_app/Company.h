//
//  Company.h
//  unify_app
//
//  Created by Savannah Schuchardt on 4/18/18.
//  Copyright © 2018 Unify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *companyDescription;
@property (nonatomic) NSString *companyLogoUrlString;
@property (nonatomic) NSString *location;


- (UIImage *) getImageLogo;


@end
