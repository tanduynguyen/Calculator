//
//  GraphViewController.h
//  Calculator
//
//  Created by viet on 1/14/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "RotatableViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : RotatableViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic, strong) id program;

@property (weak, nonatomic) IBOutlet UILabel *graphName;

@end
