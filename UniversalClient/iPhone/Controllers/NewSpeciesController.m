//
//  NewSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewSpeciesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LESpeciesCreate.h"
#import "LEEmpireFound.h"
#import "Session.h"
#import "LETableViewCellOrbitSelector.h"


@implementation NewSpeciesController


@synthesize empireId;
@synthesize username;
@synthesize password;
@synthesize speciesNameCell;
@synthesize orbitCells;
@synthesize constructionCell;
@synthesize deceptionCell;
@synthesize researchCell;
@synthesize managementCell;
@synthesize farmingCell;
@synthesize miningCell;
@synthesize scienceCell;
@synthesize environmentalCell;
@synthesize politicalCell;
@synthesize tradeCell;
@synthesize growthCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(createSpecies)] autorelease];
	
	//Setup Cells
	self.speciesNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.speciesNameCell.label.text = @"Name";
	self.speciesNameCell.delegate = self;

	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:7];
	for (int index=0; index<NUM_ORBITS; index++) {
		LETableViewCellOrbitSelector *orbitCell = [LETableViewCellOrbitSelector getCellForTableView:self.tableView];
		orbitCell.label.text = [NSString stringWithFormat:@"Orbit %i", index+1];
		orbitCell.pointsDelegate = self;
		[tmp addObject:orbitCell];
	}
	self.orbitCells = tmp;
	
	self.constructionCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.constructionCell.nameLabel.text = @"Construction";
	self.constructionCell.pointsDelegate = self;
	[self.constructionCell setRating:3];
	
	self.deceptionCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.deceptionCell.nameLabel.text = @"Deception";
	self.deceptionCell.pointsDelegate = self;
	[self.deceptionCell setRating:3];
	
	self.researchCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.researchCell.nameLabel.text = @"Research";
	self.researchCell.pointsDelegate = self;
	[self.researchCell setRating:3];
	
	self.managementCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.managementCell.nameLabel.text = @"Management";
	self.managementCell.pointsDelegate = self;
	[self.managementCell setRating:3];
	
	self.farmingCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.farmingCell.nameLabel.text = @"Farming";
	self.farmingCell.pointsDelegate = self;
	[self.farmingCell setRating:3];
	
	self.miningCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.miningCell.nameLabel.text = @"Mining";
	self.miningCell.pointsDelegate = self;
	[self.miningCell setRating:3];
	
	self.scienceCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.scienceCell.nameLabel.text = @"Science";
	self.scienceCell.pointsDelegate = self;
	[self.scienceCell setRating:3];
	
	self.environmentalCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.environmentalCell.nameLabel.text = @"Environmental";
	self.environmentalCell.pointsDelegate = self;
	[self.environmentalCell setRating:3];
	
	self.politicalCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.politicalCell.nameLabel.text = @"Political";
	self.politicalCell.pointsDelegate = self;
	[self.politicalCell setRating:3];
	
	self.tradeCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.tradeCell.nameLabel.text = @"Trade";
	self.tradeCell.pointsDelegate = self;
	[self.tradeCell setRating:3];
	
	self.growthCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.growthCell.nameLabel.text = @"Growth";
	self.growthCell.pointsDelegate = self;
	[self.growthCell setRating:3];
	
	points = 33;
	self.navigationItem.title = [NSString stringWithFormat:@"%i / 45 points", points];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Species"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Habital Orbits"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Affinities"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return [orbitCells count];
			break;
		case 2:
			return 11;
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell = self.speciesNameCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case 1:
			cell = [orbitCells objectAtIndex:indexPath.row];
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					cell = constructionCell;
					break;
				case 1:
					cell = deceptionCell;
					break;
				case 2:
					cell = researchCell;
					break;
				case 3:
					cell = managementCell;
					break;
				case 4:
					cell = farmingCell;
					break;
				case 5:
					cell = miningCell;
					break;
				case 6:
					cell = scienceCell;
					break;
				case 7:
					cell = environmentalCell;
					break;
				case 8:
					cell = politicalCell;
					break;
				case 9:
					cell = tradeCell;
					break;
				case 10:
					cell = growthCell;
					break;
				default:
					break;
			}
			break;
		default:
			cell = nil;
			break;
	}

    return cell;
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
    self.speciesNameCell = nil;
	self.orbitCells = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance methods


- (IBAction)createSpecies {
	if (points > 45) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Too many points" message:[NSString stringWithFormat:@"You have spent %i points, but you can only spend 45 points.", points] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
	} else if (points < 45) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Too few points" message:[NSString stringWithFormat:@"You have spent %i points, but you must spend 45 points.", points] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		
	} else {
		NSMutableArray *orbitArray = [NSMutableArray arrayWithCapacity: NUM_ORBITS];
		for (int index=0; index<NUM_ORBITS; index++) {
			LETableViewCellOrbitSelector *cell = [orbitCells objectAtIndex:index];
			if ([cell isSelected]) {
				[orbitArray addObject:[NSNumber numberWithInteger:(index+1)]];
			}
		}
		
		[[[LESpeciesCreate alloc] initWithCallback:@selector(speciesCreated:) target:self
										  empireId:self.empireId
											  name:self.speciesNameCell.textField.text
									   description:@""
								   habitableOrbits:orbitArray
							  constructionAffinity:constructionCell.rating
								 deceptionAffinity:deceptionCell.rating
								  researchAffinity:researchCell.rating
								managementAffinity:managementCell.rating
								   farmingAffinity:farmingCell.rating
									miningAffinity:miningCell.rating
								   scienceAffinity:scienceCell.rating
							 environmentalAffinity:environmentalCell.rating
								 politicalAffinity:politicalCell.rating
									 tradeAffinity:tradeCell.rating
									growthAffinity:growthCell.rating] autorelease];
	}
}


#pragma mark -
#pragma mark LESpeciesUpdatePointsDelegate


- (void)updatePoints:(NSInteger)delta {
	points += delta;
	self.navigationItem.title = [NSString stringWithFormat:@"%i / 45 points", points];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.speciesNameCell.textField) {
		[self.speciesNameCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Callbacks


- (id)speciesCreated:(LESpeciesCreate *) request {
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1009:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *nameAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create species" message:@"Your selected orbits must be continuous. You cannot have a break within the list of habital orbits." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[nameAlertView show];
				break;
		}
	} else {
		NSLog(@"Founding Empire: %@", self.empireId);
		[[[LEEmpireFound alloc] initWithCallback:@selector(empireFounded:) target:self empireId:self.empireId] autorelease];
	}
	
	return nil;
}


- (id)empireFounded:(LEEmpireFound *) request {
	if ([request wasError]) {
		//WHAT TO DO?
	} else {
		[self dismissModalViewControllerAnimated:YES];
		Session *session = [Session sharedInstance];
		[session loginWithUsername:self.username password:self.password];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewSpeciesController *) create {
	return [[[NewSpeciesController alloc] init] autorelease];
}


@end

