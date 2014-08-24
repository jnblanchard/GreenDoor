//
//  MapViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#define CLCOORDINATES_EQUAL( coord1, coord2 ) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

#import "MapViewController.h"
#import "BankViewController.h"
@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property NSMutableArray *bankArray;
@property NSMutableArray *annotationArray;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.showsUserLocation = YES;
    self.bankArray = [NSMutableArray new];
    self.annotationArray = [NSMutableArray new];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.mapView setRegion:MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(0.4, 0.4))];
    [self loadBanks];
}

- (void)loadBanks
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.region = self.mapView.region;
    request.naturalLanguageQuery = @"bar";
    MKLocalSearch *searchBank = [[MKLocalSearch alloc] initWithRequest:request];
    [searchBank startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"no banks ?");
        } else {
            for (MKMapItem *item in response.mapItems)
            {
                [self.bankArray addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                [self.annotationArray addObject:annotation];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [self.mapView addAnnotation:annotation];
            }
        }
    }];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.firstObject;
        [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.4, 0.4))];
    [self loadBanks];
    [self.locationManager stopUpdatingLocation];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([self.annotationArray containsObject:annotation]) {
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        view.image = [UIImage imageNamed:@"bankPin"];
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return view;
    }
    return nil;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"bank" sender:view.annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CLLocationCoordinate2D coords =  view.annotation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(coords, span);
    [mapView setRegion:coordinateRegion animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bank"]) {
        MKPointAnnotation *point = sender;
        for (MKMapItem *bankMapItem in self.bankArray) {

            if (CLCOORDINATES_EQUAL(bankMapItem.placemark.coordinate, point.coordinate)) {
                BankViewController *bvc = segue.destinationViewController;
                bvc.bankMapItem = bankMapItem;
                break;
            }
        }

    }
}


@end
