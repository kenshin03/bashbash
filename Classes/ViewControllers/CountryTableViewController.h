//
//  CountryTableViewController.h
//  bishibashi
//
//  Created by Eric on 11/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountryTableViewController : UITableViewController {
	NSMutableArray* _countries;
	id	_delegate;
}

@property (nonatomic, retain) NSMutableArray* countries;
@property (nonatomic, assign) id delegate;
@end
