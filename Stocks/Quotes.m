    //
//  Quotes.m
//  Stocks
//
//  Created by Robert McCraith on 28/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import "Quotes.h"
#import "Price.h"
@interface Quotes()
@property (strong) NSArray *quotes;
@property (strong) NSDate *start;
@property (strong) NSDate *end;
@end
@implementation Quotes

-(void)setStartDate:(NSDate *)start
{
    self.start = start;
}
-(void)setEndDate:(NSDate *)end
{
    self.end = end;
}
-(NSArray *)getQuotesfor:(NSString *)company
{
    NSArray *quotes;
    if (!_start) {
        self.end = [NSDate date];
        NSTimeInterval year = -60*60*24*365.0;
        self.start= [NSDate dateWithTimeIntervalSinceNow:year];
    }
    NSDateComponents *startDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.start];
    int startDay = (int)[startDate day];
    int startMonth = (int)[startDate month]-1;
    int startYear = (int)[startDate year];
    
    NSDateComponents *endDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.end];
    int endDay = (int)[endDate day];
    int endMonth = (int)[endDate month]-1;
    int endYear = (int)[endDate year];
    
  
	//NSString * abc =[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/table.csv? s=aapl&d=4&e=30&f=2014&g=d&a=4&b=31&c=2013&ignore=.csv!"];
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/table.csv?s=%@&d=%d&e=%d&f=%d&g=d&a=%d&b=%d&c=%d&ignore=.csv",company,endMonth,endDay, endYear, startMonth, startDay, startYear]]];
    
    NSString *downloads = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    quotes = [downloads componentsSeparatedByString:@"\n"];
    //quotes = [quotes reverseObjectEnumerator];
    
    NSMutableArray *qarray = [[NSMutableArray alloc] init];
    
    for (int i =1; i<[quotes count];i++){
        NSArray * arr =[[quotes objectAtIndex:i] componentsSeparatedByString:@","] ;
        if ([arr count] ==1) {
            break;
        }
        NSString *date = [NSString stringWithFormat:@"%@",[[[quotes objectAtIndex:i] componentsSeparatedByString:@","] firstObject]];
        double open =[[NSString stringWithFormat:@"%@",[[[quotes objectAtIndex:i] componentsSeparatedByString:@","] lastObject]] doubleValue];
        Price *myPrice = [[Price alloc] initwithdate:date andOpen:open];
        [qarray addObject:myPrice];
    }

    return qarray;
}

@end
