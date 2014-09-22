//
//  CHVFGridModel.h
//  sudoku
//
//  Created by Megan Shao on 9/20/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHVFGridModel : NSObject

- (void)generateGrid;
- (int)getValueAtRow:(int)row column:(int)column;
- (void)setValueAtRow:(int)row column:(int)column to:(int)value;
- (BOOL)isMutableAtRow:(int)row column:(int)column;
- (BOOL)isConsistentAtRow:(int)row column:(int)column for:(int)value;

@end