//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import <CoreLocation/CoreLocation.h>

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"location" : @"Seattle", @"sort" : @"0",
                                 @"radius_filter" : @20000, @"deals_filter":@YES,
                                 @"category_filter" : @"vegan,mexican,vegetarian,indpak"
                                 };
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term searchFilters:(NSDictionary *)filters
                            searchLocation:(CLLocation *)location success:(void (^)(AFHTTPRequestOperation * operation, id response))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:term forKey:@"term"];
    [parameters addEntriesFromDictionary:filters];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f",
                           location.coordinate.latitude,
                           location.coordinate.longitude] forKey:@"ll"];
    
    return [ self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
