//
//  LETableViewCellBuildingStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellBuildingStorage.h"
#import "LEMacros.h"
#import "Util.h"
#import "ResourceStorage.h"


@interface LETableViewCellBuildingStorage (PrivateMethods)
- (void)setStorageLabel:(UILabel *)storageLabel storage:(NSInteger)storage;
@end


@implementation LETableViewCellBuildingStorage


@synthesize energyStorageLabel;
@synthesize foodStorageLabel;
@synthesize oreStorageLabel;
@synthesize wasteStorageLabel;
@synthesize waterStorageLabel;


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
	self.energyStorageLabel = nil;
	self.foodStorageLabel = nil;
	self.oreStorageLabel = nil;
	self.wasteStorageLabel = nil;
	self.waterStorageLabel = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)setResourceStorage:(ResourceStorage *)resourceStorage {
	[self setStorageLabel:energyStorageLabel storage:resourceStorage.energy];
	[self setStorageLabel:foodStorageLabel storage:resourceStorage.food];
	[self setStorageLabel:oreStorageLabel storage:resourceStorage.ore];
	[self setStorageLabel:wasteStorageLabel storage:resourceStorage.waste];
	[self setStorageLabel:waterStorageLabel storage:resourceStorage.water];
}


#pragma mark -
#pragma mark Private Methods


- (void)setStorageLabel:(UILabel *)storageLabel storage:(NSInteger)storage {
	storageLabel.text = [Util prettyNSInteger:storage];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellBuildingStorage *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"StorageCell";
	
	LETableViewCellBuildingStorage *cell = (LETableViewCellBuildingStorage *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellBuildingStorage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		UIImageView *tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/energy.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.energyStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 8, 70, 20)] autorelease];
		cell.energyStorageLabel.backgroundColor = [UIColor clearColor];
		cell.energyStorageLabel.textAlignment = UITextAlignmentLeft;
		cell.energyStorageLabel.font = TEXT_SMALL_FONT;
		cell.energyStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.energyStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.energyStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/food.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.foodStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 8, 70, 20)] autorelease];
		cell.foodStorageLabel.backgroundColor = [UIColor clearColor];
		cell.foodStorageLabel.textAlignment = UITextAlignmentLeft;
		cell.foodStorageLabel.font = TEXT_SMALL_FONT;
		cell.foodStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.foodStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.foodStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(218, 7, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/ore.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.oreStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(243, 8, 70, 20)] autorelease];
		cell.oreStorageLabel.backgroundColor = [UIColor clearColor];
		cell.oreStorageLabel.textAlignment = UITextAlignmentLeft;
		cell.oreStorageLabel.font = TEXT_SMALL_FONT;
		cell.oreStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.oreStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.oreStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/waste.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.wasteStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34, 36, 70, 20)] autorelease];
		cell.wasteStorageLabel.backgroundColor = [UIColor clearColor];
		cell.wasteStorageLabel.textAlignment = UITextAlignmentLeft;
		cell.wasteStorageLabel.font = TEXT_SMALL_FONT;
		cell.wasteStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.wasteStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.wasteStorageLabel];
		
		tmpImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(122, 35, 22, 22)] autorelease];
		tmpImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		tmpImageView.contentMode = UIViewContentModeCenter;
		tmpImageView.image = [UIImage imageNamed:@"/assets/ui/s/water.png"];
		[cell.contentView addSubview:tmpImageView];
		cell.waterStorageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(147, 36, 70, 20)] autorelease];
		cell.waterStorageLabel.backgroundColor = [UIColor clearColor];
		cell.waterStorageLabel.textAlignment = UITextAlignmentLeft;
		cell.waterStorageLabel.font = TEXT_SMALL_FONT;
		cell.waterStorageLabel.textColor = TEXT_SMALL_COLOR;
		cell.waterStorageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		[cell.contentView addSubview:cell.waterStorageLabel];
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}	


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 65.0;
}


@end