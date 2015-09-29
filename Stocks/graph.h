//
//  graph.h
//  Stocks
//
//  Created by Robert McCraith on 27/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface graph : NSView
-(void)setStockName:(NSString *)name;
-(void)setStartDate:(NSDate *)start;
-(void)setEndDate:(NSDate *)endDate;
@end
