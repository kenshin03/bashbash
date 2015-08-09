//
//  GetFBMsg.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GetMsg.h"


@implementation GetMsg
@synthesize msgs = _msgs;
@synthesize theParser = _theParser;
@synthesize urlStr = _urlStr;
@synthesize elemString = _elemString;
@synthesize currentMsg = _currentMsg;
@synthesize delegate = _delegate;
@synthesize tmpData = _tmpData;

-(id) initWithDelegate:(id)delegate	{
	if (self=[super init])	{
		self.delegate = delegate;
		self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETMSGDREQ];
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GetMsg");
	self.tmpData = nil;
	self.msgs = nil;
	self.theParser = nil;
	self.urlStr = nil;
	self.elemString = nil;
	self.currentMsg = nil;
	[super dealloc];
}

- (void) reInit
{
	self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETMSGDREQ];
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
	self.msgs = arr;
	[arr release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	[self.delegate finished:self.msgs];
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
	objc_property_t property = class_getProperty([self.currentMsg class], [self.elemString UTF8String]);
	if (property)	{
		char *prop = property_getAttributes(property);
		if (prop[1]=='@')	{
			if ([self.elemString isEqualToString:@"time"])	{
				NSTimeInterval unixDate = [aString doubleValue]/1000;
				[self.currentMsg setValue:[NSDate dateWithTimeIntervalSince1970:unixDate] forKey:self.elemString];
			}
			else
				[self.currentMsg setValue:aString forKey:self.elemString];
		}
		else if (prop[1]=='i') {
			[self.currentMsg setValue:[NSNumber numberWithInt:[aString intValue]] forKey:self.elemString];
		}
		else if (prop[1]=='f') {
			[self.currentMsg setValue:[NSNumber numberWithFloat:[aString floatValue]] forKey:self.elemString];
		}
		else if (prop[1]=='B' || prop[1]=='c') {
			[self.currentMsg setValue:[NSNumber numberWithBool:[aString boolValue]] forKey:self.elemString];
		}
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
	if ([self.elemString isEqualToString:@"msg"])	{
		Msg* theMsg = [[Msg alloc]init];
		self.currentMsg = theMsg;
		[theMsg release];
		[self.msgs addObject:self.currentMsg];
	}
}

@end