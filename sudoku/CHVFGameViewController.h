//
//  CHVFViewController.h
//  sudoku
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHVFGridView;
@class CHVFNumPadView;

typedef NS_ENUM(NSInteger, DifficultyLevel) {
    DifficultyLevelEasy,
    DifficultyLevelMedium,
    DifficultyLevelHard
};

@interface CHVFGameViewController : UIViewController

@property BOOL gameRunning;
@property (nonatomic, weak) IBOutlet CHVFGridView *gridView;
@property (nonatomic, weak) IBOutlet CHVFNumPadView *numPadView;
@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
@property (nonatomic, weak) IBOutlet UIView *wonOverlay;
@property (nonatomic, weak) IBOutlet UIView *pauseOverlay;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;
@property (nonatomic, weak) IBOutlet UIButton *menuButton;

- (IBAction)pauseButtonPressed;
- (IBAction)resumeButtonPressed;
- (IBAction)menuButtonPressed;

- (void)startGameForDifficulty:(DifficultyLevel)difficultyLevel;

@end
