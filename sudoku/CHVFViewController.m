//
//  CHVFViewController.m
//  sudoku
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFViewController.h"
#import "CHVFGridView.h"
#import "CHVFGridModel.h"

@interface CHVFViewController () {
    CHVFGridView *_gridView;
    CHVFGridModel *_gridModel;
}

@end

@implementation CHVFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _gridModel = [[CHVFGridModel alloc] init];
    [_gridModel generateGrid];
    
    // Create grid frame
    CGRect frame = self.view.frame;
    float framePortion = 0.8;
    CGFloat x = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat y = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    // Initialize _gridView and set initial values from _gridModel
    _gridView = [[CHVFGridView alloc] initWithFrame:gridFrame];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = [_gridModel getValueAtRow:row column:col];
            [_gridView setValueAtRow:row col:col to:value];
        }
    }
    [self.view addSubview:_gridView];
    
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col
{
    // For now, simply display row and col info of the cell selected
    NSLog(@"The button is pressed, with row %@ and col %@", row, col);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end