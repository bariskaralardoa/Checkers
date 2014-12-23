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

#define whiteBoardSquare whiteBoardSquare.png
#define brownBoardSquare brownBoardSquare.png

#define siyah-dama siyah-dama.png
#define beyaz-dama beyaz-dama.png


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




#pragma mark - Touch functions

-(void) viewTapped: (UIGestureRecognizer *) recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
//    CGPoint touchPoint2 = [recognizer locationOfTouch:0 inView:nil];
//    CGPoint touchPoint3 = [recognizer locationOfTouch:0 inView:self];
    float tileHeight = self.frame.size.width / [Globals NumberOfTilesInXDirection];

    TileCoordinates * clickedCoordinate = [[TileCoordinates alloc] initWithX:floor(touchPoint.x/tileHeight) withY:floor(touchPoint.y/tileHeight)];
 
    
    
    //    TileCoordinates *coord = [[TileCoordinates alloc] initWithX:floor(((coords.x)-9)/38) withY:floor(((coords.y)-20)/38)];

    
    
}








































@end
