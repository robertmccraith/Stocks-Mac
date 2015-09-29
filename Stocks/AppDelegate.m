//
//  AppDelegate.m
//  Stocks
//
//  Created by Robert McCraith on 27/04/2014.
//  Copyright (c) 2014 Robert McCraith. All rights reserved.
//

#import "AppDelegate.h"
#import "graph.h"
#import "Quotes.h"
@interface AppDelegate()
@property (weak) IBOutlet NSTextField *company;
@property (weak) IBOutlet NSDatePicker *startDate;
@property (weak) IBOutlet NSDatePicker *endDate;

@property (weak) IBOutlet graph *graphView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.endDate setDateValue:[NSDate date]];
    [self.startDate setDateValue:[NSDate dateWithTimeIntervalSinceNow:(-60.0*60*24*365)]];

}
- (IBAction)newStock:(id)sender
{
    [self.graphView setStartDate:[self.startDate dateValue]];
    [self.graphView setEndDate:[self.endDate dateValue]];
    if (![[self.company stringValue] isEqualToString:@""]) {
        [self.graphView setStockName:[NSString stringWithFormat:@"%@", [self.company stringValue]]];
    }
    
    
    
    NSRect rec;
    rec.size.width=100;
    rec.size.height=100;
    rec.origin = CGPointMake(0, 0);
    [self.graphView setNeedsDisplay:YES];

}

@end
