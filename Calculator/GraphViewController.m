
//
//  GraphViewController.m
//  Calculator
//
//  Created by viet on 1/14/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "SplitViewBarButtonItemPresenter.h"


@interface GraphViewController ()

@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@end

@implementation GraphViewController

@synthesize graphView = _graphView;


//- (void)setSplitBarButtonItem:(UIBarButtonItem *)splitBarButtonItem
//{
//    if (_splitBarButtonItem != splitBarButtonItem) {
//        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
//        if (_splitBarButtonItem) [toolbarItems removeObject:_splitBarButtonItem];
//        if (splitBarButtonItem) [toolbarItems insertObject:splitBarButtonItem atIndex:0];
//        self.toolbar.items = toolbarItems;
//        _splitBarButtonItem = splitBarButtonItem;
//    }
//}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;    
    
    self.graphView.dataSource = self;   

    // Triple-tapping (moves the origin of the graph to the point of the triple-tap)
    UITapGestureRecognizer *tapGestureRegnizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tappingGraph:)];
    tapGestureRegnizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGestureRegnizer];
    
    // Panning (moves the entire graph, including axes, to follow the touch around)
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(panningGraph:)]];
    
    // Pinching (adjusts your view’s scale)
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinchingGraph:)]];
      
    [self.graphView setNeedsDisplay];
}

- (void)setProgram:(id)program
{
    if (!_program) {
        _program = program;
        [self.graphView setNeedsDisplay];
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    if ([self.program count] > 0)
    {
        self.title = [NSString stringWithFormat:@"f(x) = %@",[CalculatorBrain descriptionOfTopOfProgram:self.program]];    
    }    
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
