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
    
    float gridFramePortion = 0.8;
    float gridNumPadSpacingPortion = 0.05;
    float numPadFrameHeightPortion = 0.1;
    DifficultyLevel defaultDifficultyLevel = DifficultyLevelMedium;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _gridModel = [[CHVFGridModel alloc] init];
    
    // Create grid frame
    CGRect frame = self.view.frame;
    CGFloat gridFrameSize = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * gridFramePortion;
    CGFloat gridFrameX = (CGRectGetWidth(frame) - gridFrameSize) / 2; // horizontally center the gridFrame
    CGFloat gridNumPadHeight = gridFrameSize + (gridNumPadSpacingPortion + numPadFrameHeightPortion) * CGRectGetHeight(frame);
    CGFloat gridFrameY = (CGRectGetHeight(frame) - gridNumPadHeight) / 2; // vertically center the gridFrame+numPad
    CGRect gridFrame = CGRectMake(gridFrameX, gridFrameY, gridFrameSize, gridFrameSize);
    
    // Initialize _gridView and set initial values from _gridModel
    _gridView = [[CHVFGridView alloc] initWithFrame:gridFrame];

    [self.view addSubview:_gridView];
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
    
    // Create number pad frame
    CGFloat numPadFrameX = gridFrameX;
    CGFloat numPadFrameY = gridFrameY + gridFrameSize + (gridNumPadSpacingPortion * CGRectGetHeight(frame));
    CGFloat numPadFrameWidth = gridFrameSize;
    CGFloat numPadFrameHeight = numPadFrameHeightPortion * CGRectGetHeight(frame);
    CGRect numPadFrame = CGRectMake(numPadFrameX, numPadFrameY, numPadFrameWidth, numPadFrameHeight);
    
    _numPadView = [[CHVFNumPadView alloc] initWithFrame:numPadFrame];
    [_numPadView setTarget:self action:@selector(updateGridHighlighting)];
    [self.view addSubview:_numPadView];
    
    [self startGameForDifficulty:defaultDifficultyLevel];
}

- (void)startGameForDifficulty:(DifficultyLevel)difficultyLevel {
    _difficultyLevel = difficultyLevel;
    
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    [_gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName
        delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = [_gridModel getValueAtRow:row column:col];
            BOOL isMutable = (value == 0); // 0 means empty
            [_gridView setMutableAtRow:row column:col to:isMutable];
            [_gridView setValueAtRow:row column:col to:value];
        }
    }
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
    [self updateGridHighlighting];
}

- (void)updateGridHighlighting {
    int currentNumPadValue = [_numPadView getCurrentValue];
    if (_difficultyLevel == DifficultyLevelEasy) {
        // Highlight all valid grid cells for current value of num pad
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                int cellValue = [_gridModel getValueAtRow:row column:col];
                BOOL isConsistent = [_gridModel isConsistentAtRow:row column:col for:currentNumPadValue];
                BOOL isMutable = [_gridModel isMutableAtRow:row column:col];
                if (isConsistent && isMutable && (currentNumPadValue != cellValue) && (currentNumPadValue != 0)) {
                    [_gridView setHintStateAtRow:row column:col to:HintStateValid];
                } else {
                    [_gridView setHintStateAtRow:row column:col to:HintStateNeutral];
                }
            }
        }
    } else if (_difficultyLevel == DifficultyLevelMedium) {
        // Highlight all grid cells that contain the current value of num pad
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                int cellValue = [_gridModel getValueAtRow:row column:col];
                if ((cellValue == currentNumPadValue) && (currentNumPadValue != 0)) {
                    [_gridView setHintStateAtRow:row column:col to:HintStateInvalid];
                } else {
                    [_gridView setHintStateAtRow:row column:col to:HintStateNeutral];
                }
            }
        }
    } else if (_difficultyLevel == DifficultyLevelHard) {
        // Do nothing
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end