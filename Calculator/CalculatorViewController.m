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
@property (nonatomic, strong) NSString *stackTest;
@end

@implementation CalculatorViewController

- (void)awakeFromNib {
    self.userIsInTheMiddleOfEnteringANumber = YES;
}


//- (id)initWithNibName:(NSString *)nibNameOrNilString bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNilString bundle:nibBundleOrNil];
//    
//    if (self) {
//
//    }
//    
//    return self;
//}

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (NSString *)stackTest {
    if (!_stackTest) {
        _stackTest = [[NSString alloc] init];
    }
    return _stackTest;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *pressedDigit = sender.currentTitle;
    // Replace default display @"0" with an initial digit (not dot sign)
    if ([self.display.text isEqualToString:@"0"]) {
        if (![pressedDigit isEqualToString:@"."]) {
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    
    // For not appending another dot @"."
    if ([pressedDigit isEqualToString:@"."] && self.alreadyDot){
        return;
    }

    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        if (!self.alreadyDot || ![pressedDigit isEqualToString:@"."]) {
            self.display.text = [self.display.text stringByAppendingString:pressedDigit];
            if ([pressedDigit isEqualToString:@"."]) {
                self.alreadyDot = YES;
            }
        }
    } else {
        // For not replacing @"0" with @"."
        if (![pressedDigit isEqualToString:@"."]) {
            self.display.text = pressedDigit;
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.stackDisplay.text = @"";
    self.stackTest = @"";
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.alreadyDot = NO;
    [self.brain clearOperandStack];
}

- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {        
        if (self.display.text.length  > 1) {
            NSUInteger index = self.display.text.length;
            
//          tanduy implement 2nd method to remove dot at the end
 //           if ([(NSString *)[self.display.text characterAtIndex:index] isEqualToString:[@"." ]]) {
//                self
 //           }

            self.display.text = [self.display.text substringToIndex:index - 1];
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location == NSNotFound) {
                self.alreadyDot = NO;
            }
        } else {
            self.display.text = @"0";
        }
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    //Add operation to stackDisplay after the current text
    self.stackTest = [NSString stringWithFormat:@"%@ %@", self.stackTest, sender.currentTitle];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.stackTest];
     
    NSString *operation = [sender currentTitle];

    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}


- (IBAction)signPressed {
//    if ([self.display.text doubleValue] > 0) {
//        self.display.text = [@"-" stringByAppendingString:self.display.text];
//    }
    self.display.text = [NSString stringWithFormat:@"%g",[self.display.text doubleValue] * -1];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.alreadyDot = NO;
    
    //Add operand to stackDisplay
    self.stackTest = [NSString stringWithFormat:@"%@ %@", self.stackTest, self.display.text];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.stackTest];
}

@end
