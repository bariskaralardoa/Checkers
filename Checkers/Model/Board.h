//
//  Board.h
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoardCellState.h"

@interface Board : NSObject

//Gets the state of the cell at given location
- (BoardCellState) cellStateAtColumn: (NSInteger)column andRow: (NSInteger) row;

//Sets the state of the cell at given location
- (void) setCellState: (BoardCellState)state forColumn: (NSInteger)column andRow: (NSInteger)row;

- (void) clearBoard;

@end
