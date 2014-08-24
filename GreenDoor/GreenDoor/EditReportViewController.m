//
//  EditReportViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "EditReportViewController.h"

@interface EditReportViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImageView;
@end

@implementation EditReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.amountTextField.text = self.report[@"amount"];
    if ([self.amountTextField.text hasPrefix:@"-"]) {
        self.amountTextField.backgroundColor = [UIColor redColor];
        self.amountTextField.textColor = [UIColor whiteColor];
    } else {
        self.amountTextField.backgroundColor = [UIColor greenColor];
        self.amountTextField.textColor = [UIColor whiteColor];
    }
    self.datePicker.date = self.report[@"date"];
    self.descriptionTextField.text = self.report[@"description"];
    self.itemTextField.text = self.report[@"itemName"];
    if ([self.report[@"type"] isEqualToString:@"Other"] ) {
        self.typeSegmentedControl.selectedSegmentIndex = 0;
    }
    if ([self.report[@"type"] isEqualToString:@"Grocery"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 1;
    }
    if ([self.report[@"type"] isEqualToString:@"Transport"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 2;
    }
    if ([self.report[@"type"] isEqualToString:@"Utilities"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 3;
    }
    if ([self.report[@"type"] isEqualToString:@"Home"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 4;
    }
    if ([self.report[@"rate"] isEqualToString:@"One Time"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 0;
    }
    if ([self.report[@"rate"] isEqualToString:@"Weekly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 1;
    }
    if ([self.report[@"rate"] isEqualToString:@"Monthly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 2;
    }
    if ([self.report[@"rate"] isEqualToString:@"Yearly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 3;
    }


    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiptAction:)];
    [self.receiptImageView addGestureRecognizer:tapGestureRecognizer];
    if ([self.report objectForKey:@"receipt"]) {
        PFFile *file = [self.report objectForKey:@"receipt"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.receiptImageView.image = [UIImage imageWithData:data];
        }];
    }
}




- (IBAction)editingDidEnd:(id)sender
{
    [sender resignFirstResponder];
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    if (![self.descriptionTextField.text isEqualToString:@""] && ![self.itemTextField.text isEqualToString:@""] && ![self.amountTextField.text isEqualToString:@""]) {
//        [self.report setObject:self.itemTextField.text forKey:@"itemName"];
//        [self.report setObject:self.descriptionTextField.text forKey:@"description"];
//        [self.report setObject:self.amountTextField.text forKey:@"amount"];
//        [self.report setObject:[self.typeSegmentedControl titleForSegmentAtIndex:self.typeSegmentedControl.selectedSegmentIndex] forKey:@"type"];
//        [self.report setObject:[self.rateSegmentedControl titleForSegmentAtIndex:self.rateSegmentedControl.selectedSegmentIndex] forKey:@"rate"];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
//
//        NSDateComponents *dateComponents = [calendar components:comps
//                                                       fromDate: [self.datePicker date]];
//        NSDate *date1 = [calendar dateFromComponents:dateComponents];
//        [self.report setObject:date1 forKey:@"date"];
//        [self.report saveEventually:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//
//            }
//        }];
//    } else {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Empty Field/s" message:@"Populate all fields" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
//        [alert show];
//    }
//}

- (IBAction)expenseButtonPressed:(id)sender
{
    if ([self.amountTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing an amount" message:@"Please enter $ amount" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    } else {
        if (![self.amountTextField.text hasPrefix:@"-"]) {
            self.amountTextField.text = [@"-" stringByAppendingString:self.amountTextField.text];
            self.amountTextField.textColor = [UIColor whiteColor];
            self.amountTextField.backgroundColor = [UIColor redColor];
        }
    }
}

- (IBAction)incomeButtonPressed:(id)sender
{
    if ([self.amountTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing an amount" message:@"Please enter $ amount" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    } else {
        if ([self.amountTextField.text hasPrefix:@"-"]) {
            self.amountTextField.text = [self.amountTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            self.amountTextField.backgroundColor = [UIColor greenColor];
            self.amountTextField.textColor = [UIColor whiteColor];
        }
    }
}


- (IBAction)addButtonPressed:(id)sender
{
    if (![self.descriptionTextField.text isEqualToString:@""] && ![self.itemTextField.text isEqualToString:@""] && ![self.amountTextField.text isEqualToString:@""]) {
        [self.report setObject:self.itemTextField.text forKey:@"itemName"];
        [self.report setObject:self.descriptionTextField.text forKey:@"description"];
        [self.report setObject:self.amountTextField.text forKey:@"amount"];
        [self.report setObject:[self.typeSegmentedControl titleForSegmentAtIndex:self.typeSegmentedControl.selectedSegmentIndex] forKey:@"type"];
        [self.report setObject:[self.rateSegmentedControl titleForSegmentAtIndex:self.rateSegmentedControl.selectedSegmentIndex] forKey:@"rate"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSDateComponents *dateComponents = [calendar components:comps
                                                       fromDate: [self.datePicker date]];
        NSDate *date1 = [calendar dateFromComponents:dateComponents];
        [self.report setObject:date1 forKey:@"date"];
        [self.report saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Empty Field/s" message:@"Populate all fields" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    }
}

@end
