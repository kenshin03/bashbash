//
//  GetFBMsg.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GetVideo.h"

@implementation VideoData
@synthesize url = _url;
@synthesize thumbnailUrl = _thumbnailUrl;
@synthesize title = _title;
@synthesize submitter = _submitter;
@synthesize submitdate = _submitdate;

@end


@implementation GetVideo
@synthesize videos = _videos;
@synthesize theParser = _theParser;
@synthesize urlStr = _urlStr;
@synthesize elemString = _elemString;
@synthesize currentVideo = _currentVideo;
@synthesize delegate = _delegate;
@synthesize tmpData = _tmpData;

-(id) initWithDelegate:(id)delegate	{
	if (self=[super init])	{
		self.delegate = delegate;
		self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETVIDEOREQ];
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GetVideo");
	self.tmpData = nil;
	self.videos = nil;
	self.theParser = nil;
	self.urlStr = nil;
	self.elemString = nil;
	self.currentVideo = nil;
	[super dealloc];
}

- (void) reInit
{
	self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETVIDEOREQ];
}

- (void) addKey:(NSString*)key AndVal:(NSString*)val
{
	self.urlStr = [NSString stringWithFormat:@"%@&%@=%@", self.urlStr, key, val];
}

- (void) sendReq
{
	NSString* escapedUrl = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(escapedUrl);
	NSURL* url = [NSURL URLWithString:escapedUrl];
	NSURLRequest* req = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:req delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	self.tmpData = nil;
	self.tmpData = [NSMutableData data];
}

- (void) connection: (NSURLConnection*)connection didReceiveData: (NSData*)data
{
	[self.tmpData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSXMLParser* theParser = [[NSXMLParser alloc] initWithData:self.tmpData];
	self.theParser = theParser;
	theParser.delegate = self;
	[theParser parse];
	[theParser release];
}	


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"start parsing");
	NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:20];
	self.videos = arr;
	[arr release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	[self.delegate finished:self.videos];
}

/*
 Function: parseErrorOccurred
 Parameters:
 Description:
 */
- (void) parser: (NSXMLParser*)aParser parseErrorOccurred: (NSError*)anError
{
	NSLog(@"parseErrorOccurred()");
	
	
}

/*
 Function: foundCharacters
 Parameters:
 Description:
 */
- (void) parser: (NSXMLParser*)aParser foundCharacters: (NSString*)aString
{
	if ([self.elemString isEqualToString:@"title"])
		self.currentVideo.title = aString;
	else if ([self.elemString isEqualToString:@"submitdate"])
		self.currentVideo.submitdate = aString;
	else if ([self.elemString isEqualToString:@"thumbnailurl"])
		self.currentVideo.thumbnailUrl = aString;
	else if ([self.elemString isEqualToString:@"url"])
		self.currentVideo.url = aString;
	else if ([self.elemString isEqualToString:@"submitter"])
		self.currentVideo.submitter = aString;
	if ([self.elemString isEqualToString:@"submitter"])
		self.currentVideo.submitter = aString;
	
}

/*
 Function: didStartElement
 Parameters:
 Description:
 */
- (void) parser: (NSXMLParser*)aParser didStartElement: (NSString*)anElementName namespaceURI: (NSString*)aNamespaceURI qualifiedName: 
(NSString*)aQualifierName attributes: (NSDictionary*)anAttributeDict
{
	self.elemString = anElementName;
	if ([self.elemString isEqualToString:@"video"])	{
		VideoData* theVideo = [[VideoData alloc]init];
		self.currentVideo = theVideo;
		[theVideo release];
		[self.videos addObject:self.currentVideo];
	}
}

@end