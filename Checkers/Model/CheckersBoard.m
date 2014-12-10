//
//  CheckersBoard.m
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersBoard.h"

@implementation CheckersBoard

- (void) setToInitialState
{
    [super clearBoard];
    [self placePieces:BoardCellStateBlackPiece startingRow:1 endingRow:2];
    [self placePieces:BoardCellStateWhitePiece startingRow:5 endingRow:6];
}


//Setup board
-(void) placePieces: (BoardCellState) side startingRow: (int)rowFirst endingRow: (int)rowSecond
{
    for (int row = rowFirst; row<=rowSecond; row++) {
        for (int col = 0; col<8; col++) {
            [super setCellState:side forColumn:col andRow:row];
        }
    }
    
}


-(void) placeBlackPieces
{
    for (int row = 1; row<=2; row++) {
        for (int col = 0; col<8; col++) {
            [super setCellState:BoardCellStateBlackPiece forColumn:col andRow:row];
        }
    }

}

-(void) placeWhitePieces
{
    for (int row = 5; row<=6; row++) {
        for (int col = 0; col<8; col++) {
            [super setCellState:BoardCellStateWhitePiece forColumn:col andRow:row];
        }
    }
    
}
@end
