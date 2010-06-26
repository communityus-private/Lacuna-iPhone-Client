//
//  ViewBuildingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBuildingController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LEGetBuilding.h"
#import "LEUpgradeBuilding.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellUnbuildable.h"
#import "ViewNetwork19NewsController.h"
#import "LEBuildingRestrictCoverage.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingTrainSpy.h"
#import "ViewSpiesController.h"
#import "RecycleController.h"
#import "LEBuildingSubsidizeRecycling.h"
#import "LEBuildingDemolish.h"
#import "LEBuildingThrowParty.h"
#import "LEBuildingSubsidizeBuildQueue.h"


typedef enum {
	SECTION_BUILDING,
	SECTION_ACTIONS,
	SECTION_UPGRADE
} SECTION;


typedef enum {
	ROW_BUILDING_STATS,
	ROW_UPGRADE_BUILDING_STATS,
	ROW_UPGRADE_BUILDING_COST,
	ROW_UPGRADE_BUTTON,
	ROW_UPGRADE_CANNOT,
	ROW_UPGRADE_PROGRESS,
	ROW_VIEW_NETWORK_19,
	ROW_RESTRICTED_NETWORK_19,
	ROW_UNRESTRICTED_NETWORK_19,
	ROW_NUM_SPIES,
	ROW_SPY_BUILD_COST,
	ROW_BUILD_SPY_BUTTON,
	ROW_VIEW_SPIES_BUTTON,
	ROW_RECYCLE,
	ROW_RECYCLE_PENDING,
	ROW_SUBSIDIZE,
	ROW_THROW_PARTY,
	ROW_PARTY_PENDING,
	ROW_DEMOLISH_BUTTON,
	ROW_BUILD_QUEUE_ITEM,
	ROW_SUBSIDIZE_BUILD_QUEUE,
	ROW_EMPTY
} ROW;


@implementation ViewBuildingController


