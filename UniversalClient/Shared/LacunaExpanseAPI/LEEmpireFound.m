//
//  LEEmpireFound.m
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireFound.h"
#import "LEMacros.h"


@implementation LEEmpireFound


@synthesize empireId;
@synthesize sessionId;
@synthesize inviteCode;
@synthesize empireData;
@synthesize welcomeMessageId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireId:(NSString *)inEmpireId inviteCode:(NSString *)inInviteCode {
	self.empireId = inEmpireId;
	self.inviteCode = inInviteCode;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	NSMutableArray *params = _array(self.empireId, API_KEY);
	
	if (self.inviteCode && [self.inviteCode length] > 0) {
		[params addObject:self.inviteCode];
	}
	
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.sessionId = [result objectForKey:@"session_id"];
	self.welcomeMessageId = [result objectForKey:@"welcome_message_id"];

	NSDictionary *status = [result objectForKey:@"status"];
	self.empireData = [status objectForKey:@"empire"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"found";
}


- (void)dealloc {
	self.empireId = nil;
	self.sessionId = nil;
	self.inviteCode = nil;
	self.empireData = nil;
	self.welcomeMessageId = nil;
	[super dealloc];
}


@end
