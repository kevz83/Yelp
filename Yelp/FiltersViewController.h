//
//  FiltersViewController.h
//  Yelp
//
//  Created by Kevin Shah on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FiltersViewControllerDelegate;

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersSearch:(NSMutableDictionary *)filters;

@end