//
//  MapViewController.m
//  Yelp
//
//  Created by Kevin Shah on 7/6/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Place.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong)NSArray *places;
@property (nonatomic, strong)CLLocation *currentLocation;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil places:(NSArray *)places
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _places = places;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil places:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 4000, 4000);
    [self.mapView setRegion:mapRegion animated:YES];
    
    if(self.places && self.places.count > 0)
    {
        for(Place *place in self.places)
        {
            CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
            [geoCoder geocodeAddressString:place.fullAddress completionHandler:^(NSArray* placemarks, NSError *error)
             {
                 if(placemarks && placemarks.count >0)
                 {
                     CLPlacemark *topResult = [placemarks objectAtIndex:0];
                     MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                     
                     MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                     annotation.coordinate = placemark.coordinate;
                     annotation.title = place.name;
                     annotation.subtitle = place.address;
                     
                     [self.mapView addAnnotation:annotation];
                 }
             
             }];
        }
    }
}

/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinAnnotationView.animatesDrop = YES;
    }
    
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.annotation = annotation;
    
    return pinAnnotationView;
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
