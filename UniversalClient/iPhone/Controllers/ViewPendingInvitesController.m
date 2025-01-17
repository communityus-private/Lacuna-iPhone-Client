//
//  ViewPendingInvitesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewPendingInvitesController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "PendingAllianceInvite.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "WithdrawAllianceInviteController.h"


typedef enum {
	ROW_TO,
	ROW_WITHDRAW
} ROW;


@implementation ViewPendingInvitesController


@synthesize embassy;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Pending Invites";
	
	self.sectionHeaders = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self->watched = YES;
	[self.embassy addObserver:self forKeyPath:@"pendingInvites" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (self.embassy.pendingInvites) {
		[self.tableView reloadData];
	} else {
		[self.embassy loadPendingInvites];
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self->watched) {
		self->watched = NO;
		[self.embassy removeObserver:self forKeyPath:@"pendingInvites"];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.embassy.pendingInvites) {
		if ([self.embassy.pendingInvites count] > 0) {
			return [self.embassy.pendingInvites count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.embassy.pendingInvites) {
		if ([self.embassy.pendingInvites count] > 0) {
			return 2;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.embassy.pendingInvites) {
		if ([self.embassy.pendingInvites count] > 0) {
			switch (indexPath.row) {
				case ROW_TO:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_WITHDRAW:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.embassy.pendingInvites) {
		if ([self.embassy.pendingInvites count] > 0) {
			PendingAllianceInvite *invite = [self.embassy.pendingInvites objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TO:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *toCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					toCell.label.text = @"To";
					toCell.content.text = invite.name;
					cell = toCell;
					break;
				case ROW_WITHDRAW:
					; //DO NOT REMOVE
					LETableViewCellButton *withdrawButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					withdrawButtonCell.textLabel.text = @"Withdraw Invite";
					cell = withdrawButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			noneCell.label.text = @"Invites";
			noneCell.content.text = @"None";
			cell = noneCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Invites";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.embassy.pendingInvites) {
		if ([self.embassy.pendingInvites count] > 0) {
			PendingAllianceInvite *invite = [self.embassy.pendingInvites objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_WITHDRAW:
					; // DO NOT REMOVE
					WithdrawAllianceInviteController *withdrawAllianceInviteController = [WithdrawAllianceInviteController create];
					withdrawAllianceInviteController.embassy = self.embassy;
					withdrawAllianceInviteController.invite = invite;
					[self.navigationController pushViewController:withdrawAllianceInviteController animated:YES];
					break;
			}
		}
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
    [super viewDidUnload];
}


- (void)dealloc {
	if (self->watched) {
		self->watched = NO;
		[self.embassy removeObserver:self forKeyPath:@"pendingInvites"];
	}
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewPendingInvitesController *)create {
	return [[[ViewPendingInvitesController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"pendingInvites"]) {
		[self.tableView reloadData];
	}
}


@end
