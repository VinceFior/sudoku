//
//  CHVFViewController.h
//  sudoku
//
//  Created by Cyrus Huang on 9/11/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DifficultyLevel) {
    DifficultyLevelEasy,
    DifficultyLevelMedium,
    DifficultyLevelHard
};

@interface CHVFViewController : UIViewController

@property DifficultyLevel difficultyLevel;

@end
