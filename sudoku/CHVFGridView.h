//
//  CHVFGridView.h
//  sudoku
//
//  Created by Vincent Fiorentini on 9/12/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHVFGridView : UIView

- (void)setMutableAtRow:(int)row column:(int)column to:(BOOL)isMutable;
- (void)setValueAtRow:(int)row column:(int)column to:(int)value;
- (void)setTarget:(id)target action:(SEL)action;

@end
