//
//  GameRecordTVC.h
//  bishibashi
//
//  Created by Eric on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateExtension.h"
#import "GameRecord.h"
#import "TerminalBoardView.h"

@interface GameRecordTVC : UITableViewCell {
	int						_rankNo;
	int						_sectionNo;
	UILabel					*_time;
	UILabel					*_mode;
	
	UIImageView				*_country;
	
	TerminalBoardView			*_terminalView;
}
@property(nonatomic, assign) int rankNo;
@property(nonatomic, assign) int sectionNo;
@property(nonatomic, retain) UILabel* time;
@property(nonatomic, retain) UILabel* mode;
@property(nonatomic, retain) UIImageView* country;
@property(nonatomic, retain) TerminalBoardView* terminalView;
@end