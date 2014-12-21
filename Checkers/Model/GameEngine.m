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
#import "Game.h"
#import "Globals.h"
@interface GameEngine ()

@property (strong, nonatomic) NSMutableArray* boardTilesArr;
@property (nonatomic) Game* currentGame;

@end

@implementation GameEngine

#pragma mark Singleton
__strong static id _sharedObject = nil;
+ (GameEngine*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

/* IGameState Members  */
#pragma mark IGameState Members

/// Ekincan
- (void)startNewGameWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer withTileHeight:(float)tileHeight withPieceHeight:(float)pieceHeight
{
    whitePlayer.CurrentPoint = [NSNumber numberWithInt:0];
    blackPlayer.CurrentPoint = [NSNumber numberWithInt:0];
    _currentGame = [[Game alloc] initWithWhitePlayer:whitePlayer withBlackPlayer:blackPlayer];
    [self generateTilesWithTileHeight:tileHeight];
    [self generatePiecesWithHeight:pieceHeight]; /// Ekincan: Bu tabi ki statik olmayacak. Üşendim yukardaki fonk. koymaya :)
}

- (void)endGame
{
}

/* ISetupBoard Members  */
#pragma mark ISetupBoard Members
- (void)generateTilesWithTileHeight:(float)tileHeight
{

    //    BoardView* boardView = [[BoardView alloc] init];

    //    int noOfTilesX = 8;
    //    int noOfTilesY = 8;
    //
    //    float rowHeight = height / [Globals NumberOfTilesInYDirection];
    //    float columnWidth = width / [Globals NumberOfTilesInXDirection];

    //    _boardTilesArr = [NSMutableArray arrayOfWidth:noOfTilesX andHeight:noOfTilesY];

    for (int row = 0; row < [Globals NumberOfTilesInXDirection]; row++) {
        for (int col = 0; col < [Globals NumberOfTilesInYDirection]; col++) {
            CheckersTileView* tileView = [[CheckersTileView alloc] initWithFrame:CGRectMake(col * tileHeight, row * tileHeight, tileHeight, tileHeight)];

            if ((col + row) % 2 == 1) {
                //                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteBoardSquare"]];
            }

            else {
                //                tileView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:234.0f/255.0f blue:254.0f/255.0f alpha:1];
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brownBoardSquare"]];
            }

            //            [boardView addSubview:tileView];/// Ekincan: Bu kısım burada olmayacak, bu noktadan pres. layer'a yok erişim.

            tileView.isClicked = NO;
            tileView.indexX = row;
            tileView.indexY = col;
            tileView.tileCoordinates = [[TileCoordinates alloc] initWithX:row withY:col];
            _currentGame.Tiles[row][col] = tileView;
        }
    }
}

- (void)generatePiecesWithHeight:(float)height
{
    CGRect pieceFrame = CGRectMake(0, 0, height, height);

    for (int i = 0; i < 8; i++) {

        for (int j = 1; j < 3; j++) {
            //link CheckersTileView with CheckersPieceView
            //            CheckersTileView* currentTile = self.boardTilesArr[i][j];

            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //            currentTile.pieceView = pieceView;
            //            [currentTile addSubview:pieceView];

            //link Piece with CheckersPieceView
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:@"siyah-dama" currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
            [pieceView setPieceInfoWithPiece:regularPiece];

            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.Pieces addObject:pieceView];
        }

        for (int k = 5; k < 7; k++) {
            //            CheckersTileView* currentTile = self.boardTilesArr[i][k];

            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //
            //            currentTile.pieceView = pieceView;
            //            [currentTile addSubview:pieceView];

            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:@"beyaz-dama" currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
            [pieceView setPieceInfoWithPiece:regularPiece];

            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.Pieces addObject:pieceView];
        }
    }
}

- (NSArray*)getTiles
{
    return _currentGame.Tiles;
}

- (NSArray*)getPieces
{
    return _currentGame.Pieces;
}

@end
