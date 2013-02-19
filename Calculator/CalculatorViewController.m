//
//  CalculatorViewController.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL alreadyDot;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSString *programStackDescription;
@property (nonatomic, strong) NSDictionary *variableValues;
@end

@implementation CalculatorViewController

- (GraphViewController *)splitViewGraphViewController
{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if (![hvc isKindOfClass:[GraphViewController class]]) {
        hvc = nil;
    }
    return hvc;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self splitViewGraphViewController]) return YES;
    else {
        // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)awakeFromNib {
    self.userIsInTheMiddleOfEnteringANumber = YES;
    
//    typedef double (^unary_operation_t)(double op);
    
//    unary_operation_t square;
//    square = ^(double operand) { // the value of the square variable is a block
//        return operand * operand;
//    };
    
//    double (^square)(double op) = ^(double op) { return op * op; };
//    
//    double squareOfFive = square(square(5.0));
//    
//    NSLog([NSString stringWithFormat:@"%g", squareOfFive]);

}


- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (NSString *)programStackDescription {
    if (!_programStackDescription) {
        _programStackDescription = [[NSString alloc] init];

    }
    return _programStackDescription;
}

- (NSDictionary *)variableValues {
    if (!_variableValues) {
        _variableValues = [[NSDictionary alloc] init];
    }
    return _variableValues;
}

- (IBAction)graphPressed {
    if ([self splitViewGraphViewController]) {
      [self splitViewGraphViewController].program = self.brain.program;
    } else {
      [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(GraphViewController *)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
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
    self.programStackDescription = @"";
    self.variableDisplay.text = @"";
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
    
    
    id result = [self.brain performOperation:operation];

    if ([result isKindOfClass:[NSString class]]) {
        self.variableDisplay.text = [NSString stringWithFormat:@"%@", result];
    } else if ([result isKindOfClass:[NSNumber class]]) {
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
    }
    
    self.programStackDescription = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.programStackDescription];
}

- (IBAction)testPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Test 1"]) {
        self.variableValues = @{@"a": @3.0,
                               @"b": @0.0,
                               @"x": @-4.0};
    } else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
        self.variableValues = @{@"a": @1.0,
                               @"b": @5.0,
                               @"x": @10.0};
    }
    
    
    id result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.variableValues];
    if ([result isKindOfClass:[NSString class]]) {
        self.variableDisplay.text = [NSString stringWithFormat:@"%@", result];
    } else if ([result isKindOfClass:[NSNumber class]]) {
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
    }
    
    NSMutableString *variableValueDescription = [[NSMutableString alloc] initWithString:@""];
    for (id key in self.variableValues) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *variableName = key;
            NSNumber *variableValue = (self.variableValues)[key];
            [variableValueDescription appendFormat:@"%@ = %@  ", variableName, variableValue];
        }
    }
    self.variableDisplay.text = variableValueDescription;
}


- (IBAction)signPressed {
//    self.display.text = [NSString stringWithFormat:@"%g",[self.display.text doubleValue] * -1];
    if ([self.display.text isEqualToString:@"0"])
        return;
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
    self.programStackDescription = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.stackDisplay.text = [NSString stringWithFormat:@"%@ =", self.programStackDescription];
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
