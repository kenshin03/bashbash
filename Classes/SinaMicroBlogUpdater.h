//
//  SinaMicroBlogUpdater.h
//  OneMinApp
//
//  Created by Kenny Tang on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"


@interface SinaMicroBlogUpdater : NSObject {
	NSMutableData *responseData;
	BOOL isLogin;
}

- (void) postTweetToSinaMicroBlog:(NSString*)tweetString;
- (NSString*) retrieveProfileFromSinaMicroBlog;

@end
