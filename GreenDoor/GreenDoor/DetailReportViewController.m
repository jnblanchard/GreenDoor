//
//  DetailReportViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 24/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailReportViewController.h"
#import "AddViewController.h"

@interface DetailReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIButton *paidButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewWhore;

@property (weak, nonatomic) IBOutlet UIImageView *receiptImageView;
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@end

@implementation DetailReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.typeImageView.image = [UIImage imageNamed:[self.object objectForKey:@"type"]];
    self.reportLabel.text = [self.object objectForKey:@"itemName"];
    self.amountLabel.text = [@"DUE: " stringByAppendingString:[NSString stringWithFormat:@"%@",[self.object objectForKey:@"amount"]]];
    self.descriptionLabel.text = [self.object objectForKey:@"description"];


    NSString *dateString = [NSDateFormatter localizedStringFromDate:[self.object objectForKey:@"date"]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = dateString;
    if ([self.object objectForKey:@"file"]) {
        PFFile *file = [self.object objectForKey:@"file"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.receiptImageView.image = [UIImage imageWithData:data];
        }];
    }
    [self changePaidButton];
    [self putBadge];


}

- (void)putBadge
{
    UIImage *image = [UIImage imageNamed:@"PaidStamp"];
    
}




- (IBAction)paidButtonPressed:(id)sender
{
    if ([[self.object objectForKey:@"paid"] intValue] == 1) {
        [self.object setValue:@0 forKey:@"paid"];
    } else {
        [self.object setValue:@1 forKey:@"paid"];
    }
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

    }];
    [self changePaidButton];
}

-(void)changePaidButton
{
    if ([[self.object objectForKey:@"amount"] intValue] > 0) {
        self.viewBg.backgroundColor = GREEN_COLOR;
        self.paidButton.hidden = YES;
        return;
    }

    if ([[self.object objectForKey:@"paid"] intValue] == 1) {
        self.viewBg.backgroundColor = GREEN_COLOR;
        [self.paidButton setImage:[UIImage imageNamed:@"PaidButton"] forState:UIControlStateNormal];
    } else {
        self.viewBg.backgroundColor = RED_COLOR;
        [self.paidButton setImage:[UIImage imageNamed:@"UnpaidButton"] forState:UIControlStateNormal];
    }
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"entro 1");
    NSLog(@"segue id %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"edit"]) {
        NSLog(@"entro2");
        AddViewController *addVC = segue.destinationViewController;
        addVC.object = self.object;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
