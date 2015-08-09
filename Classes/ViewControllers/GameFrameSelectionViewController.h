//
//  GameFrameSelectonController.h
//  bishibashi
//
//  Created by Eric on 23/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameFrameSelectionViewController : UITableViewController {
	NSMutableArray* _frames;
	id	_delegate;
}

@property (nonatomic, retain) NSMutableArray* frames;
@property (nonatomic, assign) id delegate;
@end
