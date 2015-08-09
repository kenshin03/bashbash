//
//  GetFBMsg.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GetGeoBoxes.h"

@implementation GeoBox
@synthesize gps_x = _gps_x;
@synthesize gps_y = _gps_y;
@synthesize count = _count;

@end


@implementation GetGeoBoxes
@synthesize geoBoxes = _geoBoxes;
@synthesize theParser = _theParser;
@synthesize urlStr = _urlStr;
@synthesize elemString = _elemString;
@synthesize currentGeoBox = _currentGeoBox;
@synthesize delegate = _delegate;
@synthesize tmpData = _tmpData;

-(id) initWithDelegate:(id)delegate	{
	if (self=[super init])	{
		self.delegate = delegate;
		self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETMAPREQ];
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GetVideo");
	self.tmpData = nil;
	self.geoBoxes = nil;
	self.theParser = nil;
	self.urlStr = nil;
	self.elemString = nil;
	self.currentGeoBox = nil;
	[super dealloc];
}

- (void) reInit
{
	self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETMAPREQ];
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
	self.geoBoxes = arr;
	[arr release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	[self.delegate finished:self.geoBoxes];
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
	if ([self.elemString isEqualToString:@"gps_x"])
		self.currentGeoBox.gps_x = [aString floatValue]; 
	else if ([self.elemString isEqualToString:@"gps_y"])
		self.currentGeoBox.gps_y = [aString floatValue];
	else if ([self.elemString isEqualToString:@"count"])
		self.currentGeoBox.count = [aString intValue];
	
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
	if ([self.elemString isEqualToString:@"geobox"])	{
		GeoBox* theGeoBox = [[GeoBox alloc]init];
		self.currentGeoBox = theGeoBox;
		[theGeoBox release];
		[self.geoBoxes addObject:self.currentGeoBox];
	}
}

@end