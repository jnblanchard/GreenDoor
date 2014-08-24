//
//  DetailReportViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 24/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailReportViewController.h"

@interface DetailReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIButton *paidButton;


@end

@implementation DetailReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.typeImageView.image = [self.object objectForKey:@"type"];
    self.reportLabel.text = [self.object objectForKey:@"itemName"];
    self.dateLabel.text = [self.object objectForKey:@"date"];
    self.amountLabel.text = [self.object objectForKey:@"amount"];
    self.descriptionLabel.text = [self.object objectForKey:@"description"];
    
    // Do any additional setup after loading the view.
    
}
- (IBAction)paidButtonPressed:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
