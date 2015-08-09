//
//  Video.m
//  bishibashi
//
//  Created by Eric on 29/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "VideoTVC.h"

@implementation VideoTVC
@synthesize titleLbl = _titleLbl;
@synthesize submitterLbl = _submitterLbl;
@synthesize submitdateLbl = _submitdateLbl;
@synthesize youTubeView = _youTubeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

		
		UILabel* titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 200, 40)];
		self.titleLbl = titleLbl;
		[titleLbl release];
		self.titleLbl.backgroundColor = [UIColor clearColor];
		self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
		self.titleLbl.numberOfLines = 2;
		self.titleLbl.textColor = [UIColor blackColor];
		[self.contentView addSubview:self.titleLbl];
		
		UILabel* submitterLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 150, 20)];
		self.submitterLbl = submitterLbl;
		[submitterLbl release];
		self.submitterLbl.backgroundColor = [UIColor clearColor];
		self.submitterLbl.font = [UIFont boldSystemFontOfSize:14];
		self.submitterLbl.textColor = [UIColor redColor]; 
		[self.contentView addSubview:self.submitterLbl];

		UILabel* submitdateLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 150, 20)];
		self.submitdateLbl = submitdateLbl;
		[submitdateLbl release];
		self.submitdateLbl.backgroundColor = [UIColor clearColor];
		self.submitdateLbl.font = [UIFont systemFontOfSize:14];
		self.submitdateLbl.textColor = [UIColor grayColor];
		[self.contentView addSubview:self.submitdateLbl];
		
    }
    return self;
}

-(void) setContentWithVideoData:(VideoData*)videoData
{
	
	self.titleLbl.text = videoData.title;
	self.submitterLbl.text = videoData.submitter;
	self.submitdateLbl.text = videoData.submitdate;
	YouTubeView *youTubeView = [[YouTubeView alloc] 
								initWithStringAsURL:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", videoData.url]
								frame:CGRectMake(0, 0, 100, 100)];
	
	[self.contentView addSubview:youTubeView];
	self.youTubeView = youTubeView;
	[youTubeView release];
}
	
- (void) prepareForReuse
{
	self.titleLbl.text = @"";
	self.submitterLbl.text= @"";
	self.submitdateLbl.text = @"";
	self.youTubeView=nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	NSLog(@"dealloc VideoTVC");
	self.youTubeView = nil;
	self.titleLbl = nil;
	self.submitterLbl = nil;
	self.submitdateLbl = nil;
    [super dealloc];
}


@end
