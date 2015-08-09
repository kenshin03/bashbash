//
//  ImageSettingsViewController.m
//  bishibashi
//
//  Created by Eric on 13/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageSettingsViewController.h"


@implementation ImageSettingsViewController
@synthesize openMouthFace = _openMouthFace;
@synthesize cryingFace = _cryingFace;
@synthesize normalFace = _normalFace;
@synthesize inGameImages = _inGameImages;

-(id) init
{
	if (self=[super initWithStyle:UITableViewStyleGrouped])	{
		self.title = NSLocalizedString(@"遊戲用照片",nil);
		self.inGameImages = [LocalStorageManager getInGameImages];
	}
	return self;
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	self.openMouthFace = nil;
	self.cryingFace = nil;
	self.normalFace = nil;
	self.inGameImages = nil;
    [super dealloc];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if (section == 0) 
		if (row<[self.inGameImages count]+1)
			return 80;
		else
			return 130;
		else
			return 50;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)	{
		case (0):
			return NSLocalizedString(@"照片",nil);
			break;
		case (1):
			return NSLocalizedString(@"生命指標",nil);
			break;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section==1)
		//		return 4;
		return 3;
	else if (section==0)	{
		return 2+[self.inGameImages count];
	}
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray* keys = [self.inGameImages allKeys];
	NSString* key = [keys objectAtIndex:indexPath.row -1];
	[LocalStorageManager deleteInGameImage:key];
	self.inGameImages = [LocalStorageManager getInGameImages];
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1 && indexPath.row>0 && indexPath.row<=[self.inGameImages count])	{
		NSArray* keys = [self.inGameImages allKeys];
		/* cannot delete if this is the selected one */
		if ([[keys objectAtIndex:indexPath.row-1] isEqualToString:[LocalStorageManager stringForKey:INGAMEIMAGESKEY]])
			return UITableViewCellEditingStyleNone;
		else
			return UITableViewCellEditingStyleDelete;
	}
	else {
		return UITableViewCellEditingStyleNone;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag==1 && buttonIndex==0)	{
		NSString *buyString=@"itms://itunes.com/apps/redsoldier/拍拍機bashbash";
		NSURL *url = [[NSURL alloc] initWithString:[buyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:url];
		[url release];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row>0 )	{
		if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version1"])	{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此功能可在完整版中使用", nil)
															message:NSLocalizedString(@"透過iTune 購買拍拍機BashBash! 完整版？",nil)
														   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"購買!",nil), @"再玩多陣",nil];
			alert.tag = 1;
			[alert show];	
			[alert release];
			return;
		}
		
		NSArray* keys = [self.inGameImages allKeys];
		if (indexPath.row-1 < [keys count])	{
			NSString* key = [keys objectAtIndex:indexPath.row-1];
			[LocalStorageManager setObject:key forKey:INGAMEIMAGESKEY];
			[tableView reloadData];
		}
	}
	else if (indexPath.section ==1 )	{
		switch (indexPath.row)	{
			case (0):
				[LocalStorageManager setObject:@"heartwithline.png" forKey:LIFEICON];
				break;
			case (1):
				[LocalStorageManager setObject:@"greenleaf.png" forKey:LIFEICON];
				break;
			case (2):
				[LocalStorageManager setObject:@"redleaf.png" forKey:LIFEICON];
				break;
			case (3):
				[LocalStorageManager setObject:LIFEICON forKey:LIFEICON];
				break;				
		}
		[tableView reloadData];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	UITableViewCell* cell;
	switch (section)	{
		case (1):
			cell = [tableView dequeueReusableCellWithIdentifier:@"lifeicons"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lifeicons"] autorelease];
			}
			else {
				for (UIView* subview in cell.contentView.subviews)
					[subview removeFromSuperview];
			}
			NSString* lifeiconfilename;
			UIView* life1;
			UIView* life2;
			UIView* life3;
			switch (row)	{
				case (0):
					lifeiconfilename=@"heartwithline.png";
					break;
				case (1):
					lifeiconfilename=@"greenleaf.png";
					break;
				case (2):
					lifeiconfilename=@"redleaf.png";
					break;
				case (3):
					lifeiconfilename = LIFEICON;
					break;
			}
			if (row>=0 && row<=4)	{
				life1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				life2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				life3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				life1.frame = CGRectMake(20,0,50,50);
				life2.frame = CGRectMake(80,0,50,50);
				life3.frame = CGRectMake(140,0,50,50);
			}
			else {
				life1= [[Baby alloc] initWithFrame:CGRectMake(10, 0, 50,50) AndColor:kRed AndOrientation:11];
				life2= [[Baby alloc] initWithFrame:CGRectMake(10+30, 0, 50,50) AndColor:kGreen AndOrientation:11];
				life3= [[Baby alloc] initWithFrame:CGRectMake(10+30*2, 0, 50,50) AndColor:kBlue AndOrientation:11];
			}
			
			[cell.contentView addSubview:life1];
			[cell.contentView addSubview:life2];
			[cell.contentView addSubview:life3];
			
			if (([[LocalStorageManager stringForKey:LIFEICON] isEqualToString:lifeiconfilename]))	{
				UIImageView* selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluebean0.png"]];
				selectedView.frame = CGRectMake(240,10,30,30);
				[cell.contentView addSubview:selectedView];
				[selectedView release];
			}
			break;
			
		case (0):
			cell = [tableView dequeueReusableCellWithIdentifier:@"images"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"images"] autorelease];
			}
			else {
				for (UIView* subview in cell.contentView.subviews)
					[subview removeFromSuperview];
			}
			
			ButState color; 
			if (row%3==0)
				color = kRed;
			else if (row%3==1)
				color = kGreen;
			else
				color = kBlue;
			/* Default Images */
			if (row==0)	{
				Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(0, 0, 80,80) AndColor:color AndOrientation:11];
				[baby changeToNormal:[UIImage imageNamed:@"closemonthbaby.png"]];
				[cell.contentView addSubview:baby];
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(40, 0, 80,80) AndColor:color AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby changeToOpenMouth:[UIImage imageNamed:@"baby.png"]];
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(80, 0, 80,80) AndColor:color AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby changeToCrying:[UIImage imageNamed:@"cryingbaby.png"]];
				[baby release];
			}
			/* Stored Images */
			else if (row<[self.inGameImages count]+1)	{
				NSArray* keys = [self.inGameImages allKeys];
				NSString* key = [keys objectAtIndex:row-1];
				NSArray* images = [self.inGameImages objectForKey:key];
				Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(0, 0, 80,80) AndColor:color AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby changeToNormal:(UIImage*)[images objectAtIndex:0]];
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(40, 0, 80,80) AndColor:color AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby changeToOpenMouth:(UIImage*)[images objectAtIndex:1]] ;
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(80, 0, 80,80) AndColor:color AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby changeToCrying:(UIImage*)[images objectAtIndex:2]];
				[baby release];
				
				if (([[LocalStorageManager stringForKey:INGAMEIMAGESKEY] isEqualToString:key]) || ([LocalStorageManager stringForKey:INGAMEIMAGESKEY]==nil && row==1))	{
					UIImageView* selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redbutton.png"]];
					selectedView.frame = CGRectMake(225,0,80,80);
					[cell.contentView addSubview:selectedView];
					[selectedView release];
				}
				
			}
			
			/* New Images */
			else if (row==[self.inGameImages count]+1)	{
				if (self.normalFace)	{
					Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(0, 0, 80,80) AndColor:color AndOrientation:11];
					[cell.contentView addSubview:baby];
					[baby changeToNormal:self.normalFace.image];
					[baby release];
				}
				else {
					UIImageView* tmp = [[UIImageView alloc ] initWithImage: [UIImage imageNamed:@"frog.png"]];
					tmp.frame = CGRectMake(0, 0, 80,80);
					[cell.contentView addSubview:tmp];
					[tmp release];
				}
				
				UIButton* snapBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				snapBut.titleLabel.numberOfLines = 1;
				snapBut.titleLabel.font = [UIFont systemFontOfSize:12];
				[snapBut setTitle:NSLocalizedString(@"開心拍照",nil) forState:UIControlStateNormal];
				[snapBut setFrame:CGRectMake(0, 90, 70, 30)];
				[snapBut setTag:1];
				[snapBut addTarget:self action:@selector(snap:) forControlEvents:UIControlEventTouchUpInside];				
				[cell.contentView addSubview:snapBut];
				
				if (self.openMouthFace)	{
					Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(40, 0, 80,80) AndColor:color AndOrientation:11];
					[cell.contentView addSubview:baby];
					[baby changeToOpenMouth:self.openMouthFace.image];
					[baby release];
				}
				else {
					UIImageView* tmp = [[UIImageView alloc ]initWithImage: [UIImage imageNamed:@"frog.png"]];
					tmp.frame = CGRectMake(80, 0, 80,80);
					[cell.contentView addSubview:tmp];
					[tmp release];
				}
				
				snapBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				snapBut.titleLabel.numberOfLines = 1;
				snapBut.titleLabel.font = [UIFont systemFontOfSize:12];
				[snapBut setTitle:NSLocalizedString(@"O嘴拍照",nil) forState:UIControlStateNormal];
				[snapBut setFrame:CGRectMake(80, 90, 70, 30)];
				[snapBut setTag:2];
				[snapBut addTarget:self action:@selector(snap:) forControlEvents:UIControlEventTouchUpInside];				
				[cell.contentView addSubview:snapBut];
				
				
				if (self.cryingFace)	{
					Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(80, 0, 80,80) AndColor:color AndOrientation:11];
					[cell.contentView addSubview:baby];
					[baby changeToCrying:self.cryingFace.image];
					[baby release];
				}
				else {
					UIImageView* tmp = [[UIImageView alloc ]initWithImage: [UIImage imageNamed:@"frog.png"]];
					[cell.contentView addSubview:tmp];
					tmp.frame = CGRectMake(160, 0, 80,80);
					[tmp release];
				}
				
				snapBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				snapBut.titleLabel.numberOfLines = 1;
				snapBut.titleLabel.font = [UIFont systemFontOfSize:12];
				[snapBut setTitle:NSLocalizedString(@"扁咀拍照",nil) forState:UIControlStateNormal];
				[snapBut setFrame:CGRectMake(160, 90, 70, 30)];
				[snapBut setTag:3];
				[snapBut addTarget:self action:@selector(snap:) forControlEvents:UIControlEventTouchUpInside];				
				[cell.contentView addSubview:snapBut];
				
				if (self.normalFace && self.openMouthFace && self.cryingFace)	{
					UIButton* addBut = [UIButton buttonWithType:UIButtonTypeContactAdd];
					addBut.frame = CGRectMake(260, 30, 30, 30);
					[cell.contentView addSubview:addBut];
					[addBut addTarget:self action:@selector(addInGameImages:) forControlEvents:UIControlEventTouchDown];
				}
				
			}
			break;
	}
	
	return cell;
}



