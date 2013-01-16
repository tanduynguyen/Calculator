//
//  CalculatorBrain.h
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

- (void)pushOperand:(double)operand;
- (id)performOperation:(NSString *)operation;
- (void)clearOperandStack;
- (void)popAnObjectOutOfProgramStack;


+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSString *) descriptionOfTopOfStackWithProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
