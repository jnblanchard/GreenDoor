//
//  NewsFeedViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "EditReportViewController.h"
#import "DetailReportViewController.h"
#import "NewsCell.h"

#import <Parse/Parse.h>


@interface NewsFeedViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* reports;
@property PFObject* clickedReport;
@end

@implementation NewsFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        NSLog(@"entro");
        [self showLogin];
    } else {
        PFQuery* query = [PFQuery queryWithClassName:@"Report"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.reports = objects;
            }
            [self.tableView reloadData];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject* report = [self.reports objectAtIndex:indexPath.row];
    cell.backgroundImageView.layer.cornerRadius = 8.0;
    cell.reportNameLabel.text = report[@"itemName"];
    cell.descriptionLabel.text = @"A description";
    cell.dateLabel.text = @"August 23th";
    cell.amountLabel.text = report[@"amount"];
    cell.typeImageView.image = [UIImage imageNamed:[report objectForKey:@"type"]];
    cell.rightBackgroundImageView.layer.cornerRadius = 8.0;
    if ([report[@"amount"] intValue] > 0) {
        cell.rightBackgroundImageView.backgroundColor = GREEN_COLOR;
    } else {
        cell.rightBackgroundImageView.backgroundColor = RED_COLOR;
    }

    return cell;
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickedReport = [self.reports objectAtIndex:indexPath.row];
    //[self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[EditReportViewController class]]) {
        EditReportViewController* ervc = segue.destinationViewController;
        ervc.report = self.clickedReport;
        ervc.comingFrom = @"doneEditing";
    }
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSLog(@"entro");
        DetailReportViewController *dvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dvc.object = [self.reports objectAtIndex:indexPath.row];
    }
}

- (void) showLogin
{
    LoginViewController *logInViewController = [[LoginViewController alloc] init];

    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook | PFLogInFieldsTwitter | PFLogInFieldsSignUpButton |PFLogInFieldsPasswordForgotten;

    logInViewController.delegate = self;



    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];

    signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton | PFSignUpFieldsAdditional | PFSignUpFieldsDefault;

    [signUpViewController setDelegate:self];

    [logInViewController setSignUpController:signUpViewController];

    [self presentViewController:logInViewController animated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user

{
    [signUpController dismissViewControllerAnimated:YES completion:nil];
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user

{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
