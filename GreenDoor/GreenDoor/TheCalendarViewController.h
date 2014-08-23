//
//  TheCalendarViewController.h
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderViewController.h"
#import "PDTSimpleCalendar.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"

@class TheCalendarViewController;
@protocol TheCalendarProtocol <NSObject>

-(void)theCalendarProtocol:(TheCalendarViewController *)vc didSelectDateWithReports:(NSDate *)date;

@end

@interface TheCalendarViewController : PDTSimpleCalendarViewController

@property  (nonatomic, assign) id<TheCalendarProtocol> delegateCalendar;

@end
