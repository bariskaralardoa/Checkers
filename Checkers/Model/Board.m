//
//  Board.m
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Board.h"

@implementation Board
{
    NSUInteger board[8][8];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self clearBoard];
    }
    return self;
}

- (BoardCellState) cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    return board[column][row];

}

- (void) setCellState:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row
{

    board[column][row] = state;
}

- (void)clearBoard
{
    for (int col = 0; col<8; col++) {
        for (int row = 0; row<8; row++) {
            board[col][row] = 0;
            
        }
    }

}



@end
