//
//  OurBarTabViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "OurBarTabViewController.h"
#import "AddViewController.h"

@interface OurBarTabViewController ()
@property UIImage* buttonImage;
@end

@implementation OurBarTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonImage = [UIImage imageNamed:@"plusButton"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 200.0, self.buttonImage.size.width-60, self.buttonImage.size.height-60);
    [button setBackgroundImage:self.buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];

    CGFloat heightDifference = self.buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = (center.y - heightDifference/2.0) + 30;
        button.center = center;
    }
    [self.view addSubview:button];
}

-(IBAction)buttonPressed:(id)sender
{
    NSLog(@"here");
    self.selectedIndex = 2;
}


@end
