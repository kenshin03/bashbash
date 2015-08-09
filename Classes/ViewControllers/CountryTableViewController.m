//
//  CountryTableViewController.m
//  bishibashi
//
//  Created by Eric on 11/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CountryTableViewController.h"

@implementation CountryTableViewController
@synthesize countries = _countries;
@synthesize delegate = _delegate;

-(id) initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])	{
		[self.navigationItem setHidesBackButton:NO animated:YES];
		self.countries = [[NSMutableArray alloc] initWithObjects:
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
						  @"Mali",
						  @"Malaysia",
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
	}
	
	return self;
}

- (void)viewDidUnload {
	self.countries = nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor grayColor];
}	
	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"country"];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"country"] autorelease];
	}
	cell.backgroundColor = [UIColor darkGrayColor];
	cell.textLabel.text = [self.countries objectAtIndex:row];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.countries objectAtIndex:row] lowercaseString]]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.countries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate countrySelected:[self.countries objectAtIndex:indexPath.row]];
}

@end
