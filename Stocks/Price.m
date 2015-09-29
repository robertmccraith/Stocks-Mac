//
//  Price.m
//  Stocks
//
//  Created by Robert McCraith on 28/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import "Price.h"

@interface Price()

@property NSString *date;
@property double open;

@end

@implementation Price


-(id)initwithdate:(NSString *)date andOpen:(double)open
{
    self.date = date;
    self.open = open;
    return  self;
}

-(NSString *)getDate
{
    return self.date;
}
-(double)getOpen
{
    return  self.open;
}
@end
