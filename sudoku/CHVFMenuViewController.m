//
//  CHVFMenuViewController.m
//  sudoku
//
//  Created by Vincent Fiorentini on 9/27/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import "CHVFMenuViewController.h"
#import "CHVFGameViewController.h"
#import "CHVFAppDelegate.h"

@interface CHVFMenuViewController ()

@end

@implementation CHVFMenuViewController

- (IBAction)startNewGame:(id)sender {
    NSInteger difficultyTag = [sender tag];
    CHVFGameViewController *gameViewController = (CHVFGameViewController *) self.presentingViewController;
    if (gameViewController.gameRunning) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Are you sure?"
                                  message:@"If you start a new game, your current game will not be saved."
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"New Game", nil];
        alertView.tag = difficultyTag;
        [alertView show];
        return;
    }
    
    [self startNewGameForDifficulty:difficultyTag];
}

- (IBAction)closeMenu {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CHVFGameViewController *gameViewController = (CHVFGameViewController *) self.presentingViewController;
    if (!gameViewController.gameRunning) {
        self.resumeButton.hidden = YES;
    }
}

- (void)startNewGameForDifficulty:(NSInteger)difficultyTag {
    CHVFGameViewController *gameViewController = (CHVFGameViewController *) self.presentingViewController;
    [gameViewController dismissViewControllerAnimated:YES completion:nil];
    if (difficultyTag == 0) {
        [gameViewController startGameForDifficulty:DifficultyLevelEasy];
    } else if (difficultyTag == 1) {
        [gameViewController startGameForDifficulty:DifficultyLevelMedium];
    } else if (difficultyTag == 2) {
        [gameViewController startGameForDifficulty:DifficultyLevelHard];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Cancel button - nothing to do
    } else if (buttonIndex == 1) {
        // New game
        [self startNewGameForDifficulty:[alertView tag]];
    }
}

@end
