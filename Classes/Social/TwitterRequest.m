//
//  TwitterRequest.m
//  Chirpie
//
//  Created by Brandon Trebitowski on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TwitterRequest.h"

@implementation TwitterRequest

@synthesize theRequest = _theRequest;
@synthesize theConnection = _theConnection;
@synthesize receivedData = _receivedData;
@synthesize delegate = _delegate;
@synthesize twStatuss = _twStatuss;
@synthesize currentStatus  = _currentStatus;
@synthesize elmString = _elmString;
@synthesize theParser = _theParser;
@synthesize currentStringValue = _currentStringValue;

static const NSString* STATUS_ELM = @"status";
static const NSString* NAME_ELM = @"name";
static const NSString* CREATEAT_ELM = @"created_at";
static const NSString* IMAGEURL_ELM = @"profile_image_url";

#pragma mark -
#pragma mark Initialization
-(id) initWithDelegate:(id)delegate
{
	if (self=[super init])
		self.delegate = delegate;
	return self;
}

#pragma mark -
#pragma mark Functions provided to send request
-(void)friends_timeline
{
	isPost = NO;
	// The URL of the Twitter Request we intend to send
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/statuses/friends_timeline.xml?count=%d",[[LocalStorageManager objectForKey:TWNUMENTRIES] intValue]]];
	[self request:url];
}

-(void)statuses_update:(NSString *)tweetString
{
	isPost = YES;
	// The URL of the Twitter Request we intend to send
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/update.xml"];
	
	NSString *tweetStringFull = [NSString stringWithFormat:@"%@", tweetString];
	requestBody = [NSString stringWithFormat:@"status=%@&source=%@",tweetStringFull, @" "];
	[self request:url];
}

#pragma mark -
#pragma mark Internal request/response handling
-(void)request:(NSURL *) url {
	NSMutableURLRequest* theRequest   = [[NSMutableURLRequest alloc] initWithURL:url];
	self.theRequest = theRequest;
	[theRequest release];
	
	if(isPost) {
		NSLog(@"ispost");
		[self.theRequest setHTTPMethod:@"POST"];
		[self.theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[self.theRequest setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
		[self.theRequest setValue:[NSString stringWithFormat:@"%d",[requestBody length] ] forHTTPHeaderField:@"Content-Length"];
	}
	
	NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	self.theConnection = theConnection;
	[theConnection release];

	if (self.theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		self.receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
		NSLog(@"failed to create connection");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	//NSLog(@"challenged %@",[challenge proposedCredential] );
	
	if (([challenge previousFailureCount] == 0) && [LocalStorageManager stringForKey:TWUSERNAME]!=nil && [LocalStorageManager stringForKey:TWPASSWORD] !=nil){
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:[LocalStorageManager stringForKey:TWUSERNAME]
                                                 password:[LocalStorageManager stringForKey:TWPASSWORD]
                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];

    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		NSLog(@"Invalid Username or Password");
		[self.delegate failedGetFeed:@"invalid username or password"];
    }
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"did receive response");
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    //[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"did receive data");
	//NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
	self.theConnection = nil;
    // receivedData is declared as a method instance elsewhere
	self.receivedData  = nil;
	self.theRequest = nil;
	
	if (isPost == NO)	{
		// inform the user
		NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
		[self.delegate failedGetFeed:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
								  [error localizedDescription],
								  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]];
	}
	else {
		NSLog(@"Connection failed! Error - %@ %@",
			  [error localizedDescription],
			  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
		[self.delegate failedPosting:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
									  [error localizedDescription],
									  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]];		
	}

	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"did finish loading");

	NSXMLParser* theParser = [[NSXMLParser alloc] initWithData:self.receivedData];
	self.theParser = theParser;
	theParser.delegate = self;
	[theParser parse];
	[theParser release];
	
	NSLog(@"release the connection, and the data object ");
	// release the connection, and the data object
	self.theConnection = nil;
	self.receivedData = nil;
	self.theRequest = nil;
	NSLog(@"released the connection, and the data object ");
}

-(void) dealloc {
	NSLog(@"deallc twitterRequest");
	self.currentStringValue = nil;
	self.theParser = nil;
	self.twStatuss = nil;
	self.currentStatus = nil;
	self.elmString = nil;
	[super dealloc];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"start parsing");
	NSMutableArray* twstatuss = [NSMutableArray arrayWithCapacity:10];
	self.twStatuss = twstatuss;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"end parsing");
	if ([self.currentStringValue hasPrefix:@"Could not authenticate you"])	{
		NSLog(self.currentStringValue);
		[self.delegate failedGetFeed:self.currentStringValue];
		return;
	}

	if (isPost)	{
		if([self.delegate respondsToSelector:@selector(finishedStatusUpdate:)]) {
			[self.delegate performSelector:@selector(finishedStatusUpdate:) withObject:[NSNumber numberWithInt:kModuleSrcTW]];
		}
	}
	else if(self.delegate) {
		if([self.delegate respondsToSelector:@selector(finishedGetFeedForModule:WithResult:)]) {
			[self.delegate performSelector:@selector(finishedGetFeedForModule:WithResult:) withObject:[NSNumber numberWithInt:kModuleSrcTW] withObject:self.twStatuss];
		}
	}
}

/*
 Function: parseErrorOccurred
 Parameters:
 Description:
 */
- (void) parser: (NSXMLParser*)aParser parseErrorOccurred: (NSError*)error
{
	NSLog(@"parseErrorOccurred()");
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	[self.delegate failedGetFeed:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
								  [error localizedDescription],
								  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]];
//	self.delegate = nil;
}

/*
 Function: foundCharacters
 Parameters:
 Description:
 */
- (void) parser: (NSXMLParser*)aParser foundCharacters: (NSString*)aString
{
	if (!self.currentStringValue)
		self.currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
	[self.currentStringValue appendString:aString];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if ([elementName isEqualToString:@"error"])	{
		[self.delegate failedGetFeed:self.currentStringValue];
		return;
	}

	if (self.currentStatus)	{
		objc_property_t property = class_getProperty([self.currentStatus class], [self.elmString UTF8String]);
		if (property)	{
			char *prop = property_getAttributes(property);
			if (prop[1]=='@')	{
				if (![self.currentStatus valueForKey:self.elmString])
					[self.currentStatus setValue:[self.currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:self.elmString];
			}
			else if (prop[1]=='i') {
				[self.currentStatus setValue:[NSNumber numberWithInt:[self.currentStringValue intValue]] forKey:self.elmString];
			}
			else if (prop[1]=='f') {
				[self.currentStatus setValue:[NSNumber numberWithFloat:[self.currentStringValue floatValue]] forKey:self.elmString];
			}
			else if (prop[1]=='B' || prop[1]=='c') {
				[self.currentStatus setValue:[NSNumber numberWithBool:[self.currentStringValue boolValue]] forKey:self.elmString];
			}	
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
	self.currentStringValue=nil;
	self.elmString = anElementName;
	if ([anElementName isEqualToString:STATUS_ELM])	{
		TWStatus* status = [[TWStatus alloc] init];
		self.currentStatus = status;
		[status release];
		[self.twStatuss addObject:self.currentStatus];
	}	
}


@end
