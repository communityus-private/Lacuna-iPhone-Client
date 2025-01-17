//
//  FoodReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "FoodReserve.h"
#import "LEMacros.h"
#import "LETableViewCellButton.h"
#import "ViewDictionaryController.h"


@implementation FoodReserve


@synthesize storedFood;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.storedFood = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.storedFood = [data objectForKey:@"food_stored"];
}


- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_STORED_FOOD]];
	self.sections = _array(productionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *storedFoodCell = [LETableViewCellButton getCellForTableView:tableView];
			storedFoodCell.textLabel.text = @"View Food By Type";
			cell = storedFoodCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
			; //DO NOT REMOVE
			ViewDictionaryController *viewDictionaryController = [ViewDictionaryController createWithName:@"Food By Type" useLongLabels:NO];
			viewDictionaryController.data = self.storedFood;
			return viewDictionaryController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}



@end
