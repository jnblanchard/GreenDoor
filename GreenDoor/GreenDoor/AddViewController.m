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
@property BOOL validItem;
@property BOOL validAmount;
@property BOOL validDescription;
@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theUser = [PFUser currentUser];
    self.validAmount = NO;
    self.validItem = NO;
    self.validDescription = NO;
}
- (IBAction)incomeButton:(id)sender
{

}

- (IBAction)expenseButton:(id)sender
{
    if ([self.amountTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing an amount" message:@"Please enter $ amount" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    } else {
        self.amountTextField.text = [@"-" stringByAppendingString:self.amountTextField.text];
    }
}

- (IBAction)didEndOnExit:(UITextField*)sender
{
    if ([sender isEqual:self.itemTextField] && ![sender.text isEqualToString:@""]) {
        self.validItem = YES;
    }
    if ([sender isEqual:self.amountTextField] && ![sender.text isEqualToString:@""]) {
        self.validAmount = YES;
    }
    if ([sender isEqual:self.self.descriptionTextField] && ![sender.text isEqualToString:@""]) {
        self.validDescription = YES;
    }
    [sender resignFirstResponder];
}

- (IBAction)addItemAndAmount:(id)sender
{
    
}

@end
