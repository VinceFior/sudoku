//
//  CHVFMenuViewController.h
//  sudoku
//
//  Created by Vincent Fiorentini on 9/27/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHVFMenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *resumeButton;

- (IBAction)startNewGame:(id)sender;
- (IBAction)closeMenu;

@end
