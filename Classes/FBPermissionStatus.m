//
//  FBPermissionStatus.m
//  FBModule
//
//  Created by Eric on 01/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FBPermissionStatus.h"


@implementation FBPermissionStatus
@synthesize userHasPermission;
@synthesize delegate;

- (FBPermissionStatus *)initWithUserId:(long long int)uid {
	self = [super init];
	
	if (self) {
		NSString* fql = [NSString stringWithFormat:
						 @"select status_update from permissions where uid == %lld", uid];
		NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
		[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
		userHasPermission = NO;
	}
	return self;
}

- (void) dealloc{
	[super dealloc];
}

#pragma mark FBRequestDelegate
- (void)request:(FBRequest*)request didLoad:(id)result {
	NSArray *permissions = result;
	NSDictionary *permission = [permissions objectAtIndex:0];
	userHasPermission = [[permission objectForKey:@"status_update"] boolValue];
	[delegate statusWasSet:userHasPermission];
}

@end