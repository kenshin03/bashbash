//
//  FBDataSource.h
//  Spectrums
//
//  Created by kenny on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBPermissionStatus.h"
#import "Constants.h"
#import "LocalStorageManager.h"

@protocol FBDataSourceDelegate
- (void) FBLoginedWithUserName:(NSString*)username AndImageUrl:(NSString*) imageurl AndUid:(NSString*) uid;
@end

@interface FBDataSource : NSObject <FBSessionDelegate, FBRequestDelegate, FBDialogDelegate>{
	NSMutableArray *facebookFriendsImagesArray;
	NSString *responseString;
	FBSession *_fbSession;
	NSString *messageToPost;
	id delegate;
	
	NSString* _username;
	NSString*	_fduids;
	NSString*	_imageurl;
	FBPermissionStatus* _permissionStatusForUser;
}

@property (nonatomic, retain) NSString*	fduids;
@property (nonatomic, retain) FBSession	*fbSession;
@property (nonatomic, retain) id			    delegate;
@property (nonatomic, retain) NSString *messageToPost;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* imageurl;
@property (nonatomic, retain) FBPermissionStatus* permissionStatusForUser;

+ (id)sharedInstance;
- (void) postMessageToFacebook:(NSString*)inMessageToPost;
- (void) logoutFacebook;
- (void) loginFacebook;

@end
