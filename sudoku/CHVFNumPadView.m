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
    int defaultSelectedCellNumber = 1;
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        float frameWidth = CGRectGetWidth(frame);
        float frameHeight = CGRectGetHeight(frame);
        
        CGFloat cellSeparatorWidth = frameWidth * cellSeparatorPortion;
        
        // There are 10 vertical separators and 2 horizontal separators around the 9 buttons
        CGFloat buttonWidth = (frameWidth - (cellSeparatorWidth * 10)) / 9;
        CGFloat buttonHeight = frameHeight - (cellSeparatorWidth * 2);
        
        _cells = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            int numSeparatorsToLeft = i + 1;
            CGFloat x = (cellSeparatorWidth * numSeparatorsToLeft) + (buttonWidth * i);
            CGFloat y = cellSeparatorWidth;
            CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
            UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
            
            int buttonNumber = i + 1;
            button.tag = buttonNumber; // the tag is the number shown on the button
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted | UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"yellow-highlight"] forState:UIControlStateSelected];
            NSString* title = [NSString stringWithFormat:@"%d", buttonNumber];
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
    if (_currentValue != 0) {
        UIButton *buttonToUnselect = [_cells objectAtIndex:_currentValue - 1];
        [buttonToUnselect setSelected:NO];
    }
    
    _currentValue = cellNumber;
    UIButton *buttonToSelect = [_cells objectAtIndex:cellNumber - 1];
    [buttonToSelect setSelected:YES];
}

@end
