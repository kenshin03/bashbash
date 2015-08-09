//
//  Pin.m
//  bishibashi
//
//  Created by Eric on 31/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "Pin.h"


@implementation Pin
@synthesize pinLevel = _pinLevel;
@synthesize game = _game;
@synthesize time = _time;

- (BOOL) isEqual:(id)anObject
{
	if ((self.game == [anObject game]) && (self.pinLevel == [anObject pinLevel]))
		return YES;
	else
		return NO;
}

- (NSUInteger) hash
{
	return self.game*3+self.pinLevel;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.time forKey:@"time"];
	[encoder encodeInt:self.game forKey:@"game"];
	[encoder encodeInt:self.pinLevel forKey:@"pinLevel"];
	
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super init]) {
		self.time = [decoder decodeObjectForKey:@"time"];
		self.pinLevel = [decoder decodeIntForKey:@"pinLevel"];
		self.game = [decoder decodeIntForKey:@"game"];
    }
    return self;
}

-(id) initWithGame:(Game)game AndPinLevel:(PinLevel)level
{
	if (self = [super init])	{
		self.game = game;
		self.pinLevel = level;
		self.time = [NSDate date];
		
		return self;
	}
}


- (void) dealloc
{
	self.time = nil;
	[super dealloc];
}

+ (NSArray*) arrangePins:(NSArray*) pins
{
	NSMutableArray*	result = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noGames]];
	for (int i=0; i<[[Constants sharedInstance] noGames]; i++)	{
		Pin* thePin = [[Pin alloc] initWithGame:i AndPinLevel:kBeginner];
		[result addObject:thePin];
		[thePin release];
	}
	for (Pin* thePin in pins)	{
		if (thePin.pinLevel > [[result objectAtIndex:thePin.game] pinLevel])	{
			[[result objectAtIndex:thePin.game] setPinLevel:thePin.pinLevel];
			[[result objectAtIndex:thePin.game] setTime:thePin.time];
		}
	}
	
	return result;
}

+ (NSArray*) arrangeOtherPins:(NSArray*) pins
{
	NSMutableArray*	result = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noOtherPins]];
	for (int i=0; i<[[Constants sharedInstance] noOtherPins]; i++)	{
		Pin* thePin = [[Pin alloc] initWithGame:OTHERPINBOUNDARY+i AndPinLevel:kBeginner];
		[result addObject:thePin];
		[thePin release];
	}
	for (Pin* thePin in pins)	{
		if (thePin.pinLevel > [[result objectAtIndex:thePin.game] pinLevel])	{
			[[result objectAtIndex:thePin.game] setPinLevel:thePin.pinLevel];
			[[result objectAtIndex:thePin.game] setTime:thePin.time];
		}
	}
	
	return result;
}

@end
