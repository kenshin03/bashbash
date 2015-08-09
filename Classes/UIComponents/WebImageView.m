//
//  WebImageView.m
//  FBModule
//
//  Created by Eric on 20/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebImageView.h"


@implementation WebImageView

@synthesize imageUrl = _imageUrl;
@synthesize aiView = _aiView;
@synthesize imageView = _imageView;
@synthesize imageData = _imageData;
@synthesize recvImage = _recvImage;

-(id) initWithFrame:(CGRect)frame AndImageUrl:(NSString*)imageUrl
{
	if (self = [super initWithFrame:frame])	{
		UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.aiView = aiView;
		[aiView release];
		self.aiView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
		[self.aiView startAnimating];
		self.aiView.hidesWhenStopped = YES;
		[self addSubview:self.aiView];
		if (imageUrl)	{
			self.imageUrl = imageUrl;
			NSLog(@"imageUrl is %@", self.imageUrl);
			NSData* imageData = [LocalStorageManager objectForKey:self.imageUrl];
			if (imageData)	{
				NSLog(@"Load image from cache");
				UIImage * recvImage = [[UIImage alloc] initWithData:imageData];
				UIImageView* imageView = [[UIImageView alloc] initWithImage:[recvImage scaleImage:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)]];
				self.imageView = imageView;
				[imageView release];
				[recvImage release];
				[self.aiView stopAnimating];
				[self addSubview:self.imageView];
			}
			else{
				NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
				[NSURLConnection connectionWithRequest:request delegate:self];
			}
		}					   
		else {
			[self.aiView stopAnimating];
		}

	}
	return self;
}

- (void) initImageUrl:(NSString*) imageUrl
{
	self.imageUrl = imageUrl;
	
	UIImage * recvImage = [[UIImage alloc] initWithData:self.imageData];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[recvImage scaleImage:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)]];

	
	if (imageUrl)	{
		NSData* imageData = [LocalStorageManager objectForKey:self.imageUrl];
		if (imageData)	{
			NSLog(@"Load image from cache");
			UIImage * recvImage = [[UIImage alloc] initWithData:imageData];
			UIImageView* imageView = [[UIImageView alloc] initWithImage:[recvImage scaleImage:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)]];
			self.imageView = imageView;
			[imageView release];
			[recvImage release];
			[self.aiView stopAnimating];
			[self addSubview:self.imageView];
		}
		else 	{
			NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
			[NSURLConnection connectionWithRequest:request delegate:self];
		}
	}
	else {
		[self.imageView removeFromSuperview];
		self.imageView = nil;
		[self.aiView stopAnimating];
	}
	
}	


-(void) dealloc
{
	self.recvImage = nil;
	self.imageUrl = nil;
	self.aiView = nil;
	self.imageView = nil;
	self.imageData = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	self.imageData = nil;
	self.imageData = [NSMutableData data];
}

- (void) connection: (NSURLConnection*)connection didReceiveData: (NSData*)data
{
	[self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage * recvImage = [[UIImage alloc] initWithData:self.imageData];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[recvImage scaleImage:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)]];
	[LocalStorageManager setObject:self.imageData forKey:self.imageUrl];
	self.imageView = imageView;
	[imageView release];
	[recvImage release];
	[self.aiView stopAnimating];
	[self addSubview:self.imageView];
	NSLog(@"Did finished dowdloading image");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error : Download image fail!!!!!!");
}

@end
