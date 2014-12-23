//
//  BoardView.m
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "BoardView.h"
#import "NSMutableArray+MultidimensionExtension.h"
#import "TileCoordinates.h"
#import "Piece.h"
#import "RegularPiece.h"
#import "Globals.h"





@interface BoardView()

@property(strong,nonatomic) NSMutableArray * boardTilesArr;


@end

@implementation BoardView



-(void) getPiecesIndexes
{
    for (int i = 0; i<8; i++) {
        for (int k= 0; k<8; k++) {
            CheckersTileView * tileView = _boardTilesArr[i][k];
            
            //Check if tile has piece on it or not
            if (tileView.pieceView) {
                
            }
                        
        }
    }


}












































@end
