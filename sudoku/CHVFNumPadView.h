//
//  CHVFNumPadView.h
//  sudoku
//
//  Created by Vincent Fiorentini on 9/21/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHVFNumPadView : UIView

- (int)getCurrentValue;
- (void)setTarget:(id)target action:(SEL)action;

@end
