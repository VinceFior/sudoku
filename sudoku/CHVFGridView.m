//
//  CHVFGridView.m
//  sudoku
//
//  Created by Vincent Fiorentini on 9/12/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFGridView.h"

@interface CHVFGridView () {
    NSMutableArray* _cells;
    id _target;
    SEL _action;
}
@end

@implementation CHVFGridView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        float frameWidth = CGRectGetWidth(frame);
        float frameHeight = CGRectGetHeight(frame);
        
        // Calculate the size of the spacing between cells and blocks
        float cellSeparatorPortion = 1 / 80.0;
        float blockSeparatorPortion = 1 / 40.0; // the additional width separations between blocks
        CGFloat cellSeparatorWidth = frameWidth * cellSeparatorPortion;
        CGFloat cellSeparatorHeight = frameHeight * cellSeparatorPortion;
        CGFloat blockSeparatorWidth = frameWidth * blockSeparatorPortion;
        CGFloat blockSeparatorHeight = frameHeight * blockSeparatorPortion;
        
        // The total grid size = 9 buttons + 4 block separators + 10 cell separators
        // The button size is calculated by the equation above
        CGFloat buttonWidth = (frameWidth - (blockSeparatorWidth * 4) - (cellSeparatorWidth * 10)) / 9.0;
        CGFloat buttonHeight = (frameHeight - (blockSeparatorHeight * 4) - (cellSeparatorHeight * 10)) / 9.0;
        
        // Set up buttons (cells)
        _cells = [[NSMutableArray alloc] init];
        for (int row = 0; row < 9; row++) {
            // Create an array of nine buttons that makes up a row
            NSMutableArray* rowArray = [[NSMutableArray alloc] init];
            for (int col = 0; col < 9; col++) {
                // Calculate the number of separators to the left/top of the button
                int blockSepLeftNum = (col / 3) + 1;
                int blockSepTopNum = (row / 3) + 1;
                int cellSepLeftNum = col + 1;
                int cellSepTopNum = row + 1;
                
                // Calculate the coordinate of the top left corner of the button
                CGFloat x = blockSepLeftNum * blockSeparatorWidth + cellSepLeftNum * cellSeparatorWidth + col * buttonWidth;
                CGFloat y = blockSepTopNum * blockSeparatorHeight + cellSepTopNum * cellSeparatorHeight + row * buttonHeight;
                CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
                UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
                
                button.tag = row * 10 + col; // e.g.: for the cell of row 2 col 7, the tag is 27
                button.backgroundColor = [UIColor whiteColor];
                [button setBackgroundImage:[UIImage imageNamed:@"gray-highlight"] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
                [rowArray addObject:button];
            }
            [_cells addObject:rowArray];
        }
    }
    
    return self;
}

- (void)setValueAtRow:(int)row col:(int)col to:(int)value {
    UIButton* button = _cells[row][col];
    // The number 0 is used to represent blank
    if (value == 0) {
        [button setTitle:@"" forState:UIControlStateNormal];
    } else {
        NSString* title = [NSString stringWithFormat:@"%d", value];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)cellSelected:(id)sender
{
    int buttonTag = (int) [sender tag];
    int row = buttonTag / 10;
    int col = buttonTag % 10;
    [_target performSelector:_action withObject:[NSNumber numberWithInt:row] withObject:[NSNumber numberWithInt:col]];
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
