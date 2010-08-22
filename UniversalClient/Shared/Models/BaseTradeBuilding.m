//
//  BaseTradeBuilding.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseTradeBuilding.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Trade.h"
#import "ItemPush.h"
#import "OneForOneTrade.h"
#import "Glyph.h"
#import "Plan.h"
#import "LEBuildingViewAvailableTrades.h";
#import "LEBuildingViewMyTrades.h";
#import "LEBuildingPushItems.h"
#import "LEBuildingTradeOneForOne.h"
#import "LEBuildingGetTradeableGlyphs.h"
#import "LEBuildingGetTradeablePlans.h"
#import "LEBuildingGetTradeableStoredResources.h"
#import "LETableViewCellButton.h";
#import "LETableViewCellLabeledText.h"
#import "ViewAvailableTradesController.h"
#import "ViewMyTradesController.h"
#import "NewItemPushController.h"
#import "NewOneForOneTradeController.h"


@implementation BaseTradeBuilding


@synthesize availableTradePageNumber;
@synthesize availableTradeCount;
@synthesize availableTradesUpdated;
@synthesize availableTrades;
@synthesize myTradePageNumber;
@synthesize myTradeCount;
@synthesize myTradesUpdated;
@synthesize myTrades;
@synthesize glyphs;
@synthesize glyphsById;
@synthesize cargoUserPerGlyph;
@synthesize plans;
@synthesize plansById;
@synthesize cargoUserPerPlan;
@synthesize resourceTypes;
@synthesize storedResources;
@synthesize cargoUserPerStoredResource;
@synthesize usesEssentia;
@synthesize maxCargoSize;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.availableTradeCount = nil;
	self.availableTradesUpdated = nil;
	self.availableTrades = nil;
	self.myTradeCount = nil;
	self.myTradesUpdated = nil;
	self.myTrades = nil;
	self.glyphs = nil;
	self.glyphsById = nil;
	self.cargoUserPerGlyph = nil;
	self.plans = nil;
	self.plansById = nil;
	self.cargoUserPerPlan = nil;
	self.resourceTypes = nil;
	self.storedResources = nil;
	self.cargoUserPerStoredResource = nil;
	self.maxCargoSize = nil;
	[super dealloc];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *transportData = [data objectForKey:@"transport"];
	if (transportData) {
		self.maxCargoSize = [transportData objectForKey:@"max"];
		NSLog(@"Found maxCargoSize: %@", self.maxCargoSize);
	}
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_CARGO_SIZE]];
	
	NSMutableArray *rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_AVAILABLE_TRADES], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_TRADES], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_TRADE]);
	
	Session *session = [Session sharedInstance];
	if ([session.empire.planets count] > 1) {
		[rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_PUSH_ITEMS]];
	}
	if ([self.buildingUrl isEqualToString:TRANSPORTER_URL]) {
		[rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_1_FOR_1_TRADE]];
		self->usesEssentia = YES;
	} else {
		self->usesEssentia = NO;
	}
	
	self.sections = _array(productionSection, _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", rows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
		case BUILDING_ROW_VIEW_MY_TRADES:
		case BUILDING_ROW_PUSH_ITEMS:
		case BUILDING_ROW_CREATE_TRADE:
		case BUILDING_ROW_1_FOR_1_TRADE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_MAX_CARGO_SIZE:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *availableTradesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			availableTradesButtonCell.textLabel.text = @"Available Trades";
			cell = availableTradesButtonCell;
			break;
		case BUILDING_ROW_VIEW_MY_TRADES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *myTradesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			myTradesButtonCell.textLabel.text = @"My Trades";
			cell = myTradesButtonCell;
			break;
		case BUILDING_ROW_PUSH_ITEMS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *pushItemsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			pushItemsButtonCell.textLabel.text = @"Push Items";
			cell = pushItemsButtonCell;
			break;
		case BUILDING_ROW_CREATE_TRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *createTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			createTradeButtonCell.textLabel.text = @"Create Trade";
			cell = createTradeButtonCell;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *oneForOneTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			oneForOneTradeButtonCell.textLabel.text = @"1 for 1 Trade With Lacunans";
			cell = oneForOneTradeButtonCell;
			break;
		case BUILDING_ROW_MAX_CARGO_SIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *maxCargoSizeCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			maxCargoSizeCell.label.text = @"Max Cargo Size";
			maxCargoSizeCell.content.text = [Util prettyNSDecimalNumber:self.maxCargoSize];
			cell = maxCargoSizeCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_AVAILABLE_TRADES:
			; //DO NOT REMOVE
			ViewAvailableTradesController *viewAvailableTradesController = [ViewAvailableTradesController create];
			viewAvailableTradesController.baseTradeBuilding = self;
			return viewAvailableTradesController;
			break;
		case BUILDING_ROW_VIEW_MY_TRADES:
			; //DO NOT REMOVE
			ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			viewMyTradesController.baseTradeBuilding = self;
			return viewMyTradesController;
			break;
		case BUILDING_ROW_PUSH_ITEMS:
			; //DO NOT REMOVE
			NewItemPushController *newItemPushController = [NewItemPushController create];
			newItemPushController.baseTradeBuilding = self;
			return newItemPushController;
			break;
		case BUILDING_ROW_CREATE_TRADE:
			; //DO NOT REMOVE
			UIAlertView *createTradeAlertView = [[[UIAlertView alloc] initWithTitle:@"WIP" message:@"This feature is not implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[createTradeAlertView show];
			[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
			/*
			 ViewMyTradesController *viewMyTradesController = [ViewMyTradesController create];
			 viewMyTradesController.baseTradeBuilding = self;
			 return viewMyTradesController;
			 */
			NSLog(@"KEVIN CREATE CREATE TRADE UI");
			return nil;
			break;
		case BUILDING_ROW_1_FOR_1_TRADE:
			; //DO NOT REMOVE
			NewOneForOneTradeController *newOneForOneTradeController = [NewOneForOneTradeController create];
			newOneForOneTradeController.baseTradeBuilding = self;
			return newOneForOneTradeController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)clearLoadables {
	self.glyphs = nil;
	self.glyphsById = nil;
	self.cargoUserPerGlyph = nil;
	self.plans = nil;
	self.plansById = nil;
	self.cargoUserPerPlan = nil;
	self.resourceTypes = nil;
	self.storedResources = nil;
	self.cargoUserPerStoredResource = nil;
}


- (void)loadTradeableGlyphs {
	[[[LEBuildingGetTradeableGlyphs alloc] initWithCallback:@selector(loadedTradeableGlyphs:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeablePlans {
	[[[LEBuildingGetTradeablePlans alloc] initWithCallback:@selector(loadedTradeablePlans:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadTradeableResourceTypes {
	self.resourceTypes = _array( @"water", @"energy", @"waste", @"essentia", @"bean", @"lapis", @"potato", @"apple", @"root", @"corn", @"cider", @"wheat", @"bread", @"soup", @"chip", @"pie", @"pancake", @"milk", @"meal", @"algae", @"syrup", @"fungus", @"burger", @"shake", @"beetle", @"rutile", @"chromite", @"chalcopyrite", @"galena", @"gold", @"uraninite", @"bauxite", @"goethite", @"halite", @"gypsum", @"trona", @"kerogen", @"methane", @"anthracite", @"sulfur", @"zircon", @"monazite", @"fluorite", @"beryl", @"magnetite");
}

- (void)loadTradeableStoredResources {
	[[[LEBuildingGetTradeableStoredResources alloc] initWithCallback:@selector(loadedTradeableStoredResources:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)removeTradeableStoredResource:(NSDictionary *)storedResource {
	__block NSDictionary *toDelete = nil; 
	NSString *toRemoveType = [storedResource objectForKey:@"type"];
	NSDecimalNumber *toRemoveQuantity = [storedResource objectForKey:@"quantity"];
	[self.storedResources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([[obj objectForKey:@"type"] isEqualToString:toRemoveType]) {
			NSInteger tmp = [[obj objectForKey:@"quantity"] compare:toRemoveQuantity];
			if (tmp == NSOrderedDescending) {
				NSDecimalNumber *currentLevel = [obj objectForKey:@"quantity"];
				NSDecimalNumber *leftOver = [currentLevel decimalNumberBySubtracting:toRemoveQuantity];
				[obj setObject:leftOver forKey:@"quantity"];
			} else if (tmp == NSOrderedSame) {
				toDelete = obj;
			}
			*stop = YES;
		}
	}];
	if (toDelete) {
		[self.storedResources removeObject:toDelete];
	}
}


- (void)addTradeableStoredResource:(NSDictionary *)storedResource {
	__block BOOL found = NO; 
	[self.storedResources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([[obj objectForKey:@"type"] isEqualToString:[storedResource objectForKey:@"type"]]) {
			NSDecimalNumber *currentLevel = [obj objectForKey:@"quantity"];
			NSDecimalNumber *toAdd = [storedResource objectForKey:@"quantity"];
			NSDecimalNumber *newLevel = [currentLevel decimalNumberByAdding:toAdd];
			[obj setObject:newLevel forKey:@"quantity"];
			found = YES;
			*stop = YES;
		}
	}];
	if (!found) {
		[self.storedResources addObject:storedResource];
	}
}


- (NSDecimalNumber *)calculateStorageForGlyphs:(NSInteger)numGlyphs plans:(NSInteger)numPlans storedResources:(NSDecimalNumber *)numStoredResources {
	NSDecimalNumber *total = [NSDecimalNumber zero];
	if (numGlyphs > 0) {
		total = [total decimalNumberByAdding:[self.cargoUserPerGlyph decimalNumberByMultiplyingBy:[Util decimalFromInt:numGlyphs]]];
	}
	if (numPlans > 0) {
		total = [total decimalNumberByAdding:[self.cargoUserPerPlan decimalNumberByMultiplyingBy:[Util decimalFromInt:numPlans]]];
	}
	if (_intv(numStoredResources) > 0) {
		NSDecimalNumber *tmp = [self.cargoUserPerStoredResource decimalNumberByMultiplyingBy:numStoredResources];
		total = [total decimalNumberByAdding:tmp];
	}
	
	return total;
}

- (void)loadAvailableTradesForPage:(NSInteger)pageNumber {
	self.availableTradePageNumber = pageNumber;
	[[[LEBuildingViewAvailableTrades alloc] initWithCallback:@selector(availableTradesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousAvailableTradePage {
	return (self.availableTradePageNumber > 1);
}


- (bool)hasNextAvailableTradePage {
	return (self.availableTradePageNumber < [Util numPagesForCount:self.availableTradePageNumber]);
}


- (void)loadMyTradesForPage:(NSInteger)pageNumber {
	self.availableTradePageNumber = pageNumber;
	[[[LEBuildingViewMyTrades alloc] initWithCallback:@selector(myTradesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousMyTradePage {
	return (self.myTradePageNumber > 1);
}


- (bool)hasNextMyTradePage {
	return (self.myTradePageNumber < [Util numPagesForCount:self.myTradePageNumber]);
}


- (void)pushItems:(ItemPush *)itemPush target:(id)target callback:(SEL)callback {
	self->itemPushTarget = target;
	self->itemPushCallback = callback;
	[[[LEBuildingPushItems alloc] initWithCallback:@selector(pushedItems:) target:self buildingId:self.id buildingUrl:self.buildingUrl targetId:itemPush.targetId items:itemPush.items] autorelease];
}


- (void)tradeOneForOne:(OneForOneTrade *)oneForOneTrade target:(id)target callback:(SEL)callback {
	self->oneForOneTradeTarget = target;
	self->oneForOneTradeCallback = callback;
	[[[LEBuildingTradeOneForOne alloc] initWithCallback:@selector(tradedOneForOne:) target:self buildingId:self.id buildingUrl:self.buildingUrl haveResourceType:oneForOneTrade.haveResourceType wantResourceType:oneForOneTrade.wantResourceType quantity:oneForOneTrade.quantity] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)loadedTradeableGlyphs:(LEBuildingGetTradeableGlyphs *)request {
	self.cargoUserPerGlyph = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.glyphs count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.glyphs count]];
	[request.glyphs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Glyph *glyph = [[[Glyph alloc] init] autorelease];
		[glyph parseData:obj];
		[tmpArray addObject:glyph];
		[tmpDict setObject:glyph forKey:glyph.id];
	}];
	self.glyphs = tmpArray;
	self.glyphsById = tmpDict;
	return nil;
}


- (id)loadedTradeablePlans:(LEBuildingGetTradeablePlans *)request {
	self.cargoUserPerPlan = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.plans count]];
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:[request.plans count]];
	[request.plans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Plan *plan = [[[Plan alloc] init] autorelease];
		[plan parseData:obj];
		[tmpArray addObject:plan];
		[tmpDict setObject:plan forKey:plan.id];
	}];
	self.plans = tmpArray;
	self.plansById = tmpDict;
	return nil;
}


- (id)loadedTradeableStoredResources:(LEBuildingGetTradeableStoredResources *)request {
	self.cargoUserPerStoredResource = request.cargoSpaceUsedPer;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[request.storedResources count]];
	[request.storedResources enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		[tmpArray addObject:_dict(key, @"type", obj, @"quantity")];
	}];
	[tmpArray sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES])];
	self.storedResources = tmpArray;
	return nil;
}


- (id)availableTradesLoaded:(LEBuildingViewAvailableTrades *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.availableTrades count]];
	for (NSDictionary *tradeData in request.availableTrades) {
		Trade *tmpTrade = [[[Trade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.availableTrades = tmpTrades;
	
	self.availableTradeCount = request.tradeCount;
	self.availableTradesUpdated = [NSDate date];
	return nil;
}


- (id)myTradesLoaded:(LEBuildingViewMyTrades *)request {
	NSMutableArray *tmpTrades = [NSMutableArray arrayWithCapacity:[request.myTrades count]];
	for (NSDictionary *tradeData in request.myTrades) {
		Trade *tmpTrade = [[[Trade alloc] init] autorelease];
		[tmpTrade parseData:tradeData];
		[tmpTrades addObject:tmpTrade];
	}
	self.myTrades = tmpTrades;
	
	self.myTradeCount = request.tradeCount;
	self.myTradesUpdated = [NSDate date];
	return nil;
}


- (id)pushedItems:(LEBuildingPushItems *)request {
	[self->itemPushTarget performSelector:self->itemPushCallback withObject:request];
	return nil;
}


- (id)tradedOneForOne:(LEBuildingTradeOneForOne *)request {
	[self->oneForOneTradeTarget performSelector:self->oneForOneTradeCallback withObject:request];
	return nil;
}


@end