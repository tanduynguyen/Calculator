//
//  CalculatorBrain.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *operanStack;

@end

@implementation CalculatorBrain

- (NSMutableArray *)operanStack {
    if (!_operanStack) {
        _operanStack = [[NSMutableArray alloc] init];
    }
    return _operanStack;
}


- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operanStack addObject:operandObject];
}

- (double)popOperand {
    NSNumber *operandObject =[self.operanStack lastObject];
    if (operandObject) [self.operanStack removeLastObject];
    [NSNumber class];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        result = - [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) {
            result = [self popOperand] / divisor;
        }
    }
        
    [self pushOperand:result];
    return result;
}
@end
