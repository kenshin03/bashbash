//
//  PolaroidFilm.m
//  bishibashi
//
//  Created by Eric on 29/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "PolaroidFilm.h"


@implementation PolaroidFilm
@synthesize textLbl = _textLbl;
@synthesize color = _color;
@synthesize images = _images;
@synthesize titleLbl = _titleLbl;
@synthesize fontSize = _fontSize;

static const CGRect textRect = {{10, 10}, {65, 65}};
static const CGRect titleRect = {{15, 76}, {60, 16}};



- (id) initWithColor:(NSString*)color AndText:(NSString*)text AndTitle:(NSString*)title
{
	if (self = [super initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@film", color] ofType:@"png"]]])	{
		UILabel* textLbl = [[UILabel alloc] initWithFrame:textRect];
		textLbl.text = text;
		textLbl.font = [UIFont boldSystemFontOfSize:17];
		textLbl.adjustsFontSizeToFitWidth = YES;
		textLbl.minimumFontSize = 6.0;
		textLbl.textColor = [UIColor whiteColor];
		textLbl.backgroundColor = [UIColor clearColor];
		textLbl.textAlignment = UITextAlignmentCenter;
		textLbl.numberOfLines = 3;
		self.textLbl = textLbl;
		[textLbl release];
		[self addSubview:self.textLbl];

		UILabel* titleLbl = [[UILabel alloc] initWithFrame:titleRect];
		titleLbl.text = title;
		titleLbl.font = [UIFont boldSystemFontOfSize:16];
		titleLbl.adjustsFontSizeToFitWidth = YES;
		titleLbl.minimumFontSize = 8.0;
		titleLbl.textColor = [UIColor blackColor];
		titleLbl.backgroundColor = [UIColor clearColor];
		titleLbl.textAlignment = UITextAlignmentRight;
		self.titleLbl = titleLbl;
		[titleLbl release];
		[self addSubview:self.titleLbl];
	}
	return self;
}

- (void) setFontSize:(CGFloat)fontSize
{
	_fontSize = fontSize;
	self.textLbl.font = [UIFont boldSystemFontOfSize:fontSize];
}
	
- (void) setImages:(NSArray*)images
{
	for (UIImageView* image in images)	{
		[self addSubview:image];
	}
	[self.textLbl setHidden:YES];
}


-(void) setTitle:(NSString *)title
{
	self.titleLbl.text = title;
}

-(void) setText:(NSString *)text
{
	self.textLbl.text = text;
}

- (void) dealloc
{
	self.textLbl = nil;
	self.titleLbl = nil;
	self.color = nil;
	self.images = nil;
	[super dealloc];
}
@end
