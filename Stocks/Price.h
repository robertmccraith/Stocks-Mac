//
//  Price.h
//  Stocks
//
//  Created by Robert McCraith on 28/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Price : NSObject


-(id)initwithdate:(NSString *)date andOpen:(double)open;
-(NSString *)getDate;
-(double)getOpen;

@end
