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
#import "CHVFGridGenerator.h"

@interface CHVFViewController () {
    CHVFGridView *_gridView;
    CHVFGridModel *_gridModel;
    CHVFNumPadView *_numPadView;
}

@end

@implementation CHVFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    
    float gridFramePortion = 0.8;
    float gridNumPadSpacingPortion = 0.05;
    float numPadFrameHeightPortion = 0.1;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _gridModel = [[CHVFGridModel alloc] init];
    [_gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName
        delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    
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
            BOOL isMutable = (value == 0); // 0 means empty
            [_gridView setMutableAtRow:row column:col to:isMutable];
            [_gridView setValueAtRow:row column:col to:value];
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
    int rowInt = [row intValue];
    int colInt = [col intValue];
    if (![_gridModel isMutableAtRow:rowInt column:colInt]) {
        return;
    }
    
    int currentValue = [_numPadView getCurrentValue];
    if (![_gridModel isConsistentAtRow:rowInt column:colInt for:currentValue]) {
        return;
    }
    
    [_gridView setValueAtRow:rowInt column:colInt to:currentValue];
    [_gridModel setValueAtRow:rowInt column:colInt to:currentValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end