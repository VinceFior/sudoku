//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHVFGridModel.h"

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

- (void)testGenerateGridHasNonZero {
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       getValueAtRow:column: and generateGrid
    [_gridModel generateGrid];
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
    // Note: This is not a "unit test", strictly speaking, since it calls
    //       getValueAtRow:column:, isConsistentAtRow:column:for:, and generateGrid
    [_gridModel generateGrid];
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
    // Note: This is not a "unit test", strictly speaking, since it calls generateGrid,
    //       getValueAtRow:column:, and isMutableAtRow:column:
    [_gridModel generateGrid];
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
    XCTAssertThrowsSpecific([_gridModel isConsistentAtRow:0 column:0 for:0], NSException, @"Value below min value");
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

@end
