//
//  GetGameRecord.m
//  bishibashi
//
//  Created by Eric on 08/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GetGameRecord.h"

@implementation GetGameRecord
@synthesize gameRecords = _gameRecords;
@synthesize theParser = _theParser;
@synthesize urlStr = _urlStr;
@synthesize elemString = _elemString;
@synthesize currentGameRecord = _currentGameRecord;
@synthesize delegate = _delegate;
@synthesize tmpData = _tmpData;

-(id) initWithDelegate:(id)delegate	{
	if (self=[super init])	{
		self.delegate = delegate;
		self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETGAMERECORDREQ];
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GetGameRecord");
	self.tmpData = nil;
	self.gameRecords = nil;
	self.theParser = nil;
	self.urlStr = nil;
	self.elemString = nil;
	self.currentGameRecord = nil;
	[super dealloc];
}

- (void) reInit
{
	self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETGAMERECORDREQ];
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
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:[[Constants sharedInstance] noGames]];
	for (int i=0; i<[[Constants sharedInstance] noGames]; i++)	{
		NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:[[Constants sharedInstance] noGames]];
		[dict setObject:arr forKey:[NSNumber numberWithInt:i]];
		[arr release];
	}
	self.gameRecords = dict;
	[dict release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	[self.delegate finished:self.gameRecords];
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
	objc_property_t property = class_getProperty([self.currentGameRecord class], [self.elemString UTF8String]);
	if (property==NULL)
		return;
	char *prop = property_getAttributes(property);
	if (prop[1]=='@')	{
		if ([self.elemString isEqualToString:@"time"])	{
			NSTimeInterval unixDate = [aString doubleValue]/1000;
			[self.currentGameRecord setValue:[NSDate dateWithTimeIntervalSince1970:unixDate] forKey:self.elemString];
		}
		else
			[self.currentGameRecord setValue:aString forKey:self.elemString];
	}
	else if (prop[1]=='i') {
		[self.currentGameRecord setValue:[NSNumber numberWithInt:[aString intValue]] forKey:self.elemString];
	}
	else if (prop[1]=='f') {
		[self.currentGameRecord setValue:[NSNumber numberWithFloat:[aString floatValue]] forKey:self.elemString];
	}
	else if (prop[1]=='B' || prop[1]=='c') {
		[self.currentGameRecord setValue:[NSNumber numberWithBool:[aString boolValue]] forKey:self.elemString];
	}
	
	if ([self.elemString isEqualToString:@"game"])	{
		[[self.gameRecords objectForKey:[NSNumber numberWithInt:[aString intValue]]] addObject:self.currentGameRecord];
	}
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
	if ([self.elemString isEqualToString:@"gamerecord"])	{
		GameRecord* theGameRecord = [[GameRecord alloc]init];
		theGameRecord.isShown = NO;
		self.currentGameRecord = theGameRecord;
		[theGameRecord release];
	}
}

@end