@synthesize buildingId;
@synthesize buildingData;
@synthesize resultData;
@synthesize urlPart;
@synthesize sections;
@synthesize buildingsByLoc;
@synthesize buttonsByLoc;
@synthesize x;
@synthesize y;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sections = [NSArray array];
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (self.buildingData) {
		self.buildingId = [self.buildingData objectForKey:@"id"];
	}

	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	self.navigationItem.title = @"Loading";
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *sectionData = [self.sections objectAtIndex:section];
	NSArray *rows = [sectionData objectForKey:@"rows"];
	return [rows count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (intv_([rows objectAtIndex:indexPath.row])) {
		case ROW_BUILDING_STATS:
			return 100.0;
			break;
		case ROW_UPGRADE_BUILDING_STATS:
			return 100.0;
			break;
		case ROW_SPY_BUILD_COST:
		case ROW_UPGRADE_BUILDING_COST:
			return 65.0;
			break;
		case ROW_VIEW_NETWORK_19:
		case ROW_UPGRADE_BUTTON:
		case ROW_RESTRICTED_NETWORK_19:
		case ROW_UNRESTRICTED_NETWORK_19:
		case ROW_BUILD_SPY_BUTTON:
		case ROW_VIEW_SPIES_BUTTON:
		case ROW_RECYCLE:
		case ROW_SUBSIDIZE:
		case ROW_SUBSIDIZE_BUILD_QUEUE:
		case ROW_THROW_PARTY:
		case ROW_DEMOLISH_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case ROW_UPGRADE_CANNOT:
			return 88.0;
			break;
		case ROW_UPGRADE_PROGRESS:
			return 50.0;
			break;
		case ROW_NUM_SPIES:
			return tableView.rowHeight;
			break;
		case ROW_RECYCLE_PENDING:
			return tableView.rowHeight;
			break;
		case ROW_PARTY_PENDING:
			return tableView.rowHeight;
			break;
		case ROW_BUILD_QUEUE_ITEM:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_EMPTY:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];

	NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
	switch (intv_([rows objectAtIndex:indexPath.row])) {
		case ROW_BUILDING_STATS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStats *statsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[statsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [self.buildingData objectForKey:@"image"]]]];
			[statsCell setBuildingName:[self.buildingData objectForKey:@"name"] buildingLevel:[self.buildingData objectForKey:@"level"]];
			[statsCell setEnergyPerHour:[self.buildingData objectForKey:@"energy_hour"]];
			[statsCell setFoodPerHour:[self.buildingData objectForKey:@"food_hour"]];
			[statsCell setHappinessPerHour: [self.buildingData objectForKey:@"happiness_hour"]];
			[statsCell setOrePerHour: [self.buildingData objectForKey:@"ore_hour"]];
			[statsCell setWastePerHour:[self.buildingData objectForKey:@"waste_hour"]];
			[statsCell setWaterPerHour:[self.buildingData objectForKey:@"water_hour"]];
			cell = statsCell;
			break;
		case ROW_UPGRADE_BUILDING_STATS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *stats = [upgrade objectForKey:@"production"];
			LETableViewCellBuildingStats *upgradeStatsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[upgradeStatsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [upgrade objectForKey:@"image"]]]];
			[upgradeStatsCell setBuildingName:[self.buildingData objectForKey:@"name"] buildingLevel:[NSNumber numberWithInt:intv_([self.buildingData objectForKey:@"level"])+1]];
			[upgradeStatsCell setEnergyPerHour:[stats objectForKey:@"energy_hour"]];
			[upgradeStatsCell setFoodPerHour:[stats objectForKey:@"food_hour"]];
			[upgradeStatsCell setHappinessPerHour: [stats objectForKey:@"happiness_hour"]];
			[upgradeStatsCell setOrePerHour: [stats objectForKey:@"ore_hour"]];
			[upgradeStatsCell setWastePerHour:[stats objectForKey:@"waste_hour"]];
			[upgradeStatsCell setWaterPerHour:[stats objectForKey:@"water_hour"]];
			cell = upgradeStatsCell;
			break;
		case ROW_UPGRADE_BUILDING_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *cost = [upgrade objectForKey:@"cost"];
			LETableViewCellCost *costCell = [LETableViewCellCost getCellForTableView:tableView];
			[costCell setEnergyCost:[cost objectForKey:@"energy"]];
			[costCell setFoodCost:[cost objectForKey:@"food"]];
			[costCell setOreCost:[cost objectForKey:@"ore"]];
			[costCell setTimeCost:[cost objectForKey:@"time"]];
			[costCell setWasteCost:[cost objectForKey:@"waste"]];
			[costCell setWaterCost:[cost objectForKey:@"water"]];
			cell = costCell;
			break;
		case ROW_UPGRADE_CANNOT:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellUnbuildable *unbuildableCell = [LETableViewCellUnbuildable getCellForTableView:tableView];
			NSArray *reason = [upgrade objectForKey:@"reason"];
			if ([reason count] > 2) {
				[unbuildableCell setReason:[NSString stringWithFormat:@"%@ (%@)", [reason objectAtIndex:1], [reason objectAtIndex:2]]];
			} else {
				[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [reason objectAtIndex:1]]];
			}
			cell = unbuildableCell;
			break;
		case ROW_UPGRADE_PROGRESS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellProgress *pendingCell = [LETableViewCellProgress getCellForTableView:tableView];
			[pendingCell setTotalTime:totalBuildTime remainingTime:remainingBuildTime];
			pendingCell.delegate = self;
			cell = pendingCell;
			break;
		case ROW_UPGRADE_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *upgradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			upgradeButtonCell.textLabel.text = @"Upgrade";
			cell = upgradeButtonCell;
			break;
		case ROW_VIEW_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewNewsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewNewsButtonCell.textLabel.text = @"View Network 19 News";
			cell = viewNewsButtonCell;
			break;
		case ROW_RESTRICTED_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *restrictedButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			restrictedButtonCell.textLabel.text = @"News restricted, change";
			cell = restrictedButtonCell;
			break;
		case ROW_UNRESTRICTED_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *unrestrictedButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			unrestrictedButtonCell.textLabel.text = @"News unrestricted, change";
			cell = unrestrictedButtonCell;
			break;
		case ROW_NUM_SPIES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *spiesData = [self.resultData objectForKey:@"spies"];
			LETableViewCellLabeledText *numSpiesCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			numSpiesCell.label.text = @"Spies";
			numSpiesCell.content.text = [NSString stringWithFormat:@"%@/%@", [spiesData objectForKey:@"current"], [spiesData objectForKey:@"maximum"]];
			cell = numSpiesCell;
			break;
		case ROW_SPY_BUILD_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *buildSpyCost = [[self.resultData objectForKey:@"spies"] objectForKey:@"training_costs"];
			LETableViewCellCost *buildSpyCostCell = [LETableViewCellCost getCellForTableView:tableView];
			[buildSpyCostCell setEnergyCost:[buildSpyCost objectForKey:@"energy"]];
			[buildSpyCostCell setFoodCost:[buildSpyCost objectForKey:@"food"]];
			[buildSpyCostCell setOreCost:[buildSpyCost objectForKey:@"ore"]];
			[buildSpyCostCell setTimeCost:[buildSpyCost objectForKey:@"time"]];
			[buildSpyCostCell setWasteCost:[buildSpyCost objectForKey:@"waste"]];
			[buildSpyCostCell setWaterCost:[buildSpyCost objectForKey:@"water"]];
			cell = buildSpyCostCell;
			break;
		case ROW_BUILD_SPY_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *buildSpyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			buildSpyButtonCell.textLabel.text = @"Build spy";
			cell = buildSpyButtonCell;
			break;
		case ROW_VIEW_SPIES_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewSpiesButtonCell.textLabel.text = @"View spies";
			cell = viewSpiesButtonCell;
			break;
		case ROW_RECYCLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *recycleButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			recycleButtonCell.textLabel.text = @"Recycle";
			cell = recycleButtonCell;
			break;
		case ROW_RECYCLE_PENDING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *recyclingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			recyclingCell.label.text = @"Recycling";
			recyclingCell.content.text = [Util prettyDuration:intv_([[self.resultData objectForKey:@"recycle"] objectForKey:@"seconds_remaining"])];
			cell = recyclingCell;
			break;
		case ROW_SUBSIDIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeButtonCell.textLabel.text = @"Subsidize";
			cell = subsidizeButtonCell;
			break;
		case ROW_SUBSIDIZE_BUILD_QUEUE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeBuildQueueButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeBuildQueueButtonCell.textLabel.text = [NSString stringWithFormat:@"Subsidize (%i essentia)", self->subsidyBuildQueueCost];
			cell = subsidizeBuildQueueButtonCell;
			break;
		case ROW_THROW_PARTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *throwPartyCell = [LETableViewCellButton getCellForTableView:tableView];
			throwPartyCell.textLabel.text = @"Throw Party";
			cell = throwPartyCell;
			break;
		case ROW_PARTY_PENDING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *partyPendingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			if ([[self.resultData objectForKey:@"party"] objectForKey:@"seconds_remaining"]) {
				partyPendingCell.label.text = @"Party";
				partyPendingCell.content.text = [Util prettyDuration:intv_([[self.resultData objectForKey:@"party"] objectForKey:@"seconds_remaining"])];
			} else {
				partyPendingCell.label.text = @"Party";
				partyPendingCell.content.text = @"Not enough food";
			}
			cell = partyPendingCell;
			break;
		case ROW_DEMOLISH_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *demolishCell = [LETableViewCellButton getCellForTableView:tableView];
			demolishCell.textLabel.text = @"Demolish";
			cell = demolishCell;
			break;
		case ROW_BUILD_QUEUE_ITEM:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSArray *buildQueue = [self.resultData objectForKey:@"build_queue"];
			NSDictionary *buildQueueItem = [buildQueue objectAtIndex:indexPath.row];
			LETableViewCellLabeledText *buildQueueItemCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			buildQueueItemCell.textLabel.text = [NSString stringWithFormat:@"%@ to %@", [buildQueueItem objectForKey:@"name"], [buildQueueItem objectForKey:@"to_level"]];
			cell = buildQueueItemCell;
			break;
		case ROW_EMPTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			emptyCell.textLabel.text = @"Empty";
			cell = emptyCell;
			break;
		default:
			cell = nil;
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (intv_([rows objectAtIndex:indexPath.row])) {
		case ROW_UPGRADE_BUTTON:
			[[[LEUpgradeBuilding alloc] initWithCallback:@selector(upgradedBuilding:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
			break;
		case ROW_VIEW_NETWORK_19:
			; //DO NOT REMOVE
			ViewNetwork19NewsController *viewNetwork19NewsController = [ViewNetwork19NewsController create];
			viewNetwork19NewsController.buildingId = self.buildingId;
			viewNetwork19NewsController.urlPart = self.urlPart;
			[self.navigationController pushViewController:viewNetwork19NewsController animated:YES];
			break;
		case ROW_RESTRICTED_NETWORK_19:
			[[[LEBuildingRestrictCoverage alloc] initWithCallback:@selector(buildingRestrictCoverageChanged:) target:self buildingId:self.buildingId buildingUrl:self.urlPart restricted:NO] autorelease];
			break;
		case ROW_UNRESTRICTED_NETWORK_19:
			[[[LEBuildingRestrictCoverage alloc] initWithCallback:@selector(buildingRestrictCoverageChanged:) target:self buildingId:self.buildingId buildingUrl:self.urlPart restricted:YES] autorelease];
			break;
		case ROW_BUILD_SPY_BUTTON:
			[[[LEBuildingTrainSpy alloc] initWithCallback:@selector(spyTrained:) target:self buildingId:self.buildingId buildingUrl:self.urlPart quantity:[NSNumber numberWithInt:1]] autorelease];
			break;
		case ROW_VIEW_SPIES_BUTTON:
			; //DO NOT REMOVE
			ViewSpiesController *viewSpiesController = [ViewSpiesController create];
			viewSpiesController.buildingId = self.buildingId;
			viewSpiesController.spiesData = [self.resultData objectForKey:@"spies"];
			viewSpiesController.urlPart = self.urlPart;
			[self.navigationController pushViewController:viewSpiesController animated:YES];
			break;
		case ROW_RECYCLE:
			; //DO NOT REMOVE
			RecycleController *recycleController = [RecycleController create];
			recycleController.buildingId = self.buildingId;
			recycleController.urlPart = self.urlPart;
			recycleController.secondsPerResource = [[self.resultData objectForKey:@"recycle"] objectForKey:@"seconds_per_resource"];
			[self.navigationController pushViewController:recycleController animated:YES];
			break;
		case ROW_SUBSIDIZE:
			[[[LEBuildingSubsidizeRecycling alloc] initWithCallback:@selector(subsidizedRecycling:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
			break;
		case ROW_SUBSIDIZE_BUILD_QUEUE:
			[[[LEBuildingSubsidizeBuildQueue alloc] initWithCallback:@selector(subsidizedBuildQueue:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
			break;
		case ROW_THROW_PARTY:
			[[[LEBuildingThrowParty alloc] initWithCallback:@selector(throwingParty:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
			break;
		case ROW_DEMOLISH_BUTTON:
			; //DO NOT REMOVE
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Demolish building?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			[actionSheet showFromTabBar:self.tabBarController.tabBar];
			[actionSheet release];
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	[super viewDidUnload];
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingData = nil;
	self.resultData = nil;
	self.urlPart = nil;
	self.sections = nil;
	self.buttonsByLoc = nil;
	self.buildingsByLoc = nil;
	self.x = nil;
	self.y = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewBuildProgressCellDelegate Methods

- (void)progressComplete {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[[[LEBuildingDemolish alloc] initWithCallback:@selector(buildingDemolished:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
	}
}


#pragma mark -
#pragma mark Callbacks

- (id)bodyDataLoaded:(LEGetBuilding *)request {
	self.buildingData = request.building;
	self.resultData = [request.response objectForKey:@"result"];
	
	self.navigationItem.title = [self.buildingData objectForKey:@"name"];

	NSMutableArray *tmpSectionHeaders = [NSMutableArray arrayWithCapacity:5];
	[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Building"]];
	NSMutableArray *tmpSections = [NSMutableArray arrayWithCapacity:5];
	[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_BUILDING], @"type", array_([NSNumber numberWithInt:ROW_BUILDING_STATS]), @"rows")];
	
	
	if ([self.urlPart isEqualToString:@"/network19"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Actions"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:5];
		[rows addObject:[NSNumber numberWithInt:ROW_VIEW_NETWORK_19]];
		BOOL restricted = [[[request.response objectForKey:@"result"] objectForKey:@"restrict_coverage"] boolValue];
		if (restricted) {
			[rows addObject:[NSNumber numberWithInt:ROW_RESTRICTED_NETWORK_19]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_UNRESTRICTED_NETWORK_19]];
		}
		[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/intelligence"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Spies"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:5];
		[rows addObject:[NSNumber numberWithInt:ROW_NUM_SPIES]];
		[rows addObject:[NSNumber numberWithInt:ROW_SPY_BUILD_COST]];
		
		NSInteger current = intv_([[self.resultData objectForKey:@"spies"] objectForKey:@"current"]);
		NSInteger max = intv_([[self.resultData objectForKey:@"spies"] objectForKey:@"maximum"]);
		if (current < max) {
			[rows addObject:[NSNumber numberWithInt:ROW_BUILD_SPY_BUTTON]];
		}
		
		[rows addObject:[NSNumber numberWithInt:ROW_VIEW_SPIES_BUTTON]];
		[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/wasterecycling"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Actions"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
		
		NSInteger canRecycle = intv_([[self.resultData objectForKey:@"recycle"] objectForKey:@"can"]);
		if (canRecycle) {
			[rows addObject:[NSNumber numberWithInt:ROW_RECYCLE]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_RECYCLE_PENDING]];
			[rows addObject:[NSNumber numberWithInt:ROW_SUBSIDIZE]];
		}
		
		[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/park"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Party"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
		
		NSInteger canRecycle = intv_([[self.resultData objectForKey:@"party"] objectForKey:@"can_throw"]);
		if (canRecycle) {
			[rows addObject:[NSNumber numberWithInt:ROW_THROW_PARTY]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_PARTY_PENDING]];
		}
		
		[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/development"]) {
		if ([self.resultData objectForKey:@"build_queue"]) {
			[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Build Queue"]];
			NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
			
			self->subsidyBuildQueueCost = intv_([self.resultData objectForKey:@"subsidy_cost"]);
			NSArray *buildQueue = [self.resultData objectForKey:@"build_queue"];
			NSInteger buildQueueSize = [buildQueue count];
			if (buildQueueSize > 0) {
				for (int i=0; i<buildQueueSize; i++) {
					[rows addObject:[NSNumber numberWithInt:ROW_BUILD_QUEUE_ITEM]];
				}
				[rows addObject:[NSNumber numberWithInt:ROW_SUBSIDIZE_BUILD_QUEUE]];
			} else {
				[rows addObject:[NSNumber numberWithInt:ROW_EMPTY]];
			}

			
			[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
		}
	}
	

	[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Upgrade"]];
	NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
	if (pendingBuild && (id)pendingBuild != [NSNull null]) {
		[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_UPGRADE], @"type", array_([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_PROGRESS]), @"rows")];
		NSDate *buildEndDate = [Util date:[pendingBuild objectForKey:@"end"]];
		NSDate *buildStartDate = [Util date:[pendingBuild objectForKey:@"start"]];
		totalBuildTime = (NSInteger)[buildEndDate timeIntervalSinceDate:buildStartDate];
		remainingBuildTime = intv_([pendingBuild objectForKey:@"seconds_remaining"]);
	} else {
		NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
		BOOL canUpgrade = [[upgrade objectForKey:@"can"] boolValue];
		totalBuildTime = 0;
		remainingBuildTime = 0;
		if (canUpgrade) {
			[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_UPGRADE], @"type", array_([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:ROW_UPGRADE_BUTTON], [NSNumber numberWithInt:ROW_DEMOLISH_BUTTON]), @"rows")];
		} else {
			[tmpSections addObject:dict_([NSNumber numberWithInt:SECTION_UPGRADE], @"type", array_([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:ROW_UPGRADE_CANNOT], [NSNumber numberWithInt:ROW_DEMOLISH_BUTTON]), @"rows")];
		}
	}
	
	self.sectionHeaders = tmpSectionHeaders;
	self.sections = tmpSections;
	
	[self.tableView reloadData];
	
	return nil;
}


- (id)upgradedBuilding:(LEUpgradeBuilding *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	
	self.navigationItem.title = @"Refreshing";
	
	return nil;
}

- (id)buildingRestrictCoverageChanged:(LEBuildingRestrictCoverage *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	
	return nil;
}

- (id)spyTrained:(LEBuildingTrainSpy *)request {
	NSMutableDictionary *spiesData = [self.resultData objectForKey:@"spies"];
	NSInteger currentSpyCount = intv_([spiesData objectForKey:@"current"]);
	currentSpyCount += intv_(request.trained);
	[spiesData setObject:[NSNumber numberWithInt:currentSpyCount] forKey:@"current"];
	[self.tableView reloadData];
	return nil;
}


- (id)subsidizedRecycling:(LEBuildingSubsidizeRecycling *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	self.navigationItem.title = @"Loading";
	return nil;
}


- (id)subsidizedBuildQueue:(LEBuildingSubsidizeBuildQueue *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	self.navigationItem.title = @"Loading";
	return nil;
}


- (id)throwingParty:(LEBuildingThrowParty *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	self.navigationItem.title = @"Loading";
	return nil;
}


- (id)buildingDemolished:(LEBuildingDemolish *)request {
	[self.navigationController popViewControllerAnimated:YES];
	NSString *loc = [NSString stringWithFormat:@"%@x%@", self.x, self.y];
	UIButton *button = [self.buttonsByLoc objectForKey:loc];
	UIImage *tmp = [UIImage imageNamed:@"/assets/planet_side/build.png"];
	tmp = [Util imageWithImage:tmp scaledToSize:CGSizeMake(BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_CELL_HEIGHT)];
	[button setBackgroundImage:tmp forState:UIControlStateNormal];
	[self.buildingsByLoc removeObjectForKey:loc];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBuildingController *)create {
	return [[[ViewBuildingController alloc] init] autorelease];
}


@end

