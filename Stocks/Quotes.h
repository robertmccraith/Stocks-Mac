//
//  Quotes.h
//  Stocks
//
//  Created by Robert McCraith on 28/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quotes : NSObject
-(NSArray *)getQuotesfor:(NSString *)company;
-(void)setStartDate:(NSDate *)start;
-(void)setEndDate:(NSDate *)end;
@end
