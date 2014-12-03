//
//  BoardCellState.h
//  Checkers
//
//  Created by DOA Software Mac on 02/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#ifndef Checkers_BoardCellState_h
#define Checkers_BoardCellState_h

typedef NS_ENUM(NSUInteger, BoardCellState)
{
    BoardCellStateEmpty = 0,
    BoardCellStateBlackPiece = 1,
    BoardCellStateWhitePiece = 2,
    BoardCellStateBlackCheckPiece = 3,
    BoardCellStateWhiteCheckPiece = 4
};

#endif
