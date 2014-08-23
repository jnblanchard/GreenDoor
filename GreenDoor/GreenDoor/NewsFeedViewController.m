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
#import <Parse/Parse.h>


@interface NewsFeedViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* reports;
@end

@implementation NewsFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject* report = [self.reports objectAtIndex:indexPath.row];
    cell.textLabel.text = report[@"itemName"];
    cell.detailTextLabel.text = report[@"amount"];
    return cell;
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
