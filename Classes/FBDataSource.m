//
//  FBDataSource.m
//  Spectrums
//
//  Created by kenny on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FBDataSource.h"
#import "FBConnect.h";
#import "FBRequest.h";

static FBDataSource *sharedInstance = nil;

@implementation FBDataSource

@synthesize messageToPost,  delegate;
@synthesize username = _username;
@synthesize imageurl = _imageurl;
@synthesize permissionStatusForUser = _permissionStatusForUser;
@synthesize fbSession = _fbSession;
@synthesize fduids = _fduids;
- (id) init
{
	if (self = [super init])	{
//		self.fbSession = [FBSession sessionForApplication:@"391495f8b98de4b44503ed0b82d25435" secret:@"1e2e25ad53ed7488825437803dc71f76" delegate:self];
		self.fbSession = [FBSession sessionForApplication:@"a8632c17e98dfc0d1c5cfaaa4901b97c" secret:@"5733a9398ec7c7915f7a525e20451b40" delegate:self];
		[self.fbSession resume];
	}
	return self;
}

+ (id)sharedInstance {
    @synchronized(self) {
        if(sharedInstance == nil)	{
            [[self alloc] init];
		}
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedInstance == nil)  {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}


- (void)dialogDidSucceed:(FBDialog*)dialog {
	NSLog(@"do messageToPost!");
}

- (void)sessionDidLogout:(FBSession*)session {
	self.username = nil;
	self.permissionStatusForUser = nil;
	if (delegate){
		[delegate  FBLoginedWithUserName:@""  AndImageUrl:nil AndUid:nil];
	}
}	

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	NSLog(@"didLogin called!");
	[LocalStorageManager setObject:[NSString stringWithFormat:@"%lld",uid] forKey:FACEBOOK_USER_ID];
	self.fbSession = session;
	[self getLoginedUserName];
	//Instantiate the PermissionStatus class with the user id.
	if (!self.permissionStatusForUser)	{
		FBPermissionStatus* permissionStatusForUser = [[FBPermissionStatus alloc] initWithUserId:uid];
		self.permissionStatusForUser = permissionStatusForUser;
		[permissionStatusForUser release];
		self.permissionStatusForUser.delegate = self;
	}
		
}

/*
- (void) logoutFacebook{
	NSLog(@"logoutFacebook!");
	fbSession = [FBSession sessionForApplication:@"a8632c17e98dfc0d1c5cfaaa4901b97c" secret:@"5733a9398ec7c7915f7a525e20451b40" delegate:self];
	if ([fbSession resume] == YES){
		[fbSession logout];
		[configController clearNameInFacebookButton];
		[configController changeFacebookButtonToLogin];
		self.isLogined = NO;
	}
}
 

- (void) loginFacebook{
	fbSession = [FBSession sessionForApplication:@"a8632c17e98dfc0d1c5cfaaa4901b97c" secret:@"5733a9398ec7c7915f7a525e20451b40" delegate:self];
	BOOL sessionResumed = [fbSession resume];
	if (sessionResumed == NO){
		
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbSession] autorelease];
		[dialog show];
	}
}
*/
- (void)getLoginedUserName { 
    NSString* fql = [NSString stringWithFormat: @"select name,pic_square from user where uid == %lld", [self.fbSession uid]]; 
    NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"]; 
    [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params]; 
} 

- (void)getFriendsList {
	NSString* fql = [NSString stringWithFormat: @"select target_id from connection where source_id == %lld and target_type = \"user\"", [self.fbSession uid]]; 
	NSLog(fql);
    NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"]; 
    [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params]; 
} 

