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
@property(nonatomic, strong) NSMutableArray *possibleMoves;

@property (nonatomic) UIImageView * suggestImageView;
@property (nonatomic) UIImage *suggestImage;


@end

@implementation GameEngine

- (NSMutableArray*) possibleMoves
{
    if (!_possibleMoves){
        _possibleMoves = [[NSMutableArray alloc] init];
    }
    return _possibleMoves;
}

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
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Globals whiteBoardSquare]]];
            }

            else {
                //                tileView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:234.0f/255.0f blue:254.0f/255.0f alpha:1];
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Globals brownBoardSquare]]];
            }

            //            [boardView addSubview:tileView];/// Ekincan: Bu kısım burada olmayacak, bu noktadan pres. layer'a yok erişim.

            tileView.isClicked = NO;
            tileView.indexX = row;
            tileView.indexY = col;
            tileView.tileCoordinates = [[TileCoordinates alloc] initWithX:row withY:col];
            _currentGame.tiles[row][col] = tileView;
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
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
            [pieceView setPieceInfoWithPiece:regularPiece];

            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.pieces addObject:pieceView];
        }

        for (int k = 5; k < 7; k++) {
            //            CheckersTileView* currentTile = self.boardTilesArr[i][k];

            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //
            //            currentTile.pieceView = pieceView;
            //            [currentTile addSubview:pieceView];

            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals whiteRegular] currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
            [pieceView setPieceInfoWithPiece:regularPiece];

            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.pieces addObject:pieceView];
        }
    }
}
//
- (void)possibleMoveIndicator:(TileCoordinates *) coord
{
    self.possibleMoves = [[NSMutableArray alloc] init];
    [self regularPiecePossibleMoves:coord];
    for (TileCoordinates *  coordinates in self.possibleMoves) {
        
    }
}


- (void)placePossibleMoveImageOnTile:(TileCoordinates *)coord withHeight:(float)height
{
    CGRect pieceFrame = CGRectMake(0, 0, height, height);
    
    _suggestImage = [UIImage imageNamed:[Globals suggest]];
    _suggestImageView = [[UIImageView alloc]initWithImage:self.suggestImage] ;
    _suggestImageView.frame = pieceFrame;
    
    [_currentGame.moveSuggestion addObject:_suggestImageView];
    
    
}
//

- (NSArray*)getTiles
{
    return _currentGame.tiles;
}

- (NSArray*)getPieces
{
    return _currentGame.pieces;
}


- (NSArray*)getMoveSuggestion
{
    return _currentGame.moveSuggestion;
}



#pragma mark IPieceMovements Members
- (void) createPieceOn:(TileCoordinates *)coord withHeight:(float)height
{
    CGRect pieceFrame = CGRectMake(0, 0, height, height);
    CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];

    RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:coord.x currentPositionY:coord.y playerSideType:pieceSideBlack];
    [pieceView setPieceInfoWithPiece:regularPiece];
    [_currentGame.pieces addObject:pieceView];

}



- (NSMutableArray *)whitePiecesCoordinates:(TileCoordinates *)coord
{
    NSMutableArray * whitePiecesArr = [[NSMutableArray alloc ]init];
    for (CheckersPieceView *  pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideWhite) {
            [whitePiecesArr addObject:pieceView];
        }
    }
    return whitePiecesArr;
}

- (NSMutableArray *)blackPiecesCoordinates:(TileCoordinates *)coord
{
    NSMutableArray * blackPiecesArr = [[NSMutableArray alloc ]init];
    for (CheckersPieceView *  pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideBlack) {
            [blackPiecesArr addObject:pieceView];
        }
    }
    return blackPiecesArr;
}

#pragma mark - Piece Movements

- (void)regularPiecePossibleMoves:(TileCoordinates *) coord
{
    [self regularPieceMovementNorth:coord];
    [self regularPieceMovementEast:coord];
    [self regularPieceMovementWest:coord];
    [self regularPieceMovementSouth:coord];
}


- (void)regularPieceMovementNorth:(TileCoordinates *) coord
{
    if (coord.y != 0) {
        coord.y--;
        [self.possibleMoves addObject:coord];
    }
    
}

- (void)regularPieceMovementSouth:(TileCoordinates *) coord
{
    if (coord.y != [Globals NumberOfTilesInXDirection]-1) {
        coord.y++;
        [self.possibleMoves addObject:coord];
    }
    
}

- (void)regularPieceMovementEast:(TileCoordinates *) coord
{
    if (coord.x != [Globals NumberOfTilesInXDirection]-1) {
        coord.x++;
        [self.possibleMoves addObject:coord];
    }
    
}

- (void)regularPieceMovementWest:(TileCoordinates *) coord
{
    if (coord.x != 0) {
        coord.x--;
        [self.possibleMoves addObject:coord];
    }
    
}


@end
