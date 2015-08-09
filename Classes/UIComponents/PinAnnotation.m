//
//  PinAnnotation.m
//
//  Created by Eric on 11/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PinAnnotation.h"


@implementation PinAnnotation

@synthesize coordinate= _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;



-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	if (self=[super init])	{
		self.coordinate=c;
	}
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString*)title{
	self = [self initWithCoordinate:c];
	self.title = title;
	return self;
}

- (void) dealloc
{
	self.title = nil;
	self.subtitle = nil;
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	PinAnnotation* new = [[PinAnnotation alloc] initWithCoordinate:self.coordinate title:self.title];
	new.subtitle = self.subtitle;
	return new;
}
@end