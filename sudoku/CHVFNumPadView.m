//
//  CHVFNumPadView.m
//  sudoku
//
//  Created by Vincent Fiorentini on 9/21/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFNumPadView.h"

@interface CHVFNumPadView () {
    NSMutableArray* _cells;
    int _currentValue;
}
@end

@implementation CHVFNumPadView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    float cellSeparatorPortion = 1 / 40.0;
    int defaultSelectedCellNumber = 0;
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        float frameWidth = CGRectGetWidth(frame);
        float frameHeight = CGRectGetHeight(frame);
        
        CGFloat cellSeparatorWidth = frameWidth * cellSeparatorPortion;
        
        // There are 11 vertical separators and 2 horizontal separators around the 10 buttons
        CGFloat buttonWidth = (frameWidth - (cellSeparatorWidth * 11)) / 10;
        CGFloat buttonHeight = frameHeight - (cellSeparatorWidth * 2);
        
        _cells = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            int numSeparatorsToLeft = i + 1;
            CGFloat x = (cellSeparatorWidth * numSeparatorsToLeft) + (buttonWidth * i);
            CGFloat y = cellSeparatorWidth;
            CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
            UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
            
            button.tag = i; // the tag is the number shown on the button
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted | UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"yellow-highlight"] forState:UIControlStateSelected];
            NSString* title = (i == 0) ? @"" : [NSString stringWithFormat:@"%d", i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [_cells addObject:button];
        }
        [self selectCell:defaultSelectedCellNumber];
    }
    return self;
}

- (int)getCurrentValue {
    return _currentValue;
}

- (void)cellSelected:(id)sender {
    int tag = (int) [sender tag];
    [self selectCell:tag];
}

- (void)selectCell:(int)cellNumber {
    UIButton *buttonToUnselect = [_cells objectAtIndex:_currentValue];
    [buttonToUnselect setSelected:NO];
    
    _currentValue = cellNumber;
    UIButton *buttonToSelect = [_cells objectAtIndex:cellNumber];
    [buttonToSelect setSelected:YES];
}

@end
