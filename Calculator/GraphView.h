//
//  GraphView.h
//  Calculator
//
//  Created by viet on 1/15/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphView;

@protocol GraphViewDataSource <NSObject>

@property (nonatomic) double xVal;

- (float)getYScaleValue:(GraphView *)sender withX:(float)x;

@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property float scale;

@end