-(void) addInGameImages:(id)sender
{
	NSArray* images = [NSArray arrayWithObjects:self.normalFace.image, self.openMouthFace.image, self.cryingFace.image, nil];
	[LocalStorageManager addImagesToStorage:images];
	self.inGameImages = [LocalStorageManager getInGameImages];
	self.openMouthFace=nil;
	self.normalFace = nil;
	self.cryingFace = nil;
	[self.tableView reloadData];
}



-(void) snap:(id)sender
{
	if (NSClassFromString(@"AVCaptureDevice") != nil)	{
#if TARGET_OS_EMBEDDED
		PhotoTakingViewController* vc = [[PhotoTakingViewController alloc]init];
		vc.delegate = self;
		vc.faceType = [sender tag];
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];
#endif
	}
	else {
		// open an alert with just an OK button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"需要iOS4.0或以後版本",nil) 
														message:NSLocalizedString(@"樣貎偵測功能只能在iOS4.0或以後版本上運行",nil)
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		alert.tag=0;
		[alert show];	
		[alert release];
		return;
	}
	
}

-(void) finishedSnapWithFaceType:(int) faceType AndImage:(UIImageView*)theImage 
{
	theImage.frame = CGRectMake(40,0,80, 80);
	switch (faceType)	{
		case (1):
			self.normalFace = theImage;
			break;
		case (2):
			self.openMouthFace = theImage;
			break;
		case (3):
			self.cryingFace = theImage;
			break;
	}
	[self.tableView reloadData];
}

@end
