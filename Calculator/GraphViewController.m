
//
//  GraphViewController.m
//  Calculator
//
//  Created by viet on 1/14/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"


@interface GraphViewController () <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController

@synthesize graphView = _graphView;

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
//    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
//    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGuesture:)]];
    self.graphView.dataSource = self;
}

- (void)setProgram:(id)program
{
    if (!_program) {
        _program = program;
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];    

    self.graphName.text = [CalculatorBrain descriptionOfTopOfStackWithProgram:self.program];
    
    if ([self.graphName.text isEqualToString:@""]) {
        self.graphName.text = @"0";
    }
    
    self.graphName.text = [@"f(x) = " stringByAppendingString:self.graphName.text];
}

- (float)getYScaleValue:(GraphView *)sender
                   withX:(float)x
{
    float y = 0;
    NSDictionary *variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                           [[NSNumber alloc] initWithFloat:x], @"x", nil];
    
    id result = [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
    
    if ([result isKindOfClass:[NSNumber class]]) {
        y = [result floatValue];
    }
    return y;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
