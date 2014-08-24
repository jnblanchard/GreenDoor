//
//  CEPViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CEPViewController.h"
@import MapKit;

@interface CEPViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CEPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    PFGeoPoint *geoPoint = [self.cepPFObject objectForKey:@"location"];
    point.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    [self.mapView addAnnotation:point];
    // Do any additional setup after loading the view.
}

- (IBAction)getDirecctions:(id)sender
{
}


- (IBAction)makeAppointment:(id)sender
{
}
@end