- (void) submitFriendsList {
	NSMutableString* contentStr = [NSMutableString stringWithCapacity:500];
//	[contentStr appendFormat:@"uid=%lld&name=%@&fduids=%@", [self.fbSession uid], self.username, self.fduids];
	[contentStr appendFormat:@"uid=%lld&name=%@", [self.fbSession uid], self.username];
	if (self.imageurl)
		[contentStr appendFormat:@"&imageurl=%@", self.imageurl];
	NSMutableString *shared_secret = [[NSMutableString alloc] init];
	[shared_secret appendString:contentStr];
	[shared_secret appendString:SHAREDSECRET];
	NSMutableData *signedData = [[NSMutableData alloc] init];
	[signedData appendData:[[shared_secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableString *codeString = [NSMutableString string];
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	if (CC_MD5([signedData bytes], [signedData length], digest)) {
		for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
			[codeString appendFormat: @"%02x", (int)(digest[i])];
		}
	}
	[contentStr appendFormat:@"&code=%@", codeString];
	[shared_secret release];
	[signedData release];

	
	NSString* urlStr = [NSString stringWithFormat:@"%@%@%@", HOSTURL,ADDFBUSERREQ,contentStr];
	NSString* escapedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL* url = [NSURL URLWithString:escapedUrl];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[[NSString stringWithFormat:@"fduids=%@",self.fduids] dataUsingEncoding:NSUTF8StringEncoding]];
	[NSURLConnection connectionWithRequest:req delegate:nil];
}


- (void)request:(FBRequest*)request didLoad:(id)result { 
	NSLog(@"FBReqeust return is %@", request.method);
	if ([request.method isEqualToString:@"facebook.Stream.publish"])	{
		NSLog(@"result is %@", result);
	}
	else {
		if ([[request.params objectForKey:@"query"] hasPrefix:@"select name,pic_square from user"])	{
			NSArray* users = result; 
			NSDictionary* user = [users objectAtIndex:0]; 
			NSString* name = [user objectForKey:@"name"]; 
			NSString* imageurl = [user objectForKey:@"pic_square"];
			self.username = name;
			if (imageurl != [NSNull null])
				self.imageurl = imageurl;
				NSLog(@"Query returned name is %@, imageurl is %@", self.username, self.imageurl); 
			 if (self.delegate){
				 [self.delegate FBLoginedWithUserName:self.username AndImageUrl:self.imageurl AndUid:[NSString stringWithFormat:@"%lld",[self.fbSession uid]]];
			 }
			[self getFriendsList];
		}
		else if ([[request.params objectForKey:@"query"] hasPrefix:@"select target_id from connection"])	{
			NSMutableString* fduids = [NSMutableString stringWithCapacity:200];
			[fduids appendString:[[((NSArray*)result) objectAtIndex:0] objectForKey:@"target_id"]];
			for (int i=1; i<[((NSArray*)result) count]; i++)	
				[fduids appendFormat:@",%@",[[((NSArray*)result) objectAtIndex:i] objectForKey:@"target_id"]];
			self.fduids = fduids;	
			NSLog(fduids);
			[self submitFriendsList];

		}
	}
}


- (void) postMessageToFacebook:(NSString*)inMessageToPost{
/*	
//	BOOL sessionResumed = [fbSession resume];
//	NSLog(@"sessionResumed: %i", sessionResumed);
	if (sessionResumed == NO){
		
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbSession] autorelease];
		[dialog show];
		
		NSLog(@"sess 1");
	}else{
 */
		NSLog(@"sess 0");
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:inMessageToPost, @"attachment",nil];
		[[FBRequest requestWithDelegate:self] call:@"facebook.Stream.publish" params:params];

		/*
		FBStreamDialog* dialog2 = [[[FBStreamDialog alloc] init] autorelease];
		dialog2.delegate = self;
		dialog2.userMessagePrompt = @"iPhone拍拍機 on Facebook";
		dialog2.attachment = inMessageToPost;
//		dialog2.attachment = @"{\"name\":\"Facebook iPhone SDK\",""\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\",""\"caption\":\"Caption\",\"description\":\"Description\",""\"media\":[{\"type\":\"image\",""\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\",""\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}],""\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}";

		// replace this with a friend's UID
		dialog2.targetId = [NSString stringWithFormat:@"%d", fbSession.uid];
		NSLog(@"dialog2.targetId: %@", dialog2.targetId);
		[dialog2 show];
		 */
	
	
}


- (void)statusWasSet:(BOOL)status
{
    //Instantiate the PermissionStatus class with the user id.
    if ( !self.permissionStatusForUser.userHasPermission )
    {
		FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.permission = @"publish_stream";
		[dialog show];
    }
    else
	{
		
	}
}

-(void) dealloc {
	NSLog(@"dealloc FBDataSource");
	self.username = nil;
	self.imageurl = nil;
	self.fduids = nil;
	// avoid being released by URLConnection delegate
	//[super dealloc];
	
}


@end
