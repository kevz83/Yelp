//
//  Place.m
//  Yelp
//
//  Created by Kevin Shah on 7/6/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Place.h"

@implementation Place

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"photo" : @"image_url",
             @"rating" : @"rating_img_url",
             @"address" : @"location.address",
             @"fullAddress" : @"location.display_address",
             @"categories" : @"categories",
             @"distance" : @"distance",
             @"reviewCount" : @"review_count"
             };
}

+ (NSValueTransformer *)addressJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id customAddress) {
    
        NSMutableString *appAddress = [[NSMutableString alloc] init];
        for(NSString *addr in (NSArray*)customAddress)
        {
            [appAddress appendFormat:@"%@ ", addr];
        }
        return appAddress;
        
    }];
}

+ (NSValueTransformer *)fullAddressJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id fullAddress) {
        
        NSMutableString *appFullAddress = [[NSMutableString alloc] init];
        for(NSString *addr in (NSArray*)fullAddress)
        {
            [appFullAddress appendFormat:@"%@ ", addr];
        }
        return appFullAddress;
        
    }];
}

+ (NSValueTransformer *)categoriesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id categories) {
        
        NSString *appCategories = [[NSString alloc] init];
        NSMutableArray *mutArray = [[NSMutableArray alloc]init];
        
        for(NSArray *subCat in (NSArray*)categories)
        {
            [mutArray addObject:subCat[0]];
        }
        
        appCategories = [mutArray componentsJoinedByString:@","];
        
        return appCategories;
    }];
}



@end
