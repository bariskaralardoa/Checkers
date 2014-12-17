//
//  GameEngne.m
//  Checkers
//
//  Created by DOA Software Mac on 15/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "GameEngine.h"
#import "NSMutableArray+MultidimensionExtension.h"
#import "TileCoordinates.h"
#import "CheckersTileView.h"
#import "Piece.h"
#import "RegularPiece.h"

#import "BoardView.h"


@interface GameEngine()

@property(strong,nonatomic) NSMutableArray * boardTilesArr;


@end

@implementation GameEngine

- (void) generateTiles
{
//    int noOfTilesX = 8;
//    int noOfTilesY = 8;
//    
//    _boardTilesArr = [NSMutableArray arrayOfWidth:noOfTilesX andHeight:noOfTilesY];
//    
//    for(int i=0; i<noOfTilesX; i++)
//    {
//        for(int j=0; j<noOfTilesY; j++){
//            CheckersTileView * tileView = [[CheckersTileView alloc] initWithFrame:CGRectMake((i*37)+i, (j*37)+j, 37, 37)];
//            
//            if((i+j) % 2 == 1)
//            {
//                //                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
//                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteBoardSquare"]];
//            }
//            
//            else
//            {
//                //                tileView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:234.0f/255.0f blue:254.0f/255.0f alpha:1];
//                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brownBoardSquare"]];
//                
//            }
//            
//            [self addSubview:tileView];
//            
//            tileView.isClicked = NO;
//            tileView.indexX = i;
//            tileView.indexY = j;
//            tileView.tileCoordinates = [[TileCoordinates alloc] initWithX:i withY:j];
//            _boardTilesArr [i][j] = tileView;
//            
//        }
//    }
}

-(void) generatePieces
{
    CGRect pieceFrame = CGRectMake(0, 0, 30, 30);
    
    for (int i = 0; i<8; i++) {
        
        for(int j = 1; j<3; j++)
        {
            //link CheckersTileView with CheckersPieceView
            CheckersTileView * currentTile = self.boardTilesArr[i][j];
            
            CheckersPieceView * pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            currentTile.pieceView = pieceView;
            [currentTile addSubview:pieceView];
            
            //link Piece with CheckersPieceView
            RegularPiece * regularPiece = [[RegularPiece alloc] initWithImageName:@"siyah-dama" currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
            [pieceView setPieceInfoWithPiece:regularPiece];
            
            pieceView.center = CGPointMake(currentTile.frame.size.width/2, currentTile.frame.size.height/2);
            
        }
        
        for(int k = 5; k<7; k++)
        {
            CheckersTileView * currentTile = self.boardTilesArr[i][k];
            
            CheckersPieceView * pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            currentTile.pieceView = pieceView;
            [currentTile addSubview:pieceView];
            
            RegularPiece * regularPiece = [[RegularPiece alloc] initWithImageName:@"beyaz-dama" currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
            [pieceView setPieceInfoWithPiece:regularPiece];
            
            pieceView.center = CGPointMake(currentTile.frame.size.width/2, currentTile.frame.size.height/2);
            
        }
        
    }
    
}

- (void)getTiles
{

}

- (void)getPieces
{

}



@end
