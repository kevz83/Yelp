//
//  Filters.m
//  Yelp
//
//  Created by Kevin Shah on 6/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Filters.h"

@implementation Filters

+ (NSArray *)filters
{
    return @[@{@"title": @"Sort By",
               @"internal_title" : @"sort",
               @"values" :[Filters sort],
               @"type" : @"single"},
             
             @{@"title" : @"Distance",
               @"internal_title" : @"radius_filter",
               @"values" : [Filters distance],
               @"type" : @"single"},
             
             @{@"master_title" : @"Most Popular",
               @"values" : @[@{@"title" : @"Offering a deal",
                               @"internal_title" : @"deals_filter",
                               @"type" : @"toggle"}]
               },
             
             @{@"title" : @"Categories",
               @"internal_title" : @"category_filter",
               @"values" : [Filters categories],
               @"type" : @"multiple"}];
}

+ (NSArray *)distance
{
    return @[@{@"internal_name" : @"auto", @"display_name": @"Auto"},
             @{@"internal_name" : [NSString stringWithFormat:@"%g", [self convertToMeter:1]],
               @"display_name" : @"1 mile"},
             @{@"internal_name" : [NSString stringWithFormat:@"%g", [self convertToMeter:5]], @"display_name" : @"5 miles"},
             @{@"internal_name" : [NSString stringWithFormat:@"%g", [self convertToMeter:10]], @"display_name" : @"10 miles"},
             @{@"internal_name" : [NSString stringWithFormat:@"%g", [self convertToMeter:20]], @"display_name" : @"20 miles"}];
}

+ (NSArray *)sort
{
    return @[@{@"internal_name" : @"0", @"display_name" : @"Best Match"},
             @{@"internal_name" : @"1", @"display_name" : @"Distance"},
             @{@"internal_name" : @"2", @"display_name" : @"Highest rated"}];
}

+ (NSArray *)categories
{
    return @[@{@"internal_name" : @"newamerican", @"display_name" : @"American (New)"},
             @{@"internal_name" : @"austrian", @"display_name" : @"Austrian"},
             @{@"internal_name" : @"burgers", @"display_name" : @"Burgers"},
             @{@"internal_name" : @"german", @"display_name" : @"German"},
             @{@"internal_name" : @"greek", @"display_name" : @"Greek"},
             @{@"internal_name" : @"indpak", @"display_name" : @"Indian"},
             @{@"internal_name" : @"italian", @"display_name" : @"Italian"},
             @{@"internal_name" : @"korean", @"display_name" : @"Korean"},
             @{@"internal_name" : @"vegan", @"display_name" : @"Vegan"},
             @{@"internal_name" : @"vegetarian", @"display_name" : @"Vegetarian"}];
}

+ (float)convertToMeter:(float)miles {
    return miles * 1609;
}

+ (float)convertToMiles:(float)meters {
    return meters / 1609;
}


+ (NSMutableDictionary *)processFilterData:(NSMutableDictionary *)filters
{
    NSMutableDictionary *processedFilters = [[NSMutableDictionary alloc]init];

    for(id key in filters)
    {
        if([key isEqualToString:@"category_filter"])
        {
            NSMutableArray *stringVals = [[NSMutableArray alloc] init];
            
            NSArray *categories = [filters objectForKey:key];
            
            for(NSDictionary *dict in categories)
            {
                [stringVals addObject:dict[@"internal_name"]];
            }
            
            [processedFilters setValue:[stringVals componentsJoinedByString:@","] forKey:key];
            
            //NSLog(@"Values = %@", processedFilters);
        }
        else if([key isEqualToString:@"deals_filter"])
        {
            [processedFilters setObject:filters[key] forKey:key];
        }
        else if([key isEqualToString:@"radius_filter"] &&
                [filters[key][@"internal_name"] isEqualToString:@"auto"])
        {
            // Don't add since its auto.
        }
        else
        {
            [processedFilters setObject:filters[key][@"internal_name"] forKey:key];
        }
    }
    
    return processedFilters;
}





















@end
