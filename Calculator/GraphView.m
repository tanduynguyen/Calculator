//
//  GraphView.m
//  Calculator
//
//  Created by viet on 1/15/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "GraphView.h"

#define SCALE 10

@implementation GraphView

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
    
    [AxesDrawer drawAxesInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) originAtPoint:midPoint scale:SCALE];
    
    CGContextSetLineWidth(context, 10);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);

    
    for (float x = -1 * self.bounds.origin.x; x < myRect.size.width - self.bounds.origin.x; x++)
    {
        float y = [self.dataSource getYScaleValue:self withX:x / self.scale];
        
        CGContextFillRect(context, CGRectMake(self.bounds.origin.x + x, self.bounds.origin.y - y * self.scale, 2, 2));
        

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
