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
#import "CHVFNumPadView.h"

@interface CHVFViewController () {
    CHVFGridView *_gridView;
    CHVFGridModel *_gridModel;
    CHVFNumPadView *_numPadView;
}

@end

@implementation CHVFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float gridFramePortion = 0.8;
    float gridNumPadSpacingPortion = 0.05;
    float numPadFrameHeightPortion = 0.1;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _gridModel = [[CHVFGridModel alloc] init];
    [_gridModel generateGrid];
    
    // Create grid frame
    CGRect frame = self.view.frame;
    CGFloat gridFrameSize = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * gridFramePortion;
    CGFloat gridFrameX = (CGRectGetWidth(frame) - gridFrameSize) / 2; // horizontally center the gridFrame
    CGFloat gridNumPadHeight = gridFrameSize + (gridNumPadSpacingPortion + numPadFrameHeightPortion) * CGRectGetHeight(frame);
    CGFloat gridFrameY = (CGRectGetHeight(frame) - gridNumPadHeight) / 2; // vertically center the gridFrame+numPad
    CGRect gridFrame = CGRectMake(gridFrameX, gridFrameY, gridFrameSize, gridFrameSize);
    
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
    
    // Create number pad frame
    CGFloat numPadFrameX = gridFrameX;
    CGFloat numPadFrameY = gridFrameY + gridFrameSize + (gridNumPadSpacingPortion * CGRectGetHeight(frame));
    CGFloat numPadFrameWidth = gridFrameSize;
    CGFloat numPadFrameHeight = numPadFrameHeightPortion * CGRectGetHeight(frame);
    CGRect numPadFrame = CGRectMake(numPadFrameX, numPadFrameY, numPadFrameWidth, numPadFrameHeight);
    
    _numPadView = [[CHVFNumPadView alloc] initWithFrame:numPadFrame];
    [self.view addSubview:_numPadView];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col {
    // For now, simply display row and col info of the cell selected
    NSLog(@"The button is pressed, with row %@ and col %@", row, col);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end