//
//  LEBuildingAddToMarket.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAddToMarket : LERequest {
}

@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSDecimalNumber *askEssentia;
@property (nonatomic, retain) NSString *offerType;
@property (nonatomic, retain) NSDecimalNumber *offerQuantity;
@property (nonatomic, retain) NSString *offerGlyphId;
@property (nonatomic, retain) NSString *offerPlanId;
@property (nonatomic, retain) NSString *offerPrisonerId;
@property (nonatomic, retain) NSString *offerShipId;
@property (nonatomic, retain) NSString *tradeId;
@property (nonatomic, retain) NSString *tradeShipId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl askEssentia:(NSDecimalNumber *)askEssentia offerType:(NSString *)offerType offerQuantity:(NSDecimalNumber *)offerQuantity offerGlyphId:(NSString *)offerGlyphId offerPlanId:(NSString *)offerPlanId offerPrisonerId:(NSString *)offerPrisonerId offerShipId:(NSString *)offerShipId tradeShipId:(NSString *)tradeShipId;


@end