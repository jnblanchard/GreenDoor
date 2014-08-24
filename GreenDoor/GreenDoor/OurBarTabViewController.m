//
//  OurBarTabViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "OurBarTabViewController.h"

@interface OurBarTabViewController ()
@property UIImage* buttonImage;
@end

@implementation OurBarTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, self.buttonImage.size.width, self.buttonImage.size.height);
    [button setBackgroundImage:self.buttonImage forState:UIControlStateNormal];

    CGFloat heightDifference = self.buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}


@end
