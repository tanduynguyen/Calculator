//
//  GraphView.m
//  Calculator
//
//  Created by viet on 1/15/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "GraphView.h"

#define DEFAULT_SCALE 10

@implementation GraphView

@synthesize scale = _scale;

- (void)setScale:(float)scale {    
    if (scale < 0) {
        scale = 0;
    } else  if (scale > 100) {
        scale = 100;
    }
    _scale = scale;
    [self setNeedsDisplay];
}

- (float)scale
{
    if (!_scale) {
        _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
   
    
    CGRect myRect;
    myRect.size.height = self.frame.size.height;
    myRect.size.width = self.frame.size.width;
    
    [AxesDrawer drawAxesInRect:myRect originAtPoint:midPoint scale:self.scale];
    
    CGContextSetLineWidth(context, 10);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);

    
    for (float x = -1 * midPoint.x; x < myRect.size.width - midPoint.x; x++)
    {
        float y = [self.dataSource getYScaleValue:self withX:x / self.scale];
        
        CGContextFillRect(context, CGRectMake(midPoint.x + x, midPoint.y - y * self.scale, 2, 2));
        

//    float xScale = x * (myRect.origin.x - self.bounds.origin.x)/SCALE;
//    float yScale = [self.dataSource getYScaleValue:self withX:xScale];
//    
//    CGContextMoveToPoint(context, xScale, yScale);
//    
//    xScale += myRect.size.width;
//    yScale = [self.dataSource getYScaleValue:self withX:xScale];
//    
//    CGContextAddLineToPoint(context, xScale, yScale);
    }
    
    CGContextStrokePath(context);
}

@end
