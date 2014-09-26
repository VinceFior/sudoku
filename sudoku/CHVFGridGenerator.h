//
//  CHVFGridGenerator.h
//  sudoku
//
//  Created by Vincent Fiorentini on 9/26/14.
//  Copyright (c) 2014 Cyrus Huang, Vincent Fiorentini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHVFGridGenerator : NSObject

+ (NSArray *)generateGrid:(NSString *)gridFileName delimitedBy:(NSString *)gridFileDelimiter
              emptyCellAs:(NSString *)emptyCellMarker;

@end
