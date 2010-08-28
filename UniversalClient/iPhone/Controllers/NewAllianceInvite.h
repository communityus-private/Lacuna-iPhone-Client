//
//  NewAllianceInvite.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectEmpireController.h"

@class Embassy;
@class LETableViewCellTextView;


@interface NewAllianceInvite : LETableViewControllerGrouped <SelectEmpireControllerDelegate> {
	Embassy *embassy;
	LETableViewCellTextView *messageCell;
	NSMutableArray *invitees;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) LETableViewCellTextView *messageCell;
@property (nonatomic, retain) NSMutableArray *invitees;


- (IBAction)sendInvite;


+ (NewAllianceInvite *) create;


@end