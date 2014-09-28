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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CHVFAppDelegate *appDelegate = (CHVFAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.gameStarted) {
        self.resumeButton.hidden = YES;
    }
}

- (IBAction)startNewGame:(id)sender {
    NSInteger difficultyTag = [sender tag];
    
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

- (IBAction)closeMenu {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
