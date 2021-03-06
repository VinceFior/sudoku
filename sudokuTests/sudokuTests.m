//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHVFGridModel.h"
#import "CHVFGridGenerator.h"

@interface sudokuTests : XCTestCase {
    CHVFGridModel *_gridModel;
}

@end

@implementation sudokuTests

- (void)setUp {
    [super setUp];
    _gridModel = [[CHVFGridModel alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitializeGridToWrongRowSize {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        [cells addObject:[NSNumber numberWithInt:0]];
    }
    XCTAssertThrowsSpecific([_gridModel initializeGridTo:cells], NSException, @"Too few rows");
}

- (void)testInitializeGridToWrongColSize {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *cellsRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < 8; col++) {
            [cellsRow addObject:[NSNumber numberWithInt:0]];
        }
        [cells addObject:cellsRow];
    }
    XCTAssertThrowsSpecific([_gridModel initializeGridTo:cells], NSException, @"Too few columns");
}

- (void)testGenerateGridHasNonZero {
    // Note: This is not a "unit test", strictly speaking, since it calls getValueAtRow:column:,
    //       initializeGridTo:, and CHVFGridGenerator generateGrid
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    [_gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    BOOL hasNonZero = NO;
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            if ([_gridModel getValueAtRow:row column:col] != 0) {
                hasNonZero = YES;
            }
        }
    }
    XCTAssertTrue(hasNonZero);
}

- (void)testGenerateGridIsConsistent {
    // Note: This is not a "unit test", strictly speaking, since it calls getValueAtRow:column:,
    //       isConsistentAtRow:column:for:, initializeGridTo:, and CHVFGridGenerator generateGrid
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    [_gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = [_gridModel getValueAtRow:row column:col];
            if (value != 0) {
                XCTAssertTrue([_gridModel isConsistentAtRow:row column:col for:value]);
            }
        }
    }
}

- (void)testGetValueAtRowColumnBounds {
    XCTAssertThrowsSpecific([_gridModel getValueAtRow:-1 column:0], NSException, @"Row below min value");
    XCTAssertThrowsSpecific([_gridModel getValueAtRow:9 column:0], NSException, @"Row above max value");
    XCTAssertThrowsSpecific([_gridModel getValueAtRow:0 column:-1], NSException, @"Col below min value");
    XCTAssertThrowsSpecific([_gridModel getValueAtRow:0 column:9], NSException, @"Col above max value");
}

- (void)testSetValueAtRowColumnBounds {
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:-1 column:0 to:1], NSException, @"Row below min value");
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:9 column:0 to:1], NSException, @"Row above max value");
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:0 column:-1 to:1], NSException, @"Col below min value");
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:0 column:9 to:1], NSException, @"Col above max value");
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:0 column:0 to:-1], NSException, @"Value below min value");
    XCTAssertThrowsSpecific([_gridModel setValueAtRow:0 column:0 to:10], NSException, @"Value above max value");
}

- (void)testGetValueEqualsSetValue {
    // Note: This is not a "unit test", strictly speaking, since it calls both
    //       getValueAtRow:column: and setValueAtRow:column:to:
    int value = 1;
    [_gridModel setValueAtRow:0 column:0 to:value];
    XCTAssertEqual(value, [_gridModel getValueAtRow:0 column:0]);
}

- (void)testIsMutableAtRowColumnBounds {
    XCTAssertThrowsSpecific([_gridModel isMutableAtRow:-1 column:0], NSException, @"Row below min value");
    XCTAssertThrowsSpecific([_gridModel isMutableAtRow:9 column:0], NSException, @"Row above max value");
    XCTAssertThrowsSpecific([_gridModel isMutableAtRow:0 column:-1], NSException, @"Col below min value");
    XCTAssertThrowsSpecific([_gridModel isMutableAtRow:0 column:9], NSException, @"Col above max value");
}

- (void)testIsMutableForGeneratedGrid {
    // Note: This is not a "unit test", strictly speaking, since it calls initializeGridTo:,
    //       getValueAtRow:column:, isMutableAtRow:column:, and CHVFGridGenerator generateGrid
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    [_gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = [_gridModel getValueAtRow:row column:col];
            if (value == 0) {
                XCTAssertTrue([_gridModel isMutableAtRow:row column:col]);
            } else {
                XCTAssertFalse([_gridModel isMutableAtRow:row column:col]);
            }
        }
    }
}

