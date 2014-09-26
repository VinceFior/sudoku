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

// initializeGridTo expects cells to be an NSArray of 9 NSArrays, each of which has 9 NSNumbers.
// A value of 0 represents a blank grid cell.
- (void)initializeGridTo:(NSArray *)cells {
    NSAssert([cells count] == 9, @"Grid does not have 9 rows (%d)", (int) [cells count]);
    for (int row = 0; row < 9; row++) {
        NSArray *rowArray = [cells objectAtIndex:(int) row];
        NSAssert([rowArray count] == 9, @"Grid row does not have 9 columns (row %d, count %d)", row, (int) [rowArray count]);
        for (int col = 0; col < 9; col++) {
            int cellValue = [(NSNumber *) [rowArray objectAtIndex:col] intValue];
            _cells[row][col] = cellValue;
            if (cellValue == 0) {
                _isMutable[row][col] = YES;
            } else {
                _isMutable[row][col] = NO;
            }
        }
    }
}

- (int)getValueAtRow:(int)row column:(int)column {
    NSAssert((row >= 0) && (row < 9), @"Row out of range (%d)", row);
    NSAssert((column >= 0) && (column < 9), @"Column out of range (%d)", column);
    return _cells[row][column];
}

- (void)setValueAtRow:(int)row column:(int)column to:(int)value {
    NSAssert((row >= 0) && (row < 9), @"Row out of range (%d)", row);
    NSAssert((column >= 0) && (column < 9), @"Column out of range (%d)", column);
    NSAssert((value >= 0) && (value <= 9), @"Value out of range (%d)", value);
    _cells[row][column] = value;
}

- (BOOL)isMutableAtRow:(int)row column:(int)column {
    NSAssert((row >= 0) && (row < 9), @"Row out of range (%d)", row);
    NSAssert((column >= 0) && (column < 9), @"Column out of range (%d)", column);
    return _isMutable[row][column];
}

- (BOOL)isConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert((row >= 0) && (row < 9), @"Row out of range (%d)", row);
    NSAssert((column >= 0) && (column < 9), @"Column out of range (%d)", column);
    NSAssert((value > 0) && (value <= 9), @"Value out of range (%d)", value);
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