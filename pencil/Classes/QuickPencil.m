//
//  QuickPencil.m 
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickPencil.h"

@implementation QuickPencil 

@synthesize owner = _owner;
@synthesize pencilHoldingHandImageView = _pencilHoldingHandImageView;


- (id)initWithOwner:(id)owner isMyself:(BOOL)isMyself	{
	self.owner = owner;
	
	NSMutableArray *pencilHoldingHandAnimatedImagesArray = [NSMutableArray arrayWithCapacity:18];
	for(int x = 1; x < 18; x++){
		[pencilHoldingHandAnimatedImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pencil%d.png", x]]];
	}
	
	
	if (isMyself)	{
		self = [super initWithFrame:CGRectMake(80, 0, 215, 378)];
//		NSArray *pencilHoldingHandAnimatedImagesArray  = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"menu_main_button_shine_none.png"], [UIImage imageNamed:@"menu_main_button_shine_quarter.png"], [UIImage imageNamed:@"menu_main_button_shine_half.png"], [UIImage imageNamed:@"menu_main_button_shine_full.png"],[UIImage imageNamed:@"menu_main_button_shine_half.png"], [UIImage imageNamed:@"menu_main_button_shine_quarter.png"], nil];
		self.pencilHoldingHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 215, 378)];
		self.pencilHoldingHandImageView.image = [UIImage imageNamed:@"pencil1.png"];
		self.pencilHoldingHandImageView.animationImages = pencilHoldingHandAnimatedImagesArray;
		self.pencilHoldingHandImageView.contentMode = UIViewContentModeBottomLeft;
//		self.pencilHoldingHandImageView.animationDuration = 0.8;
		self.pencilHoldingHandImageView.animationDuration = (18 * (1/30));
		self.pencilHoldingHandImageView.animationRepeatCount = 1;
		[self addSubview:self.pencilHoldingHandImageView];
	}
	else {
//		self.pencilHoldingHandImageView = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftgirl_bw" ofType:@"png"]];
	}

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
