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
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getDirecctions:(id)sender
{
}


- (IBAction)makeAppointment:(id)sender
{
    NSString *emailTitle = [NSString stringWithFormat:@"Appointment for CEP: %@",[PFUser currentUser].username];
    // Email Content
    NSString *body = [self.hourSegmentedControl titleForSegmentAtIndex:self.hourSegmentedControl.selectedSegmentIndex];
    body = [body stringByAppendingString:@" "];
    body = [body stringByAppendingString:[self.daySegmentedControl titleForSegmentAtIndex:self.daySegmentedControl.selectedSegmentIndex]];
    body = [body stringByAppendingString:@"\n"];
    body = [body stringByAppendingString:self.detailsTextField.text];
    NSString *messageBody = body;
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
}
- (IBAction)wednesday:(id)sender {
}
- (IBAction)five:(id)sender {
}
- (IBAction)fiveHalf:(id)sender {
}
- (IBAction)six:(id)sender {
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
@end
