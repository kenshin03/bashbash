//
//  QuickPencilOpponent.m 
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickPencilOpponent.h"

@implementation QuickPencilOpponent 

@synthesize owner = _owner;
@synthesize pencilHoldingHandImageView = _pencilHoldingHandImageView;


- (id)initWithOwner:(id)owner isMyself:(BOOL)isMyself	{
	self.owner = owner;
	
	NSMutableArray *pencilHoldingHandAnimatedImagesArray = [NSMutableArray arrayWithCapacity:18];
	for(int x = 1; x < 18; x++){
		[pencilHoldingHandAnimatedImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"opp_pencil%d.png", x]]];
	}
	
	
//	if (isMyself)	{
		self = [super initWithFrame:CGRectMake(10, 0, 215, 378)];
		self.pencilHoldingHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 215, 378)];
		self.pencilHoldingHandImageView.image = [UIImage imageNamed:@"opp_pencil1.png"];
		self.pencilHoldingHandImageView.animationImages = pencilHoldingHandAnimatedImagesArray;
		self.pencilHoldingHandImageView.contentMode = UIViewContentModeBottomLeft;
		self.pencilHoldingHandImageView.animationDuration = (18 * (1/30));
		self.pencilHoldingHandImageView.animationRepeatCount = 1;
		[self addSubview:self.pencilHoldingHandImageView];
		[self setAlpha:0.2];
//	}
//	else {
//		self.pencilHoldingHandImageView = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftgirl_bw" ofType:@"png"]];
//	}

	return self;
}


- (void) dealloc
{
	NSLog(@"dealloc pencilHoldingHandImage");
	self.pencilHoldingHandImageView = nil;
	[super dealloc];
}


- (void) buttonClicked
{	
	if ([self.pencilHoldingHandImageView isAnimating] == YES){
		[self.pencilHoldingHandImageView stopAnimating];
	}
	[self.pencilHoldingHandImageView startAnimating];
}



@end
