//
//  AddViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddViewController.h"
#import "Parse/Parse.h"

@interface AddViewController ()
@property (strong, nonatomic) IBOutlet UITextField *itemTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property PFUser* theUser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theUser = [PFUser currentUser];
    // Do any additional setup after loading the view.
}
- (IBAction)incomeButton:(id)sender
{

}

- (IBAction)expenseButton:(id)sender
{

}

- (IBAction)didEndOnExit:(UITextField*)sender
{

}

@end
