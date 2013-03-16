//
//  PlanetaryCommand.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Building.h"
#import "BuildingWithPlans.h"


@interface PlanetaryCommand : Building <BuildingWithPlans> {
}


@property (nonatomic, retain) NSDecimalNumber *nextColonyCost;
//RedOrion
//@property (nonatomic, retain) NSDecimalNumber *population;
//RedOrion
//@property (nonatomic, retain) NSDecimalNumber *buildingCount;

- (void)parseData:(NSMutableDictionary *)bodyData;
//RedOrion
- (void)parseData:(NSMutableDictionary *)populationData;

@end