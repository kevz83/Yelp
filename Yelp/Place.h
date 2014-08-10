//
//  Place.h
//  Yelp
//
//  Created by Kevin Shah on 7/6/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface Place : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *fullAddress;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) NSNumber *reviewCount;

@end
