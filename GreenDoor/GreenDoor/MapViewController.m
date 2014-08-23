//
//  MapViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.showsUserLocation = YES;
}



@end
