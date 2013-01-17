//
//  GraphViewController.h
//  Calculator
//
//  Created by viet on 1/14/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDataSource>

@property (nonatomic, strong) id program;

@property (weak, nonatomic) IBOutlet UILabel *graphName;



@end
