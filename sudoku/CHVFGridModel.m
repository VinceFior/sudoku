//
//  CHVFGridModel.m
//  sudoku
//
//  Created by Megan Shao on 9/20/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFGridModel.h"

@implementation CHVFGridModel {
    int _cells[9][9];
    BOOL _isMutable[9][9];
}

- (void)generateGrid {
    // For now, the grid is hardcoded
    int grid[9][9]={
        {7,0,0,4,2,0,0,0,9},
        {0,0,9,5,0,0,0,0,4},
        {0,2,0,6,9,0,5,0,0},
        {6,5,0,0,0,0,4,3,0},
        {0,8,0,0,0,6,0,0,7},
        {0,1,0,0,4,5,6,0,0},
        {0,0,0,8,6,0,0,0,2},
        {3,4,0,9,0,0,1,0,0},
        {8,0,0,3,0,2,7,4,0}
    };
    
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = grid[row][col];
            _cells[row][col] = value;
            if (value == 0) {
                _isMutable[row][col] = YES;
            } else {
                _isMutable[row][col] = NO;
            }
        }
    }
}

- (int)getValueAtRow:(int)row column:(int)column {
    return _cells[row][column];
}

- (void)setValueAtRow:(int)row column:(int)column to:(int)value {
    _cells[row][column] = value;
}

- (BOOL)isMutableAtRow:(int)row column:(int)column {
    return _isMutable[row][column];
}

- (BOOL)isConsistentAtRow:(int)row column:(int)column for:(int)value {
    // Check row for inconsistency
    for (int currentRow = 0; currentRow < 9; currentRow++) {
        if (currentRow != row && _cells[currentRow][column] == value) {
            return NO;
        }
    }
    // Check column for inconsistency
    for (int currentColumn = 0; currentColumn < 9; currentColumn++) {
        if (currentColumn != column && _cells[row][currentColumn] == value) {
            return NO;
        }
    }
    // Check block for inconsistency
    int blockTopRow = (row / 3) * 3;
    int blockLeftColumn = (column / 3) * 3;
    for (int currentRow = blockTopRow; currentRow < blockTopRow + 3; currentRow++) {
        for (int currentColumn = blockLeftColumn; currentColumn < blockLeftColumn + 3; currentColumn++) {
            if (currentRow == row && currentColumn == column) {
                continue;
            }
            if (_cells[currentRow][currentColumn] == value) {
                return NO;
            }
        }
    }
    return YES;
}

@end