//
//  LETableViewCellShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellShip.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"


@implementation LETableViewCellShip


@synthesize nameLabel;
@synthesize typeLabel;
@synthesize speedLabel;
@synthesize holdSizeLabel;
@synthesize stealthLabel;
@synthesize shipImageView;


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
	self.typeLabel = nil;
	self.speedLabel = nil;
	self.holdSizeLabel = nil;
	self.stealthLabel = nil;
	self.shipImageView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)setShip:(Ship *)ship {
	self.nameLabel.text = ship.name;
	self.typeLabel.text = [Util prettyCodeValue:ship.type];
	if (isNotNull(ship.speed)) {
		self.speedLabel.text = [Util prettyNSDecimalNumber:ship.speed];
	} else {
		self.speedLabel.text = @"Unknown";
	}
	if (isNotNull(ship.holdSize)) {
		self.holdSizeLabel.text = [Util prettyNSDecimalNumber:ship.holdSize];
	} else {
		self.holdSizeLabel.text = @"Unknown";
	}
	if (isNotNull(ship.stealth)) {
		self.stealthLabel.text = [Util prettyNSDecimalNumber:ship.stealth];
	} else {
		self.stealthLabel.text = @"Unknown";
	}
	NSString *shipImageName = [NSString stringWithFormat:@"assets/ships/%@.png", ship.type];
	self.shipImageView.image = [UIImage imageNamed:shipImageName];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellShip *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable {
    static NSString *SelectableCellIdentifier = @"ShipCellSelectable";
    static NSString *NormalCellIdentifier = @"ShipCell";
	NSString *cellIdentifier;
	if (isSelectable) {
		cellIdentifier = SelectableCellIdentifier;
	} else {
		cellIdentifier = NormalCellIdentifier;
	}

	
	LETableViewCellShip *cell = (LETableViewCellShip *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellShip alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		CGFloat y = 10.0;
		
		cell.shipImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y, 100, 100)] autorelease];
		cell.shipImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.shipImageView];
		
		cell.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, y, 200, 22)] autorelease];
		cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.textAlignment = UITextAlignmentLeft;
		cell.nameLabel.font = TEXT_FONT;
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.nameLabel];
		y += 20;
		
		cell.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 165, 20)] autorelease];
		cell.typeLabel.backgroundColor = [UIColor clearColor];
		cell.typeLabel.textAlignment = UITextAlignmentLeft;
		cell.typeLabel.font = TEXT_SMALL_FONT;
		cell.typeLabel.textColor = TEXT_SMALL_COLOR;
		cell.typeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.typeLabel];
		y += 20;
		
		UILabel *tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Speed";
		[cell.contentView addSubview:tmpLabel];
		cell.speedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, y, 100, 20)] autorelease];
		cell.speedLabel.backgroundColor = [UIColor clearColor];
		cell.speedLabel.textAlignment = UITextAlignmentLeft;
		cell.speedLabel.font = TEXT_SMALL_FONT;
		cell.speedLabel.textColor = TEXT_SMALL_COLOR;
		cell.speedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.speedLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Hold Size";
		[cell.contentView addSubview:tmpLabel];
		cell.holdSizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, y, 100, 20)] autorelease];
		cell.holdSizeLabel.backgroundColor = [UIColor clearColor];
		cell.holdSizeLabel.textAlignment = UITextAlignmentLeft;
		cell.holdSizeLabel.font = TEXT_SMALL_FONT;
		cell.holdSizeLabel.textColor = TEXT_SMALL_COLOR;
		cell.holdSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.holdSizeLabel];
		y += 20;
		
		tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, y, 60, 20)] autorelease];
		tmpLabel.backgroundColor = [UIColor clearColor];
		tmpLabel.textAlignment = UITextAlignmentRight;
		tmpLabel.font = LABEL_FONT;
		tmpLabel.textColor = LABEL_COLOR;
		tmpLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpLabel.text = @"Stealth";
		[cell.contentView addSubview:tmpLabel];
		cell.stealthLabel = [[[UILabel alloc] initWithFrame:CGRectMake(185, y, 100, 20)] autorelease];
		cell.stealthLabel.backgroundColor = [UIColor clearColor];
		cell.stealthLabel.textAlignment = UITextAlignmentLeft;
		cell.stealthLabel.font = TEXT_SMALL_FONT;
		cell.stealthLabel.textColor = TEXT_SMALL_COLOR;
		cell.stealthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.stealthLabel];

		//Set Cell Defaults
		if (isSelectable) {
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 120.0;
}


@end
