//
//  CHVFGridView.m
//  sudoku
//
//  Created by Vincent Fiorentini on 9/12/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFGridView.h"

@interface CHVFGridView () {
    NSMutableArray *_cells;
    id _target;
    SEL _action;
}
@end

@implementation CHVFGridView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    UIColor *backgroundColor = [UIColor colorWithRed:226.0/255 green:188.0/255 blue:250.0/255 alpha:1.0];
    float cellSeparatorPortion = 1 / 80.0;
    float blockSeparatorPortion = 1 / 60.0; // the additional width separations between blocks
    
    if (self) {
        self.backgroundColor = backgroundColor;
        
        float frameWidth = CGRectGetWidth(self.frame);
        float frameHeight = CGRectGetHeight(self.frame);
        
        // Calculate the size of the spacing between cells and blocks
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
                [button setBackgroundImage:[UIImage imageNamed:@"gridcell-neutral"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"gridcell-pressed"] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
                [rowArray addObject:button];
            }
            [_cells addObject:rowArray];
        }
    }
    
    return self;
}

- (void)setMutableAtRow:(int)row column:(int)column to:(BOOL)isMutable {
    UIColor *mutableTitleColor = [UIColor blackColor];
    UIColor *immutableTitleColor = [UIColor colorWithRed:120.0/255 green:115.0/255 blue:135.0/255 alpha:1.0];
    UIColor *shadowColor = [UIColor whiteColor];
    CGSize shadowSize = CGSizeMake(0.0, 1.0);
    
    UIButton *button = _cells[row][column];
    [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = shadowSize;
    if (isMutable) {
        [button setTitleColor:mutableTitleColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:immutableTitleColor forState:UIControlStateNormal];
    }
}

- (void)setValueAtRow:(int)row column:(int)column to:(int)value {
    UIButton *button = _cells[row][column];
    // The number 0 is used to represent blank
    if (value == 0) {
        [button setTitle:@"" forState:UIControlStateNormal];
    } else {
        NSString* title = [NSString stringWithFormat:@"%d", value];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)cellSelected:(id)sender {
    int buttonTag = (int) [sender tag];
    int row = buttonTag / 10;
    int column = buttonTag % 10;
    [_target performSelector:_action withObject:[NSNumber numberWithInt:row] withObject:[NSNumber numberWithInt:column]];
}

- (void)setHintStateAtRow:(int)row column:(int)column to:(HintState)hintState {
    UIButton *button = _cells[row][column];
    if (hintState == HintStateNeutral) {
        [button setBackgroundImage:[UIImage imageNamed:@"gridcell-neutral"] forState:UIControlStateNormal];
    } else if (hintState == HintStateValid) {
        [button setBackgroundImage:[UIImage imageNamed:@"gridcell-valid"] forState:UIControlStateNormal];
    } else if (hintState == HintStateInvalid) {
        [button setBackgroundImage:[UIImage imageNamed:@"gridcell-invalid"] forState:UIControlStateNormal];
    }
}


- (void)setTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

@end
