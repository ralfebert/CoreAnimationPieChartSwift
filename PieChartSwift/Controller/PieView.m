//
//  PieView.m
//  PieChart
//
//  Created by Pavan Podila on 2/21/12.
//  Copyright (c) 2012 Pixel-in-Gene. All rights reserved.
//

#import "PieView.h"
#import "PieSliceLayer.h"
#import <QuartzCore/QuartzCore.h>

#define DEG2RAD(angle) angle*M_PI/180.0

@interface PieView() {
	NSMutableArray *_normalizedValues;
	CALayer *_containerLayer;
}

-(void)updateSlices;
@end

@implementation PieView
@synthesize sliceValues = _sliceValues;

-(void)doInitialSetup {
	_containerLayer = [CALayer layer];
	[self.layer addSublayer:_containerLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self doInitialSetup];
    }
	
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self doInitialSetup];
	}
	
	return self;
}

-(id)initWithSliceValues:(NSArray *)sliceValues {
	if (self) {
		[self doInitialSetup];
		self.sliceValues = sliceValues;
	}
	
	return self;
}

-(void)setSliceValues:(NSArray *)sliceValues {
	_sliceValues = sliceValues;
	
	_normalizedValues = [NSMutableArray array];
	if (sliceValues) {

		// total
		CGFloat total = 0.0;
		for (NSNumber *num in sliceValues) {
			total += num.floatValue;
		}
		
		// normalize
		for (NSNumber *num in sliceValues) {
			[_normalizedValues addObject:[NSNumber numberWithFloat:num.floatValue/total]];
		}
	}
	
	[self updateSlices];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
	CAShapeLayer *circleLayer = [CAShapeLayer layer];
	
	CGPoint offset = CGPointMake((self.bounds.size.width-150)/2, (self.bounds.size.height-150.0)/2);
	circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset.x, offset.y, 150.0, 150.0)].CGPath;
	circleLayer.fillColor = [UIColor colorWithWhite:0.25 alpha:1.0].CGColor;
	
	[self.layer addSublayer:circleLayer];	

}

-(void)updateSlices {
	
	_containerLayer.frame = self.bounds;
	
	// Adjust number of slices
	if (_normalizedValues.count > _containerLayer.sublayers.count) {
		
		int count = _normalizedValues.count - _containerLayer.sublayers.count;
		for (int i = 0; i < count; i++) {
			PieSliceLayer *slice = [PieSliceLayer layer];
			slice.strokeColor = [UIColor colorWithWhite:0.25 alpha:1.0];
			slice.strokeWidth = 0.5;
			slice.frame = self.bounds;
			
			[_containerLayer addSublayer:slice];
		}
	}
	else if (_normalizedValues.count < _containerLayer.sublayers.count) {
		int count = _containerLayer.sublayers.count - _normalizedValues.count;

		for (int i = 0; i < count; i++) {
			[[_containerLayer.sublayers objectAtIndex:0] removeFromSuperlayer];
		}
	}
	
	// Set the angles on the slices
	CGFloat startAngle = 0.0;
	int index = 0;
	CGFloat count = _normalizedValues.count;
	for (NSNumber *num in _normalizedValues) {
		CGFloat angle = num.floatValue * 2 * M_PI;
		
		NSLog(@"Angle = %f", angle);
		
		PieSliceLayer *slice = [_containerLayer.sublayers objectAtIndex:index];
		slice.fillColor = [UIColor colorWithHue:index/count saturation:0.5 brightness:0.75 alpha:1.0];
		slice.startAngle = startAngle;
		slice.endAngle = startAngle + angle;
		
		startAngle += angle;
		index++;
	}
}

@end
