//
//  MapViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Parse/Parse.h>

#define CLCOORDINATES_EQUAL( coord1, coord2 ) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

#import "MapViewController.h"
#import "BankViewController.h"
#import "CEPViewController.h"

@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property NSMutableArray *bankArray;
@property NSMutableArray *cepArray;
@property NSMutableArray *annotationBankArray;
@property NSMutableArray *annotationCepArray;

@property UIImage *bankImage;
@property UIImage *cepImage;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.showsUserLocation = YES;
    self.bankArray = [NSMutableArray new];
    self.annotationBankArray = [NSMutableArray new];
    self.locationManager = [[CLLocationManager alloc] init];
    self.cepArray = [NSMutableArray new];
    self.locationManager.delegate = self;
    self.annotationCepArray = [NSMutableArray new];
    [self.locationManager startUpdatingLocation];
    [self.mapView setRegion:MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(0.4, 0.4))];

    self.bankImage = [UIImage imageNamed:@"bankPin"];
    self.cepImage = [UIImage imageNamed:@"cepPin"];


    [self createCEPwithLatitude:41.811833 longitude:-87.707699 andName:@"Brighton Park Neighborhood Council"];
    [self createCEPwithLatitude:41.822871 longitude:-87.625912 andName:@"Dawson Technical Institute"];
    [self createCEPwithLatitude:41.885983 longitude:-87.626826 andName:@"Harold Washington College"];
    [self createCEPwithLatitude:41.75059 longitude:-87.63619 andName:@"Neighborhood Housing Services"];
    [self createCEPwithLatitude:41.845675 longitude:-87.684074 andName:@"Instituto del Progreso Latino"];
    [self createCEPwithLatitude:41.750393 longitude:-87.653513 andName:@"Greater Auburn-Gresham Development Corporation"];
    [self createCEPwithLatitude:41.964568 longitude:-87.658811 andName:@"Truman College"];

    [self loadCEPS];



}

- (void)createCEPwithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude andName:(NSString *)name
{
    return;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:latitude
                                                  longitude:longitude];

    PFObject *place = [PFObject objectWithClassName:@"Place"];
    [place setObject:name forKey:@"name"];
    [place setObject:geoPoint forKey:@"location"];
    [place saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"succeed %@",name);
    }];

}

- (void)loadCEPS
{
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *place in objects) {
            [self.cepArray addObject:place];
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            PFGeoPoint *geoPoint = [place objectForKey:@"location"];
            point.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
            [self.mapView addAnnotation:point];
            [self.annotationCepArray addObject:point];
        }
    }];

}

- (void)load:(NSString *)search
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.region = self.mapView.region;
    request.naturalLanguageQuery = search;
    MKLocalSearch *searchBank = [[MKLocalSearch alloc] initWithRequest:request];
    [searchBank startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"no banks ?");
        } else {
            for (MKMapItem *item in response.mapItems)
            {
                [self.bankArray addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                [self.annotationBankArray addObject:annotation];
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
        [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.6, 0.6))];
    [self load:@"bank"];
    [self.locationManager stopUpdatingLocation];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([self.annotationBankArray containsObject:annotation]) {
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        view.image = self.bankImage;
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return view;
    }
    if ([self.cepArray containsObject:annotation]) {

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
    MKPointAnnotation *point = sender;

    if ([segue.identifier isEqualToString:@"bank"]) {
        for (MKMapItem *bankMapItem in self.bankArray) {

            if (CLCOORDINATES_EQUAL(bankMapItem.placemark.coordinate, point.coordinate)) {
                BankViewController *bvc = segue.destinationViewController;
                bvc.bankMapItem = bankMapItem;
                break;
            }
        }

    }

    if ([segue.identifier isEqualToString:@"cep"]) {
        for (PFObject *cep in self.cepArray) {
            PFGeoPoint *coord = [cep objectForKey:@"location"];
            if (CLCOORDINATES_EQUAL(CLLocationCoordinate2DMake(coord.latitude, coord.longitude), point.coordinate)) {
                CEPViewController *cvc = segue.destinationViewController;
                cvc.cepPFObject  = cep;
                break;
            }
        }

    }
}


@end
