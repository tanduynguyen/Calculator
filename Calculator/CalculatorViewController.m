//
//  CalculatorViewController.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL alreadyDot;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;    
    if ([self.display.text isEqualToString:@"0"]) {
        
        if ([digit isEqualToString:@"0"]) {
            self.alreadyDot = NO;
            self.userIsInTheMiddleOfEnteringANumber = YES;
            return;
        } else if ([digit isEqualToString:@"."]){
            self.userIsInTheMiddleOfEnteringANumber = YES;
        } else {
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }     
    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        if (!self.alreadyDot || ![digit isEqualToString:@"."]) {
            self.display.text = [self.display.text stringByAppendingString:digit];
            if ([digit isEqualToString:@"."]) {
                self.alreadyDot = YES;
            }
            
        }
    }
    else
    {
        if (![digit isEqualToString:@"."]) {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    
    NSString *operation = [sender currentTitle];

    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}


- (IBAction)signPressed {
    if ([self.display.text doubleValue] > 0) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.alreadyDot = NO;
}

@end
