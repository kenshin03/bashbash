//
//  MultiPlayersJoinGameViewController.m
//  bishibashi
//
//  Created by Kenny Tang on 9/14/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "MultiPlayersJoinGameViewController.h"

@implementation MultiPlayersJoinGameViewController

@synthesize serverSelectTableView = _serverSelectTableView;
@synthesize serverNamesList = _serverNamesList;

static const CGRect logoRect = {{95, 35}, {200, 70}};

- (id)init {
	
	NSLog(@"init");
	
	self.view.backgroundColor = [UIColor blackColor];
	// main view end
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"logo",nil) ofType:@"png"]]];
	logoImageView.frame = logoRect;
	[self.view addSubview:logoImageView];
	[logoImageView release];
	
	NSLog(@"init array");
	NSMutableDictionary* serverNamesList = [[NSMutableDictionary alloc]initWithCapacity:3];
	self.serverNamesList = serverNamesList;
	[serverNamesList release];
	
	UITableView* serverSelectTableView = [[UITableView alloc]initWithFrame:CGRectMake(110, 100, 210, 270)];
    serverSelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    serverSelectTableView.rowHeight = 100;
    serverSelectTableView.backgroundColor = [UIColor clearColor];
	serverSelectTableView.delegate = self;
	serverSelectTableView.dataSource = self;
	[self.view addSubview:serverSelectTableView];
	self.serverSelectTableView = serverSelectTableView;
	[serverSelectTableView release];
	
	UIView *containerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 60)]
	 autorelease];
	UILabel *headerLabel =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(10, 20, 300, 40)]
	 autorelease];
	headerLabel.text = NSLocalizedString(@"選擇對手", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	self.serverSelectTableView.tableHeaderView = containerView;
	
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 410, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.view addSubview:backBut];
	
	[[GameCenterManager sharedInstance] scansForServer];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setLocalPlayServerSelectDelegate:self];
	return self;
}	

#pragma mark GameServer delegate related methods

- (void)serverListUpdated:(NSString*) foundServerName WithPeerId:(NSString*)peerID
{
	NSLog(@"serverListUpdated called in JoinGameViewController...");
	[self.serverNamesList removeAllObjects];
	[self.serverNamesList setObject:foundServerName forKey:peerID];
	
	[self.serverSelectTableView reloadData];
	
}




#pragma mark table related methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"didSelectRowAtIndexPath: %i", indexPath.row);
	NSArray *serverIDkeys = [self.serverNamesList allKeys];
	NSString *serverID = [serverIDkeys objectAtIndex:indexPath.row];
	NSLog(@"calling connectToServer with selected server ID %@, %@", serverID, [self.serverNamesList objectForKey:serverID]);
	[[GameCenterManager sharedInstance] connectToServer:serverID];
	
	self.serverNamesList = nil;
	[self.serverSelectTableView reloadData];
	
	UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	aiView.frame = CGRectMake(125, 260, 70, 70);
	[self.view addSubview:aiView];
	[aiView startAnimating];
	[aiView performSelector:@selector(stopAnimating) withObject:nil afterDelay:10];
	[aiView release];
	
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.serverNamesList count];
}



- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	
	NSString *cellIdentifier = @"Cell";
	cellIdentifier = [cellIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i", indexPath]];
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSLog(@"1");
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
		[[[UITableViewCell alloc]
		  initWithFrame:CGRectZero
		  reuseIdentifier:cellIdentifier]
		 autorelease];
		[cell setIndentationWidth:2];
		
		const CGFloat LABEL_HEIGHT = 12;
		
		
		//
		// Create a background image view.
		//
		cell.backgroundView =
		[[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
		[[[UIImageView alloc] init] autorelease];
	}
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
	NSLog(@"3");
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
	/*
	UIImage* image = [UIImage imageWithContentsOfFile:[self.multiplayersGameScreensArray objectAtIndex:indexPath.row]];
	[cell.imageView setImage:image];
	[cell.textLabel setFont:[UIFont systemFontOfSize:17]];
	[cell.textLabel setText:[self.multiplayersGameNamesArray objectAtIndex:indexPath.row]];
	 */
//	[cell.textLabel setText:[self.serverNamesArray objectAtIndex:indexPath.row]];
	
	NSArray *serverIDkeys = [self.serverNamesList allKeys];
	NSString *serverID = [serverIDkeys objectAtIndex:indexPath.row];
	[cell.textLabel setText:[self.serverNamesList objectForKey:serverID]];
	NSLog(@"4: %@", [self.serverNamesList objectForKey:serverID]);
	
	return cell;
}




- (void) backButtonClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.serverSelectTableView = nil;
	self.serverNamesList = nil;
	
    [super dealloc];
}



@end
