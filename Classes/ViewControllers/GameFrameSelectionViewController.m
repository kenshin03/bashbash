//
//  GameFrameSelectonController.m
//  bishibashi
//
//  Created by Eric on 23/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameFrameSelectionViewController.h"


@implementation GameFrameSelectionViewController
@synthesize frames = _frames;
@synthesize delegate = _delegate;

-(id) initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])	{
		self.frames = [[NSMutableArray alloc] initWithObjects:
					   @"black",
					   @"blue",
					   @"brown",
					   @"purple",
					   @"green",
				//	   @"white",
						  nil];
	}
	
	return self;
}

- (void)viewDidUnload {
	self.frames = nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor whiteColor];
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"frames"];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"frames"] autorelease];
	}
	cell.backgroundColor = [UIColor whiteColor];
//	if ([[self.frames objectAtIndex:row] isEqualToString:@"white"])
//		cell.textLabel.text = [NSString stringWithFormat:@"Arcade Cabinet %@ >", [self.frames objectAtIndex:row]];
//	else
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ >", NSLocalizedString(@"古老電視",nil),[self.frames objectAtIndex:row]];
	
	cell.textLabel.textColor = [UIColor blackColor];
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%@_small.png",[[self.frames objectAtIndex:row] lowercaseString]]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.frames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate frameSelected:[self.frames objectAtIndex:indexPath.row]];
}

@end
