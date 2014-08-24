//
//  AddViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddViewController.h"
#import "Parse/Parse.h"

@interface AddViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextField *itemTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property PFUser* theUser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property BOOL validItem;
@property BOOL validAmount;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property BOOL validDescription;
@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UIImageView *utilityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groceryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *otherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImage;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImageView;
@property UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIButton *showDatePickerButton;
@property PFFile *file;
@property (weak, nonatomic) IBOutlet UIImageView *incomeImageView;

@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.theUser = [PFUser currentUser];
    self.validAmount = NO;
    self.validItem = NO;
    self.validDescription = NO;
    self.rateSegmentedControl.tintColor = GREEN_COLOR;
    self.showDatePickerButton.backgroundColor = GREEN_COLOR;
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiptAction:)];
    [self.receiptImageView addGestureRecognizer:imageTapGestureRecognizer];

    UITapGestureRecognizer *utilityGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchUtility:)];
    [self.utilityImageView addGestureRecognizer:utilityGestureRecognizer];

    UITapGestureRecognizer *homeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchHome:)];
    [self.homeImageView addGestureRecognizer:homeGestureRecognizer];

    UITapGestureRecognizer *groceryGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchGrocery:)];
    [self.groceryImageView addGestureRecognizer:groceryGestureRecognizer];

    UITapGestureRecognizer *otherGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchOther:)];
    [self.otherImageView addGestureRecognizer:otherGestureRecognizer];

    UITapGestureRecognizer *transportGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchTransport:)];
    [self.transportImage addGestureRecognizer:transportGestureRecognizer];

    [self resetSwitchts];
    [self switchUtility:nil];
    if (self.object) {
        [self loadFromObject];
    }
}

- (void)loadFromObject
{
    self.itemTextField.text = [self.object objectForKey:@"itemName"];
    self.amountTextField.text = [self.object objectForKey:@"amount"];
    self.date = [self.object objectForKey:@"date"];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[self.object objectForKey:@"date"]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    [self.showDatePickerButton setTitle:dateString forState:UIControlStateNormal];
    if ([self.object objectForKey:@"file"]) {
        PFFile *file = [self.object objectForKey:@"file"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.receiptImageView.image = [UIImage imageWithData:data];
        }];
    }
    self.descriptionTextField.text = [self.object objectForKey:@"description"];
    NSString *rate = [self.object objectForKey:@"rate"];
    if ([rate isEqualToString:@"Once"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 0;
    }
    if ([rate isEqualToString:@"Weekly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 1;
    }
    if ([rate isEqualToString:@"Monthly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 2;
    }
    if ([rate isEqualToString:@"Yearly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 3;
    }
    NSString *type = [self.object objectForKey:@"type"];

    if ([type isEqualToString:@"Grocery"]) {
        [self switchGrocery:nil];
    }
    if ([type isEqualToString:@"Transport"]) {
        [self switchTransport:nil];
    }
    if ([type isEqualToString:@"Home"]) {
        NSLog(@"entro home!");
        [self switchHome:nil];
    }
    if ([type isEqualToString:@"Utility"]) {
        [self switchUtility:nil];
    }
    if ([type isEqualToString:@"Other"]) {
        [self switchOther:nil];
    }
    if ([[self.object objectForKey:@"amount"] intValue] > 0) {
        [self incomeButton:nil];
    } else {
        [self expenseButton:nil];
    }
    self.validAmount = YES;
    self.validDescription = YES;
    self.validItem = YES;
}

- (IBAction)showDatePicker:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] init];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-dd-MM "];
    self.datePicker.hidden = NO;
    self.datePicker.date = [NSDate date];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = GREEN_COLOR;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self     action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];

    [barItems addObject:cancelBtn];
    [pickerToolbar setItems:barItems animated:YES];
    [self.actionSheet addSubview:pickerToolbar];
    [self.actionSheet addSubview:self.datePicker];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 475)];


}

- (void)cancelButtonPressed:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doneButtonPressed:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd-yyyy"];

    self.date = self.datePicker.date;
    NSString *stringFromDate = [formatter stringFromDate:self.datePicker.date];
    [self.showDatePickerButton setTitle:stringFromDate forState:UIControlStateNormal];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {

    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];

    //Add picker to action sheet
    [actionSheet addSubview:pickerView];


    //Gets an array af all of the subviews of our actionSheet
    NSArray *subviews = [actionSheet subviews];

    [[subviews objectAtIndex:0] setFrame:CGRectMake(20, 366, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 317, 280, 46)];


}


- (void)resetSwitchts
{
    self.utilityImageView.tag = 0;
    self.transportImage.tag = 0;
    self.groceryImageView.tag = 0;
    self.otherImageView.tag = 0;
    self.homeImageView.tag = 0;
    self.utilityImageView.image = [UIImage imageNamed:@"Utility"];
    self.homeImageView.image = [UIImage imageNamed:@"Home"];
    self.transportImage.image = [UIImage imageNamed:@"Transport"];
    self.otherImageView.image = [UIImage imageNamed:@"Other"];
    self.groceryImageView.image = [UIImage imageNamed:@"Grocery"];
}

