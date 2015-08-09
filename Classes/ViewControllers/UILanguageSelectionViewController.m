//
//  GameFrameSelectonController.m
//  bishibashi
//
//  Created by Eric on 23/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UILanguageSelectionViewController.h"

@implementation UILanguageSelectionViewController
@synthesize delegate = _delegate;
@synthesize availableLanguages = _availableLanguages;
@synthesize availableLanguagesLN = _availableLanguagesLN;

-(id) initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])	{
		self.availableLanguages = [NSArray arrayWithObjects:@"zh-hk", @"zh-Hans", @"zh_TW", @"en-hk", nil];
		self.availableLanguagesLN = [NSArray arrayWithObjects:@"繁體中文(香港廣東話）", @"簡体中文", @"繁體中文（台灣）",@"English", nil];
	}
	
	return self;
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
	cell.textLabel.text = [self.availableLanguagesLN objectAtIndex:row];
	cell.textLabel.textColor = [UIColor blackColor];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.availableLanguages count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIAlertView *alert;
	switch(indexPath.row)	{
		case(0)://zh-hk
			alert = [[UIAlertView alloc] initWithTitle:@"設定會在重新啟動後生效" message:@"你選擇的語言設定會在重新啟動後生效"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
		case(1): //zh-Hans
			alert = [[UIAlertView alloc] initWithTitle:@"选择了简体中文" 
															message:@"你选择的语言设定会在重新启动後生效"
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
		case(2): //zh_TW
			alert = [[UIAlertView alloc] initWithTitle:@"選擇了繁體中文(台灣）" 
											   message:@"你選擇的語言設定會在重新啟動後生效"
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
		case(3): // en
			alert = [[UIAlertView alloc] initWithTitle:@"English Selected" 
											   message:@"Selected Language Setting Would be Effective After App Restart"
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
	}
	
	[self.delegate uiLanguageSelected:[self.availableLanguages objectAtIndex:indexPath.row]];
}

@end
