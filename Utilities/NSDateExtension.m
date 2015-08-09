#import "NSDateExtension.h"


@implementation NSString(Extension)

+ (NSString*) WMDHHMMSS:(NSDate*) date
{
	if (date)
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"E MMM dd HH:mm:ss"];
		NSString * result = [formatter stringFromDate:date];
		[formatter release];
		return result;
	}
	else
	{
		return nil;
	}
}

+ (NSString*) YYYYMMDD:(NSDate*) date
{
	if(date)
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		NSString * result = [formatter stringFromDate:date];
		[formatter release];
		return result;
	}
	else
	{
		return nil;
	}

}

+ (NSString*) YYYYMMDDMin:(NSDate*) date
{
	if(date)
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
		NSString * result = [formatter stringFromDate:date];
		[formatter release];
		return result;
	}
	else 
	{
		return nil;
	}
}

+ (NSString*) YYYYMMDDTime:(NSDate*) date
{
	if(date)
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:kCFDateFormatterShortStyle];
		NSString * result = [formatter stringFromDate:date];
		[formatter release];
		return result;
	}
	else 
	{
		return nil;
	}
}

+ (NSString*) timeSince:(NSDate*) date
{
	if(!date)
	{
		return nil;
	}
	NSMutableString * result = [NSMutableString string];
	NSTimeInterval gap = [[NSDate date] timeIntervalSinceDate:date];
	int control = 2;
	int minute = 60;
	int hour = 60*minute;
	int day = 24*hour;
	int week = 7*day;
	int month = 30*day;
	int year = 365*day;
	
	int numYr = gap/year;
	if(numYr > 0)
	{
		[result appendFormat:@"%d year ",numYr];
		gap -= numYr*year;
		control --;
	}
	
	int numMonth = gap/month;
	if(numMonth > 0)
	{
		[result appendFormat:@"%d month ", numMonth];
		gap -= numMonth*month;
		control --;
	}
	
	int numWeek = gap/week;
	if(numWeek > 0 && control > 0)
	{
		[result appendFormat:@"%d week ", numWeek];
		gap -= numWeek*week;
		control --;
	}
	
	int numDay = gap/day;
	if(numDay > 0 && control > 0)
	{
		[result appendFormat:@"%d day ", numDay];
		gap -= numDay*day;
		control --;
	}
	
	int numHr = gap/hour;
	if(numHr > 0 && control > 0)
	{
		[result appendFormat:@"%d hour ", numHr];
		gap -= numHr*hour;
		control --;
	}
	
	int numMin = gap/minute;
	if(numMin > 0 && control > 0)
	{
		[result appendFormat:@"%d minute ", numMin];
		gap -= numMin*minute;
		control --;
	}
	
	int numSec = gap/1;
	if(gap > 0 && control > 0)
	{
		[result appendFormat:@"%d sec ", numSec];
		control --;
	}	
	return result;
}

+ (NSString*) timeSince:(NSDate*) date WithLevel:(int) control
{
	if(!date)
	{
		return nil;
	}
	NSMutableString * result = [NSMutableString string];
	NSTimeInterval gap = [[NSDate date] timeIntervalSinceDate:date];
	int minute = 60;
	int hour = 60*minute;
	int day = 24*hour;
	int week = 7*day;
	int month = 30*day;
	int year = 365*day;
	
	int numYr = gap/year;
	if(numYr > 0)
	{
		[result appendFormat:@"%dyear",numYr];
		gap -= numYr*year;
		control --;
	}
	
	int numMonth = gap/month;
	if(numMonth > 0)
	{
		[result appendFormat:@"%dmonth", numMonth];
		gap -= numMonth*month;
		control --;
	}
	
	int numWeek = gap/week;
	if(numWeek > 0 && control > 0)
	{
		[result appendFormat:@"%dweek", numWeek];
		gap -= numWeek*week;
		control --;
	}
	
	int numDay = gap/day;
	if(numDay > 0 && control > 0)
	{
		[result appendFormat:@"%dday", numDay];
		gap -= numDay*day;
		control --;
	}
	
	int numHr = gap/hour;
	if(numHr > 0 && control > 0)
	{
		[result appendFormat:@"%dhour", numHr];
		gap -= numHr*hour;
		control --;
	}
	
	int numMin = gap/minute;
	if(numMin > 0 && control > 0)
	{
		[result appendFormat:@"%dmin", numMin];
		gap -= numMin*minute;
		control --;
	}
	
	int numSec = gap/1;
	if(gap > 0 && control > 0)
	{
		[result appendFormat:@"%dsec", numSec];
		control --;
	}	
	return result;
}

@end


@implementation NSDate(Extension)
- (void) eliminateMilliseconds
{
	NSTimeInterval interval = [self timeIntervalSince1970];
	double second = interval/1000;
	double millisecond = second*1000;
	self = [NSDate dateWithTimeIntervalSince1970:millisecond];
}

- (void) addNumber:(int) num
{
	NSTimeInterval interval = [self timeIntervalSince1970];
	interval += num;
	self = [NSDate dateWithTimeIntervalSince1970:interval];
}

- (void) eliminateMillisecondsAndAddNumber:(int) num
{
	[self eliminateMilliseconds];
	[self addNumber:num];
}
@end
