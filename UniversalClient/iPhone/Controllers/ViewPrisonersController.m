//
//  ViewPrisonersController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewPrisonersController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "Util.h"
#import "Security.h"
#import "Prisoner.h"


typedef enum {
	ROW_PRISONER_NAME,
	ROW_PRISONER_SENTENCE,
	ROW_PRISONER_RELEASE,
	ROW_PRISONER_EXECUTE
} ROW;


@interface ViewPrisonersController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewPrisonersController


@synthesize pageSegmentedControl;
@synthesize securityBuilding;
@synthesize prisonersLastUpdated;
@synthesize selectedPrisoner;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Prisoners";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.securityBuilding addObserver:self forKeyPath:@"prisonersUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.securityBuilding.prisoners) {
		[self.securityBuilding loadPrisonersForPage:1];
	} else {
		if (self.prisonersLastUpdated) {
			if ([self.prisonersLastUpdated compare:self.securityBuilding.prisonersUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
			}
		} else {
			self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
		}
	}

	[self togglePageButtons];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.securityBuilding removeObserver:self forKeyPath:@"prisonersUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.securityBuilding && self.securityBuilding.prisoners) {
		if ([self.securityBuilding.prisoners count] > 0) {
			return [self.securityBuilding.prisoners count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.securityBuilding && self.securityBuilding.prisoners) {
		if ([self.securityBuilding.prisoners count] > 0) {
			return 4;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.securityBuilding && self.securityBuilding.prisoners) {
		if ([self.securityBuilding.prisoners count] > 0) {
			switch (indexPath.row) {
				case ROW_PRISONER_NAME:
				case ROW_PRISONER_SENTENCE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_PRISONER_EXECUTE:
				case ROW_PRISONER_RELEASE:
					return [LETableViewCellButton getHeightForTableView:tableView];
				default:
					return tableView.rowHeight;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
	
	if (self.securityBuilding && self.securityBuilding.prisoners) {
		if ([self.securityBuilding.prisoners count] > 0) {
			Prisoner *prisoner = [self.securityBuilding.prisoners objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PRISONER_NAME:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *prisonerNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					prisonerNameCell.label.text = @"Name";
					prisonerNameCell.content.text = prisoner.name;
					cell = prisonerNameCell;
					break;
				case ROW_PRISONER_SENTENCE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *prisonerSentenceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					prisonerSentenceCell.label.text = @"Expires";
					prisonerSentenceCell.content.text = [Util formatDate:prisoner.sentenceExpiresOn];
					cell = prisonerSentenceCell;
					break;
				case ROW_PRISONER_EXECUTE:
					; //DO NOT REMOVE
					LETableViewCellButton *executeButton = [LETableViewCellButton getCellForTableView:tableView];
					executeButton.textLabel.text = @"Execute";
					cell = executeButton;
					break;
				case ROW_PRISONER_RELEASE:
					; //DO NOT REMOVE
					LETableViewCellButton *releaseButton = [LETableViewCellButton getCellForTableView:tableView];
					releaseButton.textLabel.text = @"Release";
					cell = releaseButton;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Prisoners";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Prisoners";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Prisoner *prisoner = [self.securityBuilding.prisoners objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_PRISONER_EXECUTE:
			self.selectedPrisoner = prisoner;
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Execute spy, this will make your people unhappy?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			[actionSheet showFromTabBar:self.tabBarController.tabBar];
			[actionSheet release];
			break;
		case ROW_PRISONER_RELEASE:
			[self.securityBuilding releasePrisoner:prisoner.id];
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
	self.pageSegmentedControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.securityBuilding = nil;
	self.prisonersLastUpdated = nil;
	self.selectedPrisoner = nil;
    [super dealloc];
}



#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.securityBuilding executePrisoner:self.selectedPrisoner.id];
		self.selectedPrisoner = nil;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.securityBuilding loadPrisonersForPage:(self.securityBuilding.prisonersPageNumber-1)];
			break;
		case 1:
			[self.securityBuilding loadPrisonersForPage:(self.securityBuilding.prisonersPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.securityBuilding hasPreviousPrisonersPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.securityBuilding hasNextPrisonersPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewPrisonersController *)create {
	return [[[ViewPrisonersController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"prisonersUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
	}
}


@end

