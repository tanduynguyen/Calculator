//
//  CalculatorViewController.h
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@interface CalculatorViewController : RotatableViewController

@property (strong, nonatomic) IBOutlet UILabel *display;
@property (strong, nonatomic) IBOutlet UILabel *stackDisplay;
@property (strong, nonatomic) IBOutlet UILabel *variableDisplay;

@end
