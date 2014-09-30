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
@property NSTimer *gameTimer;
@property NSTimeInterval gameTimeElapsed;

@end

@implementation CHVFGameViewController

const NSTimeInterval TIMER_UPDATE_INTERVAL = 1.0;

- (IBAction)pauseButtonPressed {
    [self setPauseOverlayVisible:YES];
    [self pauseGameTimer];
}

- (IBAction)resumeButtonPressed {
    [self setPauseOverlayVisible:NO];
    [self resumeGameTimer];
}

- (IBAction)menuButtonPressed {
    [self setPauseOverlayVisible:YES];
    [self pauseGameTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *pauseButtonDisableColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    [self.pauseButton setTitleColor:pauseButtonDisableColor forState:UIControlStateDisabled];
    
    self.gridModel = [[CHVFGridModel alloc] init];
    [self.gridView setTarget:self action:@selector(gridCellSelectedAtRow:col:)];
    [self.numPadView setTarget:self action:@selector(updateGridHighlighting)];
    
    self.gameRunning = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"GameToMenuSegueNoAnimation" sender:self];
    });
}

- (void)startGameForDifficulty:(DifficultyLevel)difficultyLevel {
    self.difficultyLevel = difficultyLevel;
    
    self.gameRunning = YES;
    
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
    [self updateGridHighlighting];
    [self setWonOverlayVisible:NO];
    [self setPauseOverlayVisible:NO];
    [self resetGameTimer];
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
    
    if ([_gridModel isGridSolved]) {
        [self setWonOverlayVisible:YES];
        [self pauseGameTimer];
        self.gameRunning = NO;
    }
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
        // Set all grid cells to neutral highlight state
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                [self.gridView setHintStateAtRow:row column:col to:HintStateNeutral];
            }
        }
    }
}

- (void)setWonOverlayVisible:(BOOL)isVisible {
    self.wonOverlay.userInteractionEnabled = isVisible;
    self.wonOverlay.hidden = !isVisible;
    self.pauseButton.enabled = !isVisible;
    self.menuButton.enabled = !isVisible;
}

- (void)setPauseOverlayVisible:(BOOL)isVisible {
    self.pauseOverlay.userInteractionEnabled = isVisible;
    self.pauseOverlay.hidden = !isVisible;
    self.pauseButton.enabled = !isVisible;
}

- (void)resetGameTimer {
    if (self.gameTimer != nil) {
        [self.gameTimer invalidate];
        self.gameTimer = nil;
    }
    self.gameTimeElapsed = 0;
    [self startGameTimer];
}

- (void)updateTimerDisplay:(NSTimer *)timer {
    self.gameTimeElapsed += TIMER_UPDATE_INTERVAL;
    self.timerLabel.text = [CHVFGameViewController timerFormattedStringFromSeconds:self.gameTimeElapsed];
}

- (void)pauseGameTimer {
    if (self.gameTimer == nil) {
        return;
    }
    // When we pause, we calculate the portion of a second that has elapsed since we last updated gameTimeElapsed.
    // We increment gameTimeElapsed by this time interval. Otherwise, this split-second would be lost.
    NSDate *nextFireDate = [self.gameTimer fireDate];
    NSTimeInterval timeUntilNextFireDate = [nextFireDate timeIntervalSinceNow];
    NSTimeInterval timeElapsed = TIMER_UPDATE_INTERVAL - timeUntilNextFireDate;
    self.gameTimeElapsed += timeElapsed;
    
    [self.gameTimer invalidate];
    self.gameTimer = nil;
    
    self.timerLabel.text = [CHVFGameViewController timerFormattedStringFromSeconds:self.gameTimeElapsed];
}

- (void)resumeGameTimer {
    // We calculate the time interval remaining until the gameTimer gets to the next whole second.
    // After that time interval, we start a repeating timer to update every second.
    NSTimeInterval timeUntilNextSecond = TIMER_UPDATE_INTERVAL - fmod(self.gameTimeElapsed, TIMER_UPDATE_INTERVAL);
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:timeUntilNextSecond target:self
        selector:@selector(updateGameTimeElapsedAndStartGameTimer:) userInfo:[NSNumber numberWithDouble:timeUntilNextSecond] repeats:NO];
}

- (void)updateGameTimeElapsedAndStartGameTimer:(NSTimer *)timer {
    // This method assumes that the given timer has an NSNumber userInfo that represents
    // the time interval since gameTimeElapsed was last updated.
    NSTimeInterval timeElapsed = [((NSNumber *) [timer userInfo]) doubleValue];
    self.gameTimeElapsed += timeElapsed;
    [self startGameTimer];
}

- (void)startGameTimer {
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_UPDATE_INTERVAL target:self
        selector:@selector(updateTimerDisplay:) userInfo:nil repeats:YES];
    self.timerLabel.text = [CHVFGameViewController timerFormattedStringFromSeconds:self.gameTimeElapsed];
}

+ (NSString *)timerFormattedStringFromSeconds:(NSTimeInterval)timeInterval {
    // If the timer is too big to show, display the largest time possible, which is 99 hours, 59 minutes, and 59 seconds
    NSTimeInterval maxTime = (99 * (60 * 60)) + (59 * (60)) + 59;
    if (timeInterval > maxTime) {
        return @"99:59:59";
    }
    int hours = timeInterval / (60 * 60);
    int minutes = ((int) (timeInterval / 60)) % 60;
    int seconds = ((int) timeInterval) % 60;
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

@end