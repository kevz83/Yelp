//
//  Filters.h
//  Yelp
//
//  Created by Kevin Shah on 6/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filters : NSObject


+ (NSArray *)filters;
+ (NSArray *)categories;
+ (NSArray *)sort;
+ (NSArray *)distance;
+ (float)convertToMeter:(float)miles;
+ (float)convertToMiles:(float)meters;
+ (NSMutableDictionary *)processFilterData:(NSMutableDictionary *)filters;



@end
