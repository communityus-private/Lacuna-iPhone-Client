//
//  ViewTravellingShipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class SpacePort;


@interface ViewTravellingShipsController : LETableViewControllerGrouped {
	UISegmentedControl *pageSegmentedControl;
	SpacePort *spacePort;
	NSDate *lastUpdated;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) SpacePort *spacePort;
@property (nonatomic, retain) NSDate *lastUpdated;


+ (ViewTravellingShipsController *)create;


@end
