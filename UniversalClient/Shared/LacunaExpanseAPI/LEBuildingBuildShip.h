//
//  LEBuildingBuildShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingBuildShip : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *shipType;
	NSMutableArray *shipBuildQueue;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *shipType;
@property(nonatomic, retain) NSMutableArray *shipBuildQueue;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl shipType:(NSString *)shipType;


@end
