//
//  SinaMicroBlogUpdater.m
//  OneMinApp
//
//  Created by Kenny Tang on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SinaMicroBlogUpdater.h"
#import "LocalStorageManager.h"

@implementation SinaMicroBlogUpdater

- (id)init {
	self = [ super init ];
	responseData = [[NSMutableData data] retain];
	return self;
	
}

- (void) postTweetToSinaMicroBlog:(NSString*)tweetString{
	NSLog(@"postTweetToSinaMicroBlog called...");
	
	NSString *loginSinaURLString = @"https://login.sina.com.cn/sso/login.php";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginSinaURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&returntype=TEXT", 
                           [LocalStorageManager stringForKey:SINA_USER], 
                           [LocalStorageManager stringForKey:SINA_PASSWORD]] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
    [request setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.1) Gecko/2008070206 Firefox/3.0.1" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"300" forHTTPHeaderField:@"Keep-Alive"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *data = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	
    NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://temp"]];
    // Store the cookies - NSHTTPCookieStorage is a Singleton.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://temp"] mainDocumentURL:nil];
    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://temp"]];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
	
	//
	// try to post tweet
	NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://t.sina.com.cn/mblog/publish.php?"]];
    [request2 setAllHTTPHeaderFields:headers];
	[request2 setHTTPMethod:@"POST"];
	[request2 setValue:@"http://t.sina.com.cn/" forHTTPHeaderField:@"Referer"];
	
	NSString *tweetStringFull = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"我在iPhone拍拍機創下了新記錄: ",nil),tweetString];
	
	[request2 setHTTPBody:[[NSString stringWithFormat:@"content=%@", 
							tweetStringFull] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	//	NSError *error2;
	//	NSURLResponse *response2;
	//	NSData * data2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
	[NSURLConnection connectionWithRequest:request2 delegate:nil];
	
}

- (NSString*) retrieveProfileFromSinaMicroBlog{
	NSLog(@"retrieveProfileFromSinaMicroBlog called...");
	
	NSString *loginSinaURLString = @"https://login.sina.com.cn/sso/login.php";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginSinaURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&returntype=TEXT", 
                           [LocalStorageManager stringForKey:SINA_USER], 
                           [LocalStorageManager stringForKey:SINA_PASSWORD]] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
    [request setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.1) Gecko/2008070206 Firefox/3.0.1" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"300" forHTTPHeaderField:@"Keep-Alive"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *responseString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	NSData *jsonData = [responseString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *jsonDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	NSString *uidString = [jsonDictionary objectForKey:@"uid"];
	
    NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://temp"]];
    // Store the cookies - NSHTTPCookieStorage is a Singleton.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://temp"] mainDocumentURL:nil];
    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://temp"]];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
	
	// try to get profile page
	NSString *requestURLString = @"http://t.sina.com.cn/";
	requestURLString = [requestURLString stringByAppendingFormat:@"%@", uidString];
	requestURLString = [requestURLString stringByAppendingFormat:@"%@", @"/profile"];
	NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    [request2 setAllHTTPHeaderFields:headers];
	[request2 setHTTPMethod:@"POST"];
	[request2 setValue:@"http://t.sina.com.cn/" forHTTPHeaderField:@"Referer"];
	
	NSError *error2;
	NSURLResponse *response2;
	NSData * data2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
	NSString *string2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
	
	NSInteger left; 
	NSScanner *theScanner = [NSScanner scannerWithString:string2];
	NSString *userSinaName;
	[theScanner scanUpToString:@"TrayUserName = '" intoString:NULL];
	left = [theScanner scanLocation];
	[theScanner setScanLocation:left + 16]; // 16 is length of "TrayUserName" string
	[theScanner scanUpToString:@":" intoString:&userSinaName];
	
	NSArray *stringsArray = [userSinaName componentsSeparatedByString: @"'"];
	NSLog(@"userSinaName: %@", [stringsArray objectAtIndex:0]);
	userSinaName = [stringsArray objectAtIndex:0];
	
	[responseString release];
	[string2 release];
	return [userSinaName stringByAppendingFormat:@",%@", uidString];
}

- (void) connection: (NSURLConnection*)connection didReceiveData: (NSData*)data
{
}

@end
