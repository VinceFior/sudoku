//
//  CHVFViewController.m
//  sudoku
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFGameViewController.h"
#import "CHVFGridView.h"
#import "CHVFGridModel.h"
#import "CHVFNumPadView.h"
#import "CHVFGridGenerator.h"
#import "CHVFAppDelegate.h"

@interface CHVFGameViewController ()

@property DifficultyLevel difficultyLevel;
@property CHVFGridModel *gridModel;

@end

@implementation CHVFGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridModel = [[CHVFGridModel alloc] init];
    [self.gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
    [self.numPadView setTarget:self action:@selector(updateGridHighlighting)];
    
    CHVFAppDelegate *appDelegate = (CHVFAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.gameStarted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"GameToMenuSegueNoAnimation" sender:self];
        });
    }
}

- (void)startGameForDifficulty:(DifficultyLevel)difficultyLevel {
    self.difficultyLevel = difficultyLevel;
    
    CHVFAppDelegate *appDelegate = (CHVFAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.gameStarted = YES;
    
    NSString *gridFileName = @"grid1";
    NSString *gridFileDelimiter = @"\n";
    NSString *emptyCellMarker = @".";
    [self.gridModel initializeGridTo:[CHVFGridGenerator generateGrid:gridFileName
        delimitedBy:gridFileDelimiter emptyCellAs:emptyCellMarker]];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int value = [self.gridModel getValueAtRow:row column:col];
            BOOL isMutable = (value == 0); // 0 means empty
            [self.gridView setMutableAtRow:row column:col to:isMutable];
            [self.gridView setValueAtRow:row column:col to:value];
        }
    }
    
    [self.numPadView resetCurrentValue];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row col:(NSNumber*) col {
    int rowInt = [row intValue];
    int colInt = [col intValue];
    if (![self.gridModel isMutableAtRow:rowInt column:colInt]) {
        return;
    }
    
    int currentValue = [self.numPadView getCurrentValue];
    if (![self.gridModel isConsistentAtRow:rowInt column:colInt for:currentValue]) {
        return;
    }
    
    [self.gridView setValueAtRow:rowInt column:colInt to:currentValue];
    [self.gridModel setValueAtRow:rowInt column:colInt to:currentValue];
    [self updateGridHighlighting];
}

- (void)updateGridHighlighting {
    int currentNumPadValue = [self.numPadView getCurrentValue];
    if (self.difficultyLevel == DifficultyLevelEasy) {
        // Highlight all valid grid cells for current value of num pad
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                int cellValue = [self.gridModel getValueAtRow:row column:col];
                BOOL isConsistent = [self.gridModel isConsistentAtRow:row column:col for:currentNumPadValue];
                BOOL isMutable = [self.gridModel isMutableAtRow:row column:col];
                if (isConsistent && isMutable && (currentNumPadValue != cellValue) && (currentNumPadValue != 0)) {
                    [self.gridView setHintStateAtRow:row column:col to:HintStateValid];
                } else {
                    [self.gridView setHintStateAtRow:row column:col to:HintStateNeutral];
                }
            }
        }
    } else if (self.difficultyLevel == DifficultyLevelMedium) {
        // Highlight all grid cells that contain the current value of num pad
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                int cellValue = [self.gridModel getValueAtRow:row column:col];
                if ((cellValue == currentNumPadValue) && (currentNumPadValue != 0)) {
                    [self.gridView setHintStateAtRow:row column:col to:HintStateInvalid];
                } else {
                    [self.gridView setHintStateAtRow:row column:col to:HintStateNeutral];
                }
            }
        }
    } else if (self.difficultyLevel == DifficultyLevelHard) {
        // Do nothing
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end