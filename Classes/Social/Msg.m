//
//  Msg.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "Msg.h"


@implementation Msg

@synthesize gameLevel = _gameLevel;
@synthesize fbuid = _fbuid;
@synthesize twusername = _twusername;
@synthesize mbusername = _mbusername;
@synthesize game = _game;
@synthesize score = _score;
@synthesize gameMode = _gameMode;
@synthesize time = _time;
@synthesize fdname = _fdname;
@synthesize image = _image;
@synthesize text = _text;
@synthesize dateLbl = _dateLbl;
@synthesize nameLbl = _nameLbl;
@synthesize textLbl = _textLbl;
@synthesize scoreLbl = _scoreLbl;
@synthesize fdimageurl = _fdimageurl;

const static CGRect nameLblRect = {{45,0}, {130,20}};
const static CGRect dateLblRect = {{180,0}, {100,20}};
const static CGRect textLblRect = {{45,20}, {185,20}};
const static CGRect fullTextLblRect = {{45,20}, {235,50}};
const static CGRect scoreLblRect = {{230,20}, {50,20}};
const static CGRect webImageRect = {{0,0}, {40,40}};

/* have revamped 
const static CGRect nameLblRect = {{45,5}, {130,20}};
const static CGRect dateLblRect = {{180,5}, {50,20}};
const static CGRect textLblRect = {{45,20}, {170,20}};
const static CGRect fullTextLblRect = {{45,5}, {215, 110}};
const static CGRect scoreLblRect = {{230,20}, {50,20}};
const static CGRect webImageRect = {{10,15}, {30,30}};
*/

- (void) dealloc
{
	NSLog(@"dealloc Msg");
	self.text = nil;
	self.image = nil;
	self.fbuid = nil;
	self.mbusername = nil;
	self.twusername = nil;
	self.fdname = nil;
	self.time = nil;
	self.textLbl= nil;
	self.nameLbl = nil;
	self.scoreLbl = nil;
	self.dateLbl = nil;
	self.fdimageurl = nil;
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.text forKey:@"text"];
	[encoder encodeObject:self.fdname forKey:@"fdname"];
	[encoder encodeObject:self.time forKey:@"time"];
	[encoder encodeInt:self.gameLevel forKey:@"gameLevel"];
	[encoder encodeObject:self.fbuid forKey:@"fbuid"];
	[encoder encodeObject:self.twusername forKey:@"twusername"];
	[encoder encodeInt:self.game forKey:@"game"];
	[encoder encodeInt:self.score forKey:@"score"];
	[encoder encodeInt:self.gameMode forKey:@"gamemode"];
	[encoder encodeInt:self.fdimageurl forKey:@"fdimageurl"];
	
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super init]) {
		self.fdname = [decoder decodeObjectForKey:@"fdname"];
		self.text = [decoder decodeObjectForKey:@"text"];
		self.time = [decoder decodeObjectForKey:@"time"];
		self.gameLevel = [decoder decodeIntForKey:@"gameLevel"];
		self.fbuid = [decoder decodeObjectForKey:@"fbuid"];
		self.twusername = [decoder decodeObjectForKey:@"twusername"];
		self.game = [decoder decodeIntForKey:@"game"];
		self.gameLevel = [decoder decodeIntForKey:@"gameLevel"];
		self.score = [decoder decodeIntForKey:@"score"];
		self.gameMode = [decoder decodeIntForKey:@"gamemode"];
		self.fdimageurl = [decoder decodeIntForKey:@"fdimageurl"];
	}
    return self;
}

-(void) initInterfaceWithWidth:(float) width
{
	[self.nameLbl removeFromSuperview];
	[self.textLbl removeFromSuperview];
	[self.dateLbl removeFromSuperview];
	[self.scoreLbl removeFromSuperview];
	[self.image removeFromSuperview];

	UILabel* nameLbl = [[UILabel alloc] initWithFrame:nameLblRect];
	self.nameLbl = nameLbl;
	[nameLbl release];
	self.nameLbl.backgroundColor = [UIColor clearColor];
	self.nameLbl.text = self.fdname;
	self.nameLbl.font = [UIFont boldSystemFontOfSize:12];
	self.nameLbl.textColor = [UIColor blueColor]; 
	[self addSubview:self.nameLbl];
	
	UILabel* dateLbl = [[UILabel alloc] initWithFrame:dateLblRect];
	self.dateLbl = dateLbl;
	[dateLbl release];
	self.dateLbl.backgroundColor = [UIColor clearColor];
	self.dateLbl.text = [NSString WMDHHMMSS:self.time];
	self.dateLbl.font = [UIFont systemFontOfSize:10];
	self.dateLbl.textColor = [UIColor darkGrayColor]; 
	self.dateLbl.lineBreakMode = UILineBreakModeClip;
	[self addSubview:self.dateLbl];
	
	if (self.text)	{
		UILabel* textLbl = [[UILabel alloc] initWithFrame:fullTextLblRect];
		self.textLbl = textLbl;
		[textLbl release];
		self.textLbl.backgroundColor = [UIColor clearColor];
		self.textLbl.text =self.text;
		self.textLbl.font = [UIFont systemFontOfSize:12];
		self.textLbl.textColor = [UIColor darkGrayColor]; 
		self.textLbl.lineBreakMode = UILineBreakModeClip;
		self.textLbl.numberOfLines = 3;
		[self addSubview:self.textLbl];
	}
	else{
		
		NSMutableString* str = [NSMutableString stringWithCapacity:50];

		switch ((GameLevel)(self.gameLevel))	{
			case (kEasy):
				[str appendString:@"Easy"];
				break;
			case (kNormal):
				[str appendString:@"Normal"];
				break;
			case (kHard):
				[str appendString:@"Hard"];
				break;
			case (kWorldClass):
				[str appendString:@"Master"];
				break;
		}
		[str appendString:@"\t"];
		if (self.game==-1)
			[str appendString: NSLocalizedString(@"街機模式", nil)];			
		else
			[str appendString: [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]]];
		UILabel* textLbl = [[UILabel alloc] initWithFrame:textLblRect];
		self.textLbl = textLbl;
		[textLbl release];
		self.textLbl.backgroundColor = [UIColor clearColor];
		self.textLbl.text =str;
		self.textLbl.font = [UIFont systemFontOfSize:12];
		self.textLbl.textColor = [UIColor darkGrayColor]; 
		self.textLbl.lineBreakMode = UILineBreakModeClip;
		[self addSubview:self.textLbl];
		
		UILabel* scoreLbl = [[UILabel alloc] initWithFrame:scoreLblRect];
		self.scoreLbl = scoreLbl;
		[scoreLbl release];
		self.scoreLbl.backgroundColor = [UIColor clearColor];
		self.scoreLbl.text = [NSString stringWithFormat:@"%d", self.score];
		self.scoreLbl.font = [UIFont boldSystemFontOfSize:18];
		self.scoreLbl.textColor = [UIColor redColor]; 
		self.scoreLbl.lineBreakMode = UILineBreakModeClip;
		[self addSubview:self.scoreLbl];
	}
	

	if (self.fdimageurl && self.fdimageurl != kCFNull)	{
		WebImageView* webImageView = [[WebImageView alloc] initWithFrame:webImageRect AndImageUrl:self.fdimageurl];
		self.image = webImageView;
		[webImageView release];
		[self addSubview:self.image];
	}
}