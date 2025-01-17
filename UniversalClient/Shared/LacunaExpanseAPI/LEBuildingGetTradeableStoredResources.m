//
//  LEGetTradeableStoredResources.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetTradeableStoredResources.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetTradeableStoredResources


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize storedResources;
@synthesize cargoSpaceUsedPer;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	
	self.storedResources = [result objectForKey:@"resources"];
	self.cargoSpaceUsedPer = [Util asNumber:[result objectForKey:@"cargo_space_used_each"]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_stored_resources";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.storedResources = nil;
	self.cargoSpaceUsedPer = nil;
	[super dealloc];
}


@end
