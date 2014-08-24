//
//  CEPViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//
#import <Parse/Parse.h>
#import "CEPViewController.h"
#import <MessageUI/MessageUI.h>
@import MapKit;

@interface CEPViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hourSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *monday;
@property (weak, nonatomic) IBOutlet UIButton *wednesday;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *fivehalf;
@property (weak, nonatomic) IBOutlet UIButton *six;

@end

@implementation CEPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    PFGeoPoint *geoPoint = [self.cepPFObject objectForKey:@"location"];
    point.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    [self.mapView addAnnotation:point];
    self.bgView.layer.cornerRadius = 6.0;
    self.bgView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.wednesday.alpha = 0.5;
    self.fivehalf.alpha = 0.5;
    self.six.alpha = 0.5;
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getDirecctions:(id)sender
{
        MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
        directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    PFGeoPoint *point = [self.cepPFObject objectForKey:@"location"];

    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude) addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placeMark];
        directionRequest.destination = item;


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


- (IBAction)makeAppointment:(id)sender
{
    NSString *emailTitle = [NSString stringWithFormat:@"Appointment for CEP: %@",[PFUser currentUser].username];
    // Email Content
//    NSString *body = [self.hourSegmentedControl titleForSegmentAtIndex:self.hourSegmentedControl.selectedSegmentIndex];
//    body = [body stringByAppendingString:@" "];
//    body = [body stringByAppendingString:[self.daySegmentedControl titleForSegmentAtIndex:self.daySegmentedControl.selectedSegmentIndex]];
//    body = [body stringByAppendingString:@"\n"];
//    body = [body stringByAppendingString:self.detailsTextField.text];
    NSString *messageBody = @"Appointment for Wednesday at 6:00";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ivanruizmonjo@gmail.com"];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}
- (IBAction)monday:(id)sender {
    self.wednesday.alpha = 0.5;
    self.monday.alpha = 1;
}
- (IBAction)wednesday:(id)sender {
    self.monday.alpha = 0.5;
    self.wednesday.alpha = 1;
}
- (IBAction)five:(id)sender {
    self.five.alpha = 1;
    self.fivehalf.alpha = 0.5;
    self.six.alpha = 0.5;
}
- (IBAction)fiveHalf:(id)sender {
    self.five.alpha = 0.5;
    self.fivehalf.alpha = 1;
    self.six.alpha = 0.5;
}
- (IBAction)six:(id)sender {
    self.five.alpha = 0.5;
    self.fivehalf.alpha = 0.5;
    self.six.alpha = 1;
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];


}
- (IBAction)makeCall:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"111111111"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)goEndOnExit:(id)sender {
    [self resignFirstResponder];
}


- (IBAction)directions:(id)sender {
}
@end
