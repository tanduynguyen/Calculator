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
@property (nonatomic, strong) NSDictionary *variableValues;
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

- (NSDictionary *)variableValues {
    if (!_variableValues) {
        _variableValues = [[NSDictionary alloc] init];
    }
    return _variableValues;
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
            if ([self.display.text hasSuffix:@"."]) {
                self.alreadyDot = NO;
            }
            
            NSUInteger index = self.display.text.length;

            self.display.text = [self.display.text substringToIndex:index - 1];

        } else {
            self.display.text = @"0";
        }
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {    
    NSString *operation = [sender currentTitle];    
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    //Add operation to stackDisplay after the current text
//    self.stackTest = [NSString stringWithFormat:@"%@ %@", self.stackTest, operation];
    
    
    

    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.stackTest = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.stackTest];
}

- (IBAction)testPressed {
    self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [[NSNumber alloc] initWithDouble:3], @"a",
                                    [[NSNumber alloc] initWithDouble:-4], @"x", nil];
    
    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.variableValues]];
    
    NSMutableString *variableValueDescription = [[NSMutableString alloc] initWithString:@""];
    for (id key in self.variableValues) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *variableName = key;
            NSNumber *variableValue = [self.variableValues objectForKey:key];
            [variableValueDescription appendFormat:@"%@ = %@  ", variableName, variableValue];
        }
    }
    self.variableDisplay.text = variableValueDescription;
}

- (IBAction)signPressed {
//    self.display.text = [NSString stringWithFormat:@"%g",[self.display.text doubleValue] * -1];
    if (![self.display.text hasPrefix:@"-"]) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    } else {
        self.display.text = [self.display.text substringFromIndex:1];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.alreadyDot = NO;
    
    //Add operand to stackDisplay
//    self.stackTest = [NSString stringWithFormat:@"%@ %@", self.stackTest, self.display.text];
    self.stackTest = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.stackTest];
}
- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self backspacePressed];
        if ([self.display.text isEqualToString:@"0"]) {
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        [self.brain popAnObjectOutOfProgramStack];
        [self operationPressed:nil];
    }
}

@end
