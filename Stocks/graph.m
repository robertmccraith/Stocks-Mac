//
//  graph.m
//  Stocks
//
//  Created by Robert McCraith on 27/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import "graph.h"
#import "Price.h"
#import "Quotes.h"
@interface graph()
@property NSString *name;
@property NSString *currentStock;
@property NSArray *quotes;

@property NSDate *start;
@property NSDate *end;
@property NSDate *curStart;
@property NSDate *curEnd;

@end


@implementation graph

-(void)setStockName:(NSString *)name
{
    self.name = name;
}
-(void)setStartDate:(NSDate *)start
{
    self.start = start;
}
-(void)setEndDate:(NSDate *)endDate
{
    self.end = endDate;
}



- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      //probably put something here at some stage
    }
    self.name = @"aapl";
    self.currentStock = self.name;
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);

    double width = self.bounds.size.width;
    double heigth = self.bounds.size.height;
    
    [[NSColor blackColor] set];
    if([self.quotes count]==0 || !self.quotes || ![self.name isEqualToString:self.currentStock] || ![self.start isEqualToDate:self.curStart] || ![self.end isEqualToDate:self.curEnd]){
        Quotes *q = [[Quotes alloc] init];
        [q setStartDate:self.start];
        [q setEndDate:self.end];
        _quotes = [q getQuotesfor:[NSString stringWithFormat:@"%@",self.name]];
        
        self.currentStock = self.name;
        self.curStart = self.start;
        self.curEnd = self.end;
    }
    
    double max =0;
    double min= [[_quotes objectAtIndex:0] getOpen];
    for (Price *p in _quotes) {
        if ([p getOpen] <min) {
            min = [p getOpen];
        }else if ([p getOpen] >max){
            max = [p getOpen];
        }
    }
    NSLog(@"max = %f, min = %f", max, min);
    max *=1.1;
    min*=0.9;
    double scale = heigth/max;
    double widthscale = width/[_quotes count];
    
    
    Price *localMin =[self.quotes objectAtIndex:0];
    Price *localMax =[self.quotes objectAtIndex:0];
    double maxDiff = 0;
    
    Price *tempMax, *tempMin;
    //get drawDown
    for (int i =(int)[self.quotes count]-1; i>0; i--) {
        
            tempMax = [self.quotes objectAtIndex:i];
            tempMin = tempMax;
            for (int j =i+1; j<[self.quotes count]; j--) {
                if ([tempMin getOpen] > [[self.quotes objectAtIndex:j] getOpen]) {
                    
                    tempMin = [self.quotes objectAtIndex:j];
                     
                    
                }
            }
            if (([tempMax getOpen] - [tempMin getOpen])*100/[tempMax getOpen] > maxDiff) {
                maxDiff = ([tempMax getOpen] - [tempMin getOpen])*100/[tempMax getOpen];
                localMax = tempMax;
                localMin = tempMin;
            }

    }
    NSLog(@"%f, from %@ to %@", maxDiff, [localMax getDate], [localMin getDate]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:12], NSFontAttributeName,[NSColor blackColor], NSForegroundColorAttributeName, nil];
    NSAttributedString *currentText;
    
    
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, [[_quotes objectAtIndex:0] getOpen]*scale)];
    
    int maxI=(int)[self.quotes count];
    int minI=(int)[self.quotes count];
    NSBezierPath *drawdown = [[NSBezierPath alloc] init];
    //draw graph
    for (int i =0; i<[_quotes count]; i++) {
        [path lineToPoint:CGPointMake(i*widthscale, [[_quotes objectAtIndex:[_quotes count]-i-1] getOpen]*scale)];
        
        //max,min cirlces
        if (([[_quotes objectAtIndex:[_quotes count]-i-1] getOpen] == [localMax getOpen] && [[[_quotes objectAtIndex:[_quotes count]-i-1] getDate] isEqualToString:[localMax getDate] ])){
            
            //local max
            NSBezierPath *circle = [[NSBezierPath alloc] init];
            
            [circle appendBezierPathWithArcWithCenter:CGPointMake(i*widthscale, [localMax getOpen]*scale) radius:10 startAngle:0 endAngle:360];
            [[NSColor redColor] set];
            [circle fill];
            [[NSColor blackColor] set];
            
            
            currentText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n %f",[localMax getDate],[localMax getOpen]]  attributes: attributes];
            
            [currentText drawAtPoint:NSMakePoint(i*widthscale-currentText.size.width/2, [localMax getOpen]*scale+20)];
            maxI = i;
            [drawdown moveToPoint:CGPointMake(i*widthscale, [localMax getOpen]*scale)];
            
        }else if ([[_quotes objectAtIndex:[_quotes count]-i-1] getOpen] == [localMin getOpen] && [[[_quotes objectAtIndex:[_quotes count]-i-1] getDate] isEqualToString:[localMin getDate] ]) {
            
            //local min
            NSBezierPath *circle = [[NSBezierPath alloc] init];
            
            [circle appendBezierPathWithArcWithCenter:CGPointMake(i*widthscale, [localMin getOpen]*scale) radius:10 startAngle:0 endAngle:360];
            [[NSColor redColor] set];
            [circle fill];
            [[NSColor blackColor] set];
            
            currentText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n %f",[localMin getDate],[localMin getOpen]]  attributes: attributes];
            int offset =-40;
            [currentText drawAtPoint:NSMakePoint(i*widthscale-currentText.size.width/2, [localMin getOpen]*scale+offset)];
            minI = i;
            [drawdown lineToPoint:CGPointMake(i*widthscale, [localMin getOpen]*scale)];
        }
        
        if (minI > i && i > maxI) {
            int x =i*widthscale;
            int y = [[_quotes objectAtIndex:[_quotes count]-i-1] getOpen]*scale;
            [drawdown lineToPoint:CGPointMake(x, y)];
        }
    }
    [path stroke];
    [drawdown lineToPoint:CGPointMake(maxI*widthscale, [localMin getOpen]*scale)];
    [drawdown closePath];
    [[NSColor blueColor] setFill];
    [drawdown fill];
    
    currentText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.02f %%",maxDiff]  attributes: attributes];

    [currentText drawAtPoint:NSMakePoint((maxI+minI)*widthscale/2-currentText.size.width/2, [localMin getOpen]*scale+30)];
    
    
    NSBezierPath *grid = [[NSBezierPath alloc] init];
    [grid moveToPoint:CGPointMake(0, 0)];
   
    
    //draw horizontal lines
    for (int i =0; i<max; i+=max*0.1) {
        [grid moveToPoint:CGPointMake(0, i*scale)];
        [grid lineToPoint:CGPointMake(width, i*scale)];
        
        
        currentText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",i] attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(10, i*scale)];
    }
    [grid setLineWidth:0.1];
    [grid stroke];
    
    NSBezierPath *time = [[NSBezierPath alloc] init];
    [time moveToPoint:CGPointMake(0, 0)];
    
    //draw vertical lines
    for (int i =0; i< width; i+=width/20) {//20 is number of divisions
        [time moveToPoint:CGPointMake(i, 0)];
        [time lineToPoint:CGPointMake(i, heigth)];
        
        
        int place =[self.quotes count] - 1 - ((int)[self.quotes count]*((double)(i/width)));
        NSString *date = [[self.quotes objectAtIndex:place] getDate];
        
        currentText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",date] attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(i, 10)];
        
    }
    [time setLineWidth:0.1];
    [time stroke];
}

@end
