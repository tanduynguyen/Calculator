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


+ (BOOL)isVariable:(NSString *)variable {
    NSSet *definedVariables = [[NSSet alloc] initWithObjects:@"x", @"a", @"b", nil];
    return [definedVariables containsObject:variable];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation {
    NSSet *definedOperations = [[NSSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
    return [definedOperations containsObject:operation];
}

+ (BOOL)isMultiOperandOperation:(NSString *)operation {
    NSSet *definedOperations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/" , nil];
    return [definedOperations containsObject:operation];
}

+ (BOOL)isNoOperandOperation:(NSString *)operation {
    NSSet *definedOperations = [[NSSet alloc] initWithObjects:@"π", nil];
    return [definedOperations containsObject:operation];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    //get all the names of the variables used in a given program (returned as an NSSet of NSString objects)
    
    NSMutableSet *variablesUsedInProgram = [[NSMutableSet alloc] init];
    for (id obj in program) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *variableOrOperation = obj;
            if ([CalculatorBrain isVariable:variableOrOperation]) {
                [variablesUsedInProgram addObject:variableOrOperation];
            }
        }
    }
    return [variablesUsedInProgram copy];
}


+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSString class]]) {
        description = topOfStack;
        if (![self isVariable:description]) {
            if ([self isMultiOperandOperation:description]) {
                NSString *firstOperand = [self descriptionOfTopOfStack:stack];
                NSString *secondOperand = [self descriptionOfTopOfStack:stack];
                if ([description isEqualToString:@"*"] || [description isEqualToString:@"/"]) {
                    description = [NSString stringWithFormat:@"%@ %@ %@",secondOperand, description, firstOperand];
                } else {
                    description = [NSString stringWithFormat:@"(%@ %@ %@)",secondOperand, description, firstOperand];
                }
            } else if ([self isSingleOperandOperation:description]) {
                NSString *operandDescription = [self descriptionOfTopOfStack:stack];
                if ([operandDescription hasPrefix:@"("] && [operandDescription hasSuffix:@")"]) {
                    description = [NSString stringWithFormat:@"%@%@", description, operandDescription];
                } else {
                    description = [NSString stringWithFormat:@"%@(%@)", description, operandDescription];
                }
                
            } else if ([self isNoOperandOperation:description]) {
                description = [NSString stringWithFormat:@"%@",description];
            }
        }
    } else {
        description = [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
    }
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *multiProgramDescription;
    while (stack.count > 0) {
        NSString *description = [CalculatorBrain descriptionOfTopOfStack:stack];
        
        if ([description hasPrefix:@"("] && [description hasSuffix:@")"]) {
            NSInteger charIndex = [description length] - 2;
            if (charIndex > 0) {
                NSRange range = {.location = 1, .length = charIndex};
                description = [description substringWithRange:range];
            }
            
        }
        
        if (multiProgramDescription) {
            multiProgramDescription = [NSString stringWithFormat:@"%@, %@", multiProgramDescription, description];
        } else {
            multiProgramDescription = description;
        }
    }
    

    
    return multiProgramDescription;
}

- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)popAnObjectOutOfProgramStack {
    [self.programStack removeLastObject];
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
    if (operation) {
        [self.programStack addObject:operation];
    }
    return [CalculatorBrain runProgram:self.program];
}

- (void)clearOperandStack {
    [self.programStack removeAllObjects];
}
@end
