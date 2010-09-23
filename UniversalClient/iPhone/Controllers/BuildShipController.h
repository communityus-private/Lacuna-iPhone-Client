//
//  BuildShipController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Shipyard;


@interface BuildShipController : LETableViewControllerGrouped {
	Shipyard *shipyard;
	NSString *tag;
}


@property (nonatomic, retain) Shipyard *shipyard;
@property (nonatomic, retain) NSString *tag;


+ (BuildShipController *)create;


@end
