//
//  GraphView.m
//  Calculator
//
//  Created by viet on 1/15/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "GraphView.h"

#define DEFAULT_SCALE 10

@interface GraphView()

@property (nonatomic) float scale;
@property (nonatomic) CGPoint origin;

@end

@implementation GraphView

@synthesize scale = _scale;

- (void)setScale:(float)scale {    
    _scale = scale;
    
    [self setNeedsDisplay];
}


- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    
    [self setNeedsDisplay];
}


- (float)scale
{
    if (!_scale) {
        _scale = DEFAULT_SCALE;
    } else if (_scale < 0) {
        _scale = 0;
    } else if (_scale > 100) {
        _scale = 100;
    }
    return _scale;
}

- (void) awakeFromNib
{    
   self.origin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
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
    float x = - 1 * self.origin.x;
    float y = [self.dataSource getYScaleValue:self withX:x / self.scale];    
    
    //automatic scale the graph
    if (self.scale == DEFAULT_SCALE) {
        if (abs(y) > (self.frame.size.height / (2.0 * self.scale))) {
            self.scale = self.frame.size.height / (2.0 * abs(y));
        }        
    }
    
    y = [self.dataSource getYScaleValue:self withX:x / self.scale];
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
        
    CGRect myRect;
    myRect.size.height = self.frame.size.height;
    myRect.size.width = self.frame.size.width;
    
    [AxesDrawer drawAxesInRect:myRect originAtPoint:self.origin scale:self.scale];
    
    CGContextSetLineWidth(context, 2);
    [[UIColor redColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);    
    
    CGContextMoveToPoint(context, self.origin.x + x, self.origin.y - y * self.scale);
    
    for (float i = 0; x < myRect.size.width - self.origin.x; x++, i++)
    {
        y = [self.dataSource getYScaleValue:self withX:x / self.scale];
        CGContextAddLineToPoint(context, self.origin.x + x, self.origin.y - y * self.scale);
            
       // CGContextFillRect(context, CGRectMake(midPoint.x + x, midPoint.y - y * self.scale, 2, 2));        

    }
    
    CGContextStrokePath(context);
}

- (void)tappingGraph:(id)sender {
    if ([sender isMemberOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *gesture = sender;
        self.origin = [gesture locationInView:self];
    }
}

- (void)panningGraph:(id)sender {
    if ([sender isMemberOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *gesture = sender;
        
        CGPoint translation = [gesture translationInView:self];
        [gesture setTranslation:CGPointZero inView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
    }
}

- (void)pinchingGraph:(id)sender {
    if ([sender isMemberOfClass:[UIPinchGestureRecognizer class]])
    {
        UIPinchGestureRecognizer *gesture = sender;        
        self.scale *= gesture.scale;
    }
}

@end
