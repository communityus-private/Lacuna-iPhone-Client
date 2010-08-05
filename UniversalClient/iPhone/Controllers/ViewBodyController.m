//
//  ViewBodyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBodyController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellCurrentResources.h"
#import "ViewBodyMapController.h"
#import "RenameBodyController.h"
#import "LETableViewCellDictionary.h"


typedef enum {
	SECTION_BODY_OVERVIEW,
	SECTION_ACTIONS,
	SECTION_COMPOSITION
} SECTION;


typedef enum {
	BODY_OVERVIEW_ROW_NAME,
	BODY_OVERVIEW_ROW_PRODUCTION
} BODY_OVERVIEW_ROW;


typedef enum {
	ACTION_ROW_VIEW_BUILDINGS,
	ACTION_ROW_RENAME_BODY
} ACTION_ROW;

typedef enum {
	COMPOSITION_ROW_SIZE,
	COMPOSITION_ROW_WATER,
	COMPOSITION_ROW_ORE
} COMPOSITION_ROW;

	
@interface ViewBodyController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewBodyController


@synthesize pageSegmentedControl;
@synthesize bodyIds;
@synthesize currentBodyIndex;
@synthesize bodyId;
@synthesize watchedBody;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	//Duplicated in case loaded from Nib instead of create
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;
	
	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadBody)] autorelease];

	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array([UIImage imageNamed:@"assets/iphone ui/up.png"], [UIImage imageNamed:@"assets/iphone ui/down.png"])] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	[self togglePageButtons];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Body"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Actions"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Composition"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	if (!self.bodyId) {
		self.bodyId = session.empire.homePlanetId;
	}
	if (!self.bodyIds) {
		NSLog(@"How do we use: %@", session.empire.planets);
		NSLog(@"TURN THE ABOVE INTO ARRAY OF IDS I CAN USE");
		NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[session.empire.planets count]];
		[session.empire.planets enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
			[tmp addObject:key];
			if ([key isEqualToString:self.bodyId]) {
				self.currentBodyIndex = [tmp count]-1;
			}
		}];
		self.bodyIds = tmp;
	}
	self.navigationItem.title = @"Loading";
	
	[session addObserver:self forKeyPath:@"body" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session addObserver:self forKeyPath:@"lastTick" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

	if (self.bodyIds) {
		if (![session.body.id isEqualToString:[self.bodyIds objectAtIndex:self.currentBodyIndex]]) {
			[session loadBody:[self.bodyIds objectAtIndex:self.currentBodyIndex]];
		}
	} else {
		if (![session.body.id isEqualToString:self.bodyId]) {
			[session loadBody:self.bodyId];
		}
	}

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
	Session *session = [Session sharedInstance];
	[session removeObserver:self forKeyPath:@"body"];
	[session removeObserver:self forKeyPath:@"lastTick"];
	if (isNotNull(self.watchedBody)) {
		[self.watchedBody addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		self.watchedBody = nil;
	}
    [super viewDidDisappear:animated];
}

 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	Session *session = [Session sharedInstance];
	if (session.body) {
		if ([session.body.empireId isEqualToString:session.empire.id]) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Session *session = [Session sharedInstance];
	if (session.body) {
		switch (section) {
			case SECTION_BODY_OVERVIEW:
				if ([session.body.empireId isEqualToString:session.empire.id]) {
					return 2;
				} else {
					return 1;
				}
				break;
			case SECTION_ACTIONS:
				return 2;
				break;
			case SECTION_COMPOSITION:
				return 3;
				break;
			default:
				return 0;
				break;
		}
	} else {
		return 0;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					return [LETableViewCellBody getHeightForTableView:tableView];
					break;
				default:
					return [LETableViewCellCurrentResources getHeightForTableView:tableView];
					break;
			}
			break;
		case SECTION_ACTIONS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_COMPOSITION:
			switch (indexPath.row) {
				case COMPOSITION_ROW_ORE:
					; //DON'T REMOVE
					Session *session = [Session sharedInstance];
					return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[session.body.ores count]];
					break;
				default:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
			}
			break;
		default:
			return 5.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	UITableViewCell *cell;
    
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellBody *bodyCell = [LETableViewCellBody getCellForTableView:tableView];
					bodyCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", session.body.imageName]];
					bodyCell.planetLabel.text = session.body.name;
					bodyCell.systemLabel.text = session.body.starName;
					bodyCell.orbitLabel.text = [NSString stringWithFormat:@"%i", session.body.orbit];
					bodyCell.empireLabel.text = session.body.empireName;
					cell = bodyCell;
					break;
				default:
					; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
					LETableViewCellCurrentResources *resourceCell = [LETableViewCellCurrentResources getCellForTableView:tableView];
					[resourceCell showBodyData:session.body];
					cell = resourceCell;
					break;
			}
			break;
		case SECTION_ACTIONS:
			switch (indexPath.row) {
				case ACTION_ROW_VIEW_BUILDINGS:
					; //DO NOT REMOVE
					LETableViewCellButton *viewBuildingsCell = [LETableViewCellButton getCellForTableView:tableView];
					viewBuildingsCell.textLabel.text = @"View Buildings";
					cell = viewBuildingsCell;
					break;
				case ACTION_ROW_RENAME_BODY:
					; //DO NOT REMOVE
					LETableViewCellButton *renameBodyCell = [LETableViewCellButton getCellForTableView:tableView];
					renameBodyCell.textLabel.text = [NSString stringWithFormat:@"Rename %@", session.body.type];
					cell = renameBodyCell;
					break;
				default:
					break;
			}
			break;
		case SECTION_COMPOSITION:
			switch (indexPath.row) {
				case COMPOSITION_ROW_SIZE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *sizeCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					sizeCell.label.text = @"Size";
					sizeCell.content.text = [NSString stringWithFormat:@"%i", session.body.size];
					cell = sizeCell;
					break;
				case COMPOSITION_ROW_ORE:
					; //DO NOT REMOVE
					LETableViewCellDictionary *oresCell = [LETableViewCellDictionary getCellForTableView:tableView];
					[oresCell setHeading:@"Ore" Data:session.body.ores];
					cell = oresCell;
					break;
				case COMPOSITION_ROW_WATER:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *waterCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					waterCell.label.text = @"Water";
					waterCell.content.text = [NSString stringWithFormat:@"%i", session.body.planetWater];
					cell = waterCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		default:
			break;
	}
    
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SECTION_ACTIONS) {
		switch (indexPath.row) {
			case ACTION_ROW_VIEW_BUILDINGS:
				; //DO NOT REMOVE
				ViewBodyMapController *viewBodyMapController = [[ViewBodyMapController alloc] init];
				[self.navigationController pushViewController:viewBodyMapController animated:YES];
				[viewBodyMapController release];
				break;
			case ACTION_ROW_RENAME_BODY:
				; //DO NOT REMOVE
				Session *session = [Session sharedInstance];
				RenameBodyController *renameBodyController = [RenameBodyController create];
				if (self.bodyIds) {
					renameBodyController.bodyId = [self.bodyIds objectAtIndex:self.currentBodyIndex];
				} else {
					renameBodyController.bodyId = self.bodyId;
				}
				renameBodyController.nameCell.textField.text = session.body.name;
				[[self navigationController] pushViewController:renameBodyController animated:YES];
				break;
			default:
				NSLog(@"Invalid action clicked: %i:%i", indexPath.section, indexPath.row);
				break;
		}
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.pageSegmentedControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.bodyIds = nil;
	self.bodyId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)clear {
	self.bodyIds = nil;
	self.bodyId = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadBody {
	Session *session = [Session sharedInstance];
	if (self.bodyIds) {
		[session loadBody:[self.bodyIds objectAtIndex:self.currentBodyIndex]];
	} else {
		[session loadBody:self.bodyId];
	}
}


#pragma mark --
#pragma mark Private Methods

- (void)togglePageButtons {
	NSLog(@"currentBodyIndex: %i", self.currentBodyIndex);
	NSLog(@"Max Index: %i", (self.bodyIds.count - 1));
	if (self.bodyIds) {
		[self.pageSegmentedControl setEnabled:(self.currentBodyIndex > 0) forSegmentAtIndex:0];
		[self.pageSegmentedControl setEnabled:(self.currentBodyIndex < (self.bodyIds.count - 1)) forSegmentAtIndex:1];
	} else {
		[self.pageSegmentedControl setEnabled:NO forSegmentAtIndex:0];
		[self.pageSegmentedControl setEnabled:NO forSegmentAtIndex:1];
	}

}


- (void) switchPage {
	Session *session = [Session sharedInstance];
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			NSLog(@"NSLog Previous Body");
			self.currentBodyIndex--;
			[session loadBody:[self.bodyIds objectAtIndex:self.currentBodyIndex]];
			break;
		case 1:
			NSLog(@"NSLog Next Body");
			self.currentBodyIndex++;
			[session loadBody:[self.bodyIds objectAtIndex:self.currentBodyIndex]];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
	NSLog(@"currentBodyIndex: %i", self.currentBodyIndex);
}


#pragma mark --
#pragma mark Class Methods

+ (ViewBodyController *)create {
	return [[[ViewBodyController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"body"]) {
		NSLog(@"LOADED NEW BODY");
		if (isNotNull(self.watchedBody)) {
			[self.watchedBody removeObserver:self forKeyPath:@"needsRefresh"];
		}
		
		Body *newBody = (Body *)[change objectForKey:NSKeyValueChangeNewKey];
		if (isNotNull(newBody)) {
			[newBody addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		}
		self.watchedBody = newBody;
		
		Session *session = [Session sharedInstance];
		self.navigationItem.title = session.body.name;
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:newBody.type],
									 [LEViewSectionTab tableView:self.tableView createWithText:@"Actions"],
									 [LEViewSectionTab tableView:self.tableView createWithText:@"Composition"]);
		[self togglePageButtons];
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"lastTick"]) {
		self.navigationItem.title = self.watchedBody.name;
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"needsRefresh"]) {
		self.navigationItem.title = self.watchedBody.name;
		[self.tableView reloadData];
		[self togglePageButtons];
	}
}


@end