-(void)switchUtility:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"entro");
    if (!self.utilityImageView.tag) {
        [self resetSwitchts];
        self.utilityImageView.tag = 1;
        self.utilityImageView.image = [UIImage imageNamed:@"UtilitySelectedBorder"];
    }
}

-(void)switchHome:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!self.homeImageView.tag) {
        [self resetSwitchts];
        self.homeImageView.tag = 1;
        self.homeImageView.image = [UIImage imageNamed:@"HomeSelectedBorder"];
    }
}

-(void)switchTransport:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!self.transportImage.tag) {
        [self resetSwitchts];
        self.transportImage.tag = 1;
        self.transportImage.image = [UIImage imageNamed:@"TransportSelectedBorder"];
    }
}

-(void)switchOther:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!self.otherImageView.tag) {
        [self resetSwitchts];
        self.otherImageView.tag = 1;
        self.otherImageView.image = [UIImage imageNamed:@"OtherSelectedBorder"];
    }
}

-(void)switchGrocery:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!self.groceryImageView.tag) {
        [self resetSwitchts];
        self.groceryImageView.tag = 1;
        self.groceryImageView.image = [UIImage imageNamed:@"GrocerySelectedBorder"];
    }
}


- (void)receiptAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:^{

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.receiptImageView.image = image;
    self.file = [PFFile fileWithData:UIImagePNGRepresentation(image)];
}

- (IBAction)incomeButton:(id)sender
{

    if ([self.amountTextField.text hasPrefix:@"-"]) {
        self.amountTextField.text = [self.amountTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    self.amountTextField.backgroundColor = GREEN_COLOR;
    self.amountTextField.textColor = [UIColor whiteColor];
    self.homeImageView.hidden = YES;
    self.otherImageView.hidden = YES;
    self.utilityImageView.hidden = YES;
    self.transportImage.hidden = YES;
    self.groceryImageView.hidden = YES;
    self.incomeImageView.hidden = NO;

}

- (IBAction)expenseButton:(id)sender
{

        if (![self.amountTextField.text hasPrefix:@"-"]) {
            self.amountTextField.text = [@"-" stringByAppendingString:self.amountTextField.text];

        }
    self.amountTextField.textColor = [UIColor whiteColor];
    self.amountTextField.backgroundColor = RED_COLOR;
    self.homeImageView.hidden = NO;
    self.otherImageView.hidden = NO;
    self.utilityImageView.hidden = NO;
    self.transportImage.hidden = NO;
    self.groceryImageView.hidden = NO;
    self.incomeImageView.hidden = YES;
}

- (IBAction)didEndOnExit:(UITextField*)sender
{
    if ([sender isEqual:self.itemTextField] && ![sender.text isEqualToString:@""]) {
        NSLog(@"1");
        self.validItem = YES;
    }
    if ([sender isEqual:self.amountTextField] && ![sender.text isEqualToString:@""]) {
        NSLog(@"2");
        self.validAmount = YES;
    }
    if ([sender isEqual:self.descriptionTextField] && ![sender.text isEqualToString:@""]) {
        NSLog(@"3");
        self.validDescription = YES;
    }
    [sender resignFirstResponder];
}

- (IBAction)addItemAndAmount:(id)sender
{
    if(self.validAmount && self.validDescription && self.validItem)
    {
        PFObject* aReport = [PFObject objectWithClassName:@"Report"];
        if (self.object) {
            aReport = self.object;
        }
        aReport[@"itemName"] = self.itemTextField.text;
        aReport[@"description"] = self.descriptionTextField.text;
        aReport[@"amount"] = self.amountTextField.text;
        aReport[@"type"] = [self getType];
        aReport[@"rate"] = [self.rateSegmentedControl titleForSegmentAtIndex:self.rateSegmentedControl.selectedSegmentIndex];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSDateComponents *dateComponents = [calendar components:comps
                                                       fromDate:self.date];
        NSDate *date1 = [calendar dateFromComponents:dateComponents];
        aReport[@"date"] = date1;
        [aReport setObject:self.theUser forKey:@"user"];
        [aReport saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if (self.file) {
                    [aReport setObject:self.file forKey:@"file"];
                    [aReport saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

                    }];
                }

                self.rateSegmentedControl.selectedSegmentIndex = 0;
                self.validItem = NO;
                self.itemTextField.text = @"";
                self.validAmount = NO;
                self.amountTextField.text = @"";
                self.amountTextField.backgroundColor = [UIColor whiteColor];
                self.amountTextField.textColor = [UIColor blackColor];
                self.validDescription = NO;
                self.receiptImageView.image = [UIImage imageNamed:@"receipt"];
                self.descriptionTextField.text = @"";
                [self resetSwitchts];
                [self switchUtility:nil];
            }
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing report information..." message:@"Please enter valid entries for every component of the report." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    }
}

- (NSString *)getType
{
    if (self.amountTextField.text.intValue > 0) {
        return @"Income";
    }
    if (self.homeImageView.tag) {
        return @"Home";
    }
    if (self.groceryImageView.tag) {
        return @"Grocery";
    }
    if (self.transportImage.tag) {
        return @"Transport";
    }
    if (self.utilityImageView.tag) {
        return @"Utility";
    }
    return @"Other";
}

@end
