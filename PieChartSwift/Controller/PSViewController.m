//
//  PSViewController.m
//  PieChart
//
//  Created by Pavan Podila on 2/26/12.
//  Copyright (c) 2012 Pixel-in-Gene. All rights reserved.
//

#import "PSViewController.h"

@implementation PSViewController
@synthesize pieView;

- (IBAction)animatePieSlices:(id)sender {
	NSMutableArray *randomNumbers = [NSMutableArray array];
	int count = 1 + rand() % 10;
	for (int i = 0; i < count; i++) {
		[randomNumbers addObject:[NSNumber numberWithInt:rand() % 100]];
	}
	
	pieView.sliceValues = randomNumbers;
}

@end
