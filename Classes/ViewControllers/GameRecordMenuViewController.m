//
//  GameRecordMenuViewController.m
//  bishibashi
//
//  Created by Eric on 19/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRecordMenuViewController.h"


@implementation GameRecordMenuViewController
@synthesize isPlayingSound = _isPlayingSound;
@synthesize terminalViews = _terminalViews;
@synthesize standbyTerminalViews = _standbyTerminalViews;
@synthesize theTimer = _theTimer;
@synthesize section = _section;
- (void) timerFireMethod:(NSTimer*)theTimer
{
	@synchronized(self){
		NSMutableArray* viewToKeep =[NSMutableArray arrayWithCapacity:[self.terminalViews count]];
		for (CustomTerminalBoardView* view in self.terminalViews)	{
			[view updateView];
			if ([view seq]<=5)
				[viewToKeep addObject:view];
		}
		self.terminalViews = viewToKeep;
		
		if (([self.terminalViews count]<2) &&	([self.standbyTerminalViews count]>0)){
			CustomTerminalBoardView* view = [self.standbyTerminalViews objectAtIndex:0];
			[self.terminalViews addObject:view];
			[self.standbyTerminalViews removeObject:view];
		}
	}
	if ([self.terminalViews count]==0 && [self.standbyTerminalViews count]==0)	{
		if (self.isPlayingSound)	{
			[sharedSoundEffectsManager pauseFlightTerminalBoardSound];
			self.isPlayingSound=NO;
		}
	}
	else if (!self.isPlayingSound)	{
		[sharedSoundEffectsManager playFlightTerminalBoardSound];
		self.isPlayingSound=YES;
	}
}

- (void) addTerminalView:(TerminalBoardView*)view
{
	@synchronized(self)	{
		if ([self.terminalViews count]<2)	{
			[self.terminalViews addObject:view];
		}
		else	{
			[self.standbyTerminalViews addObject:view];
		}
	}
}

-(id) init
{
	if (self=[super initWithStyle:UITableViewStyleGrouped])	{
		self.title = NSLocalizedString(@"選擇航班",nil);
		self.section=-1;		
		sharedSoundEffectsManager = [MediaManager sharedInstance];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[sharedSoundEffectsManager stopFlightTerminalBoardSound];
	[self.theTimer invalidate];
	self.theTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	self.tableView.rowHeight = CUSTOMCELLHEIGHT*2+20;
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.separatorColor = [UIColor blackColor];
	self.tableView.scrollEnabled = NO;
	self.terminalViews = [NSMutableArray arrayWithCapacity:10];
	self.standbyTerminalViews = [NSMutableArray arrayWithCapacity:10];
	
	[super viewWillAppear:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	if (row==5)	
		[self.navigationController popViewControllerAnimated:YES];
	else if (row>0)	{
		GameRecordTableViewController*  theConfigView = [[GameRecordTableViewController alloc] initWithStyle:UITableViewStylePlain AndSection:self.section AndLocality:row-1];
		[self.navigationController pushViewController:theConfigView animated:YES];	
		[theConfigView release];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	UITableViewCell* cell;
	cell = [tableView dequeueReusableCellWithIdentifier:@"local"];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"local"] autorelease];
	}
	cell.contentView.backgroundColor = [UIColor blackColor];
	if (row!=0)
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	else
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSMutableArray* stable = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
	CustomTerminalBoardView* theView;
	CustomTerminalBoardView* theView2;
	
	switch (row)	{
		case (0):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:@"SELECT" AndColor:[UIColor whiteColor] AndFixed:YES];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"請選擇航班" AndColor:[UIColor lightGrayColor] AndFixed:YES];
			break;
		case (1):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:@"LOCAL" AndColor:[UIColor whiteColor] AndFixed:NO];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"市內線" AndColor:[UIColor lightGrayColor] AndFixed:NO];
			break;
		case (2):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:@"NEARBY" AndColor:[UIColor whiteColor] AndFixed:NO];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"本地線" AndColor:[UIColor lightGrayColor] AndFixed:NO];
			break;
		case (3):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:@"COUNTRY" AndColor:[UIColor whiteColor] AndFixed:NO];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"國內線" AndColor:[UIColor lightGrayColor] AndFixed:NO];
			break;
		case (4):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:@"WORLD" AndColor:[UIColor whiteColor] AndFixed:NO];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"國際線" AndColor:[UIColor lightGrayColor] AndFixed:NO];
			break;
		case (5):
			theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, +4, CUSTOMCELLWIDTH*NUMCELL, CUSTOMCELLHEIGHT) AndText:@"        BACK" AndColor:[UIColor orangeColor] AndFixed:NO];
			theView2 = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0.5, CUSTOMCELLHEIGHT+4, 25*10, CUSTOMCELLHEIGHT) AndText:@"          回航" AndColor:[UIColor orangeColor] AndFixed:NO];
			break;			
	}
	if (row>0)	{
		[self addTerminalView:theView];
		[self addTerminalView:theView2];
	}
	[cell.contentView addSubview:theView];
	[cell.contentView addSubview:theView2];
	[theView release];
	[theView2 release];
	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



@end
