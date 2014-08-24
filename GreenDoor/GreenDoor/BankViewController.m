//
//  BankViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "BankViewController.h"
@import MapKit;

@interface BankViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telfLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *directionTextView;

@end

@implementation BankViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.bankMapItem.name;
    self.telfLabel.text = self.bankMapItem.phoneNumber;
    self.urlLabel.text = self.bankMapItem.url.absoluteString;
    self.directionTextView.text =@"";
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.bankMapItem.placemark.coordinate;
    [self.mapView addAnnotation:point];
    MKCoordinateRegion region = MKCoordinateRegionMake(self.bankMapItem.placemark.coordinate, MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:region];

    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.name] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.thoroughfare] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.subThoroughfare] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.locality] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.subLocality] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.postalCode] stringByAppendingString:@"\n"];
    self.directionTextView.text = [[self.directionTextView.text stringByAppendingString: self.bankMapItem.placemark.ISOcountryCode] stringByAppendingString:@"\n"];

    [self getDirections];

}

- (void)getDirections
{
    MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    directionRequest.destination = self.bankMapItem;


    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"entroo 1 count %lu",(unsigned long)response.routes.count);
        MKRoute *route = response.routes.firstObject;
        NSString *message = @"";
        for (MKRouteStep *step in route.steps) {
            message = [message stringByAppendingString:step.instructions];
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Direction" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
    }];

}



@end
