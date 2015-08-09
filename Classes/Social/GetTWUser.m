//
//  GetFBMsg.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GetTWUser.h"


@implementation GetTWUser
@synthesize theParser = _theParser;
@synthesize urlStr = _urlStr;
@synthesize elemString = _elemString;
@synthesize delegate = _delegate;
@synthesize tmpData = _tmpData;
@synthesize twuserimageurl = _twuserimageurl;

-(id) initWithDelegate:(id)delegate	{
	if (self=[super init])	{
		self.delegate = delegate;
		self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETTWUSERREQ];
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GetTWUser");
	self.tmpData = nil;
	self.theParser = nil;
	self.urlStr = nil;
	self.elemString = nil;
	self.twuserimageurl=nil;
	[super dealloc];
}

- (void) reInit
{
	self.urlStr = [NSString stringWithFormat:@"%@%@", HOSTURL, GETTWUSERREQ];
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
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	[self.delegate finished:self.twuserimageurl];
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
	if ([self.elemString isEqualToString:@"twuserimageurl"])
		self.twuserimageurl = aString;
	
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
}

@end