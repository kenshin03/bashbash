//
//  NationalFlagView.m
//  bishibashi
//
//  Created by Eric on 15/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NationalFlagView.h"

static NationalFlagView *sharedInstance = nil;

@implementation NationalFlagView
@synthesize countries = _countries;
@synthesize flagImages = _flagImages;

- (id) init
{
	if (self=[super init])	{
		self.countries = [[NSArray alloc] initWithObjects:
						  @"Australia",
						  @"Austria", 
						  @"Bahamas", 
						  @"Belgium", 
						  @"Brazil",
						  @"Bulgaria", 
						  @"Canada", 
						  @"China",
						  @"Chile", 
						  @"Denmark", 
						  @"France",
						  @"Germany",
						  @"Ghana",
						  @"Guatamala",
						  @"Guinea",
						  @"Guyana",
						  @"Haiti",
						  @"Hong Kong",
						  @"Italy",
						  @"Jamaica",
						  @"Japan",
						  @"Jordan",
						  @"Latvia",
						  @"Liberia",
						  @"Macau",
						  @"Madagascar",
						  @"Malaysia",
						  @"Mali",
						  @"Mexico",
						  @"Netherlands",
						  @"Okinawa",
						  @"Palau",
						  @"Panama",
						  @"Poland",
						  @"Romania",
						  @"Singapore",
						  @"Spain",
						  @"South Africa",
						  @"South Korea",
						  @"Sweden",
						  @"Switzerland",
						  @"Syria",
						  @"Taiwan",
						  @"Thailand",
						  @"Turkey",
						  @"Uk",
						  @"Ukraine",
						  @"United Arab Emirates",
						  @"Usa",
						  @"Vietnam",
						  @"Wales",
						  @"Yemen",
						  nil];
		
		self.flagImages = [NSMutableArray arrayWithCapacity:[self.countries count]];
		for (int i=0; i<[self.countries count]; i++)	
			[self.flagImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.countries objectAtIndex:i] lowercaseString]]]];
	}
	return self;
}

- (UIImage*) getNationalFlagByCountry:(NSString*)country
{
	int idx = [self.countries indexOfObject:[country capitalizedString]];
	if (idx ==  NSNotFound)
		return nil;
	else
		return [self.flagImages objectAtIndex:idx];
}

- (NSArray*) getAllNationalFlags
{
	return self.flagImages;
}

+ (id)sharedInstance {
    @synchronized(self) {
        if(sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedInstance == nil)  {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

			  
			  
@end
