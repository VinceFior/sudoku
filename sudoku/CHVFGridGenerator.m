//
//  CHVFGridGenerator.m
//  sudoku
//
//  Created by Vincent Fiorentini on 9/26/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFGridGenerator.h"

@implementation CHVFGridGenerator

// generateGrid returns an NSArray of 9 NSArrays, each of which has 9 NSNumbers.
// A value of 0 represents a blank grid cell.
+ (NSArray *)generateGrid:(NSString *)gridFileName delimitedBy:(NSString *)gridFileDelimiter
              emptyCellAs:(NSString *)emptyCellMarker {
    // Read a grid from a file which contains multiple grids
    NSString *gridFilePath = [[NSBundle mainBundle] pathForResource:gridFileName ofType:@"txt"];
    NSError *error;
    NSString *gridFileString = [[NSString alloc] initWithContentsOfFile:gridFilePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *grids = [gridFileString componentsSeparatedByString:gridFileDelimiter];
    // Select one grid at random
    int gridIndex = arc4random_uniform((int) [grids count]);
    NSString *gridString = [grids objectAtIndex:gridIndex];
    NSAssert([gridString length] == 81, @"Grid not of length 81 (%d)", (int) [gridString length]);
    
    // Convert gridString into a 9x9 2-D array
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *cellsRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < 9; col++) {
            int cellValueIndex = (row * 9) + col;
            NSString *cellValueString = [gridString substringWithRange: NSMakeRange(cellValueIndex, 1)];
            if ([cellValueString isEqualToString:emptyCellMarker]) {
                [cellsRow addObject:[NSNumber numberWithInt:0]];
            } else {
                [cellsRow addObject:[NSNumber numberWithInt:[cellValueString intValue]]];
            }
        }
        [cells addObject:[NSArray arrayWithArray:cellsRow]];
    }
    
    return [NSArray arrayWithArray:cells];
}

@end
