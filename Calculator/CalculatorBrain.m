//
//  CalculatorBrain.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}


- (id)program
{
    return [self.programStack copy];
}


+ (double)runProgram:(id)program {    
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    //get all the names of the variables used in a given program (returned as an NSSet of NSString objects)
    if ([program isKindOfClass:[NSArray class]]) {        
      //  return [[NSSet alloc] initWithObjects:@"a", @"b", @"x", nil];
        
    }
    return nil;
}

+ (NSString *)decriptionOfProgram:(id)program {
    return @"";
}

- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
                usingVariableValues:(NSDictionary *)variableValues {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] +
            [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] *
            [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else {
            //NSDictionary
            NSNumber *value = [variableValues valueForKey:operation];
            if (value) {
                result = [value doubleValue];
            }
        }

    }
    
    return result;
}


- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (void)clearOperandStack {
    [self.programStack removeAllObjects];
}
@end
