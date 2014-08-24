//
//  CalendarViewCell.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 24/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CalendarViewCell.h"

@implementation CalendarViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
