//
//  LETableViewCellServerSelect.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellServerSelect.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LETableViewCellServerSelect


@synthesize nameLabel;
@synthesize locationLabel;
@synthesize statusLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	self.nameLabel = nil;
	self.locationLabel = nil;
	self.statusLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setServer:(NSDictionary *)serverData {
	self.nameLabel.text = [serverData objectForKey:@"name"];
	self.locationLabel.text = [serverData objectForKey:@"location"];
	self.statusLabel.text = [serverData objectForKey:@"status"];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellServerSelect *)getCellForTableView:(UITableView *)tableView {
	static NSString *CellIdentifier = @"ServerSelectCell";
	
	LETableViewCellServerSelect *cell = (LETableViewCellServerSelect *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellServerSelect alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = UITextAlignmentCenter;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.nameLabel];
		
		cell.locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 15)] autorelease];
		cell.locationLabel.backgroundColor = [UIColor clearColor];
		cell.locationLabel.textAlignment = UITextAlignmentCenter;
		cell.locationLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.locationLabel.font = LABEL_FONT;
		cell.locationLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.locationLabel];
		
		cell.statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 310, 15)] autorelease];
		cell.statusLabel.backgroundColor = [UIColor clearColor];
		cell.statusLabel.textAlignment = UITextAlignmentCenter;
		cell.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
		cell.statusLabel.font = LABEL_FONT;
		cell.statusLabel.textColor = BUTTON_TEXT_COLOR;
		[cell.contentView addSubview:cell.statusLabel];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 60.0;
}


@end
