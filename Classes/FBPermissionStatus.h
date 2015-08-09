//
//  FBPermissionStatus.h
//  FBModule
//
//  Created by Eric on 01/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRequest.h"

@protocol FBPermissionStatusDelegate;

@interface FBPermissionStatus : NSObject <FBRequestDelegate> {
	BOOL userHasPermission;
	id<FBPermissionStatusDelegate> delegate;
}

@property (nonatomic, assign) BOOL userHasPermission;
@property (nonatomic, retain) id<FBPermissionStatusDelegate> delegate;

- (FBPermissionStatus *)initWithUserId:(long long int)uid;

@end

#pragma mark method to call after response
@protocol FBPermissionStatusDelegate <NSObject>
- (void)statusWasSet:(BOOL)status;
@end