- (void)testIsConsistentAtRowColumnBounds {
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:-1 column:0 for:1], NSException, @"Row below min value");
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:9 column:0 for:1], NSException, @"Row above max value");
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:0 column:-1 for:1], NSException, @"Col below min value");
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:0 column:9 for:1], NSException, @"Col above max value");
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:0 column:0 for:-1], NSException, @"Value below min value");
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:0 column:0 for:10], NSException, @"Value above max value");
}

- (void)testIsConsistentWithDuplicatesInRow {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to and isConsistentAtRow:column:for:
    int value = 1;
    [_gridModel setValueAtRow:0 column:0 to:value];
    XCTAssertFalse([_gridModel isConsistentAtRow:0 column:3 for:value]);
}

- (void)testIsConsistentWithDuplicatesInColumn {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to and isConsistentAtRow:column:for:
    int value = 1;
    [_gridModel setValueAtRow:0 column:0 to:value];
    XCTAssertFalse([_gridModel isConsistentAtRow:3 column:0 for:value]);
}

- (void)testIsConsistentWithDuplicatesInBlock {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to and isConsistentAtRow:column:for:
    int value = 1;
    [_gridModel setValueAtRow:0 column:0 to:value];
    XCTAssertFalse([_gridModel isConsistentAtRow:1 column:1 for:value]);
}

- (void)testIsConsistentWithConsistentDuplicates {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to and isConsistentAtRow:column:for:
    int value = 1;
    [_gridModel setValueAtRow:2 column:2 to:value];
    XCTAssertTrue([_gridModel isConsistentAtRow:3 column:3 for:value]);
}

- (void)testIsGridSolvedWithSolvedGrid {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to
    int solvedGrid[9][9]={
        {1,2,3,4,5,6,7,8,9},
        {4,5,6,7,8,9,1,2,3},
        {7,8,9,1,2,3,4,5,6},
        {2,3,4,5,6,7,8,9,1},
        {5,6,7,8,9,1,2,3,4},
        {8,9,1,2,3,4,5,6,7},
        {3,4,5,6,7,8,9,1,2},
        {6,7,8,9,1,2,3,4,5},
        {9,1,2,3,4,5,6,7,8}
    };
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            [_gridModel setValueAtRow:row column:col to:solvedGrid[row][col]];
        }
    }
    XCTAssertTrue([_gridModel isGridSolved]);
}

- (void)testIsGridSolvedWithInconsistentGrid {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to
    int inconsistentGrid[9][9]={
        {1,2,3,4,5,6,7,8,9},
        {4,5,6,7,8,9,1,2,3},
        {7,8,9,1,2,3,4,5,6},
        {2,3,4,5,6,7,8,9,1},
        {5,6,7,8,9,1,2,3,4},
        {8,9,1,2,3,4,5,6,7},
        {3,4,5,6,7,8,9,1,2},
        {6,7,8,9,1,2,3,4,5},
        {9,1,2,3,4,5,6,7,1}
    }; // last cell is inconsistent (should be 8)
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            [_gridModel setValueAtRow:row column:col to:inconsistentGrid[row][col]];
        }
    }
    XCTAssertFalse([_gridModel isGridSolved]);
}

- (void)testIsGridSolvedWithIncompleteGrid {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       setValueAtRow:column:to
    int incompleteGrid[9][9]={
        {1,2,3,4,5,6,7,8,9},
        {4,5,6,7,8,9,1,2,3},
        {7,8,9,1,2,3,4,5,6},
        {2,3,4,5,6,7,8,9,1},
        {5,6,7,8,9,1,2,3,4},
        {8,9,1,2,3,4,5,6,7},
        {3,4,5,6,7,8,9,1,2},
        {6,7,8,9,1,2,3,4,5},
        {9,1,2,3,4,5,6,7,0}
    }; // last cell is empty
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            [_gridModel setValueAtRow:row column:col to:incompleteGrid[row][col]];
        }
    }
    XCTAssertFalse([_gridModel isGridSolved]);
}

@end
