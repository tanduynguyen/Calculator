//
//  CalculatorBrain.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *unaryOperations;

@end

@implementation CalculatorBrain

typedef double (^unary_operation_t)(double op);

- (void)addUnaryOperation:(NSString *)op whichExecutesBlock:(unary_operation_t)opBlock {
    [self.unaryOperations setObject:opBlock forKey:op];    
}


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


+ (id)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    
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

+ (NSString *)descriptionOfAStack:(NSMutableArray *)stack
{
    NSString *description = [self descriptionOfTopOfStack:stack];    
    
    if ([description hasPrefix:@"("] && [description hasSuffix:@")"]) {
        NSInteger charIndex = [description length] - 2;
        if (charIndex > 0) {
            NSRange range = {.location = 1, .length = charIndex};
            description = [description substringWithRange:range];
        }
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
        NSString *description = [self descriptionOfAStack:stack];
        
        if (multiProgramDescription) {
            multiProgramDescription = [NSString stringWithFormat:@"%@, %@", multiProgramDescription, description];
        } else {
            multiProgramDescription = description;
        }        
        
    }

    return multiProgramDescription;
}

+ (NSString *) descriptionOfTopOfProgram:(id)program {
    return [self descriptionOfAStack:[program mutableCopy]];
}

- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)popAnObjectOutOfProgramStack {
    [self.programStack removeLastObject];
}


+ (id)popOperandOffProgramStack:(NSMutableArray *)stack
                usingVariableValues:(NSDictionary *)variableValues {
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        return topOfStack;
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            id firstOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            id secondOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([firstOperand isKindOfClass:[NSString class]]) {
                return firstOperand;
            } else if ([secondOperand isKindOfClass:[NSString class]]) {
                return secondOperand;
            }else {
                return [NSNumber numberWithDouble:([firstOperand doubleValue] + [secondOperand doubleValue])];
            }
            
        } else if ([@"*" isEqualToString:operation]) {
            id firstOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            id secondOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([firstOperand isKindOfClass:[NSString class]]) {
                return firstOperand;
            } else if ([secondOperand isKindOfClass:[NSString class]]) {
                return secondOperand;
            }else {
                return [NSNumber numberWithDouble:([firstOperand doubleValue] * [secondOperand doubleValue])];
            }
        } else if ([operation isEqualToString:@"-"]) {
            id firstOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            id secondOperand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([firstOperand isKindOfClass:[NSString class]]) {
                return firstOperand;
            } else if ([secondOperand isKindOfClass:[NSString class]]) {
                return secondOperand;
            }else {
                return [NSNumber numberWithDouble:([secondOperand doubleValue] - [firstOperand doubleValue])];
            }
        } else if ([operation isEqualToString:@"/"]) {
            id divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            id operand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([divisor isKindOfClass:[NSString class]]) {
                return divisor;
            } else if ([operand isKindOfClass:[NSString class]]) {
                return operand;
            } else {
                if ([divisor doubleValue] == 0) {
                    return @"divide by zero";
                }
                else {
                    return [NSNumber numberWithDouble:([operand doubleValue] / [divisor doubleValue])];
                }
                
            }
        } else if ([operation isEqualToString:@"sin"]) {
            id operand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([operand isKindOfClass:[NSString class]]) {
                return operand;
            } else {
                return [NSNumber numberWithDouble:sin([operand doubleValue])];
            }
           
        } else if ([operation isEqualToString:@"cos"]) {
            id operand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([operand isKindOfClass:[NSString class]]) {
                return operand;
            } else {
                return [NSNumber numberWithDouble:cos([operand doubleValue])];
            }
        } else if ([operation isEqualToString:@"sqrt"]) {
            id operand = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if ([operand isKindOfClass:[NSString class]]) {
                return operand;
            } else {
                if ([operand doubleValue] >= 0) {
                    return [NSNumber numberWithDouble:sqrt([operand doubleValue])];
                } else {
                    return @"square root of a negative number";
                }
            }
 
        } else if ([operation isEqualToString:@"π"]) {
            return [NSNumber numberWithDouble:M_PI];
        } else {
            //NSDictionary
            NSNumber *value = [variableValues valueForKey:operation];
            if (value) {
                return value;
            }
        }

    }
    return nil;
}


- (id)performOperation:(NSString *)operation {    
    if (operation) {
        [self.programStack addObject:operation];
    }
    return [CalculatorBrain runProgram:self.program];
}

- (void)clearOperandStack {
    [self.programStack removeAllObjects];
}
@end
