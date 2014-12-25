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
#import "SuggestionView.h"
#import "Suggestion.h"

@interface GameEngine ()

@property (strong, nonatomic) NSMutableArray* boardTilesArr;
@property (nonatomic) Game* currentGame;
@property(nonatomic, strong) NSMutableArray *possibleMoves;
@property(nonatomic, strong) NSMutableArray *possibleEaten;

@property (nonatomic) UIImageView * suggestImageView;
@property (nonatomic) UIImage *suggestImage;


@end

@implementation GameEngine
{
    NSMutableArray * blackPiecesArr;
    NSMutableArray * whitePiecesArr;
    BOOL isClickedWhite;
    BOOL isClickedBlack;
    CheckersPieceView * clickedPieceView;
}

- (NSMutableArray*) possibleMoves
{
    if (!_possibleMoves){
        _possibleMoves = [[NSMutableArray alloc] init];
    }
    return _possibleMoves;
}

- (NSMutableArray*) possibleEaten
{
    if (!_possibleEaten){
        _possibleEaten = [[NSMutableArray alloc] init];
    }
    return _possibleEaten;
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
            //_currentGame.moveSuggestion[row][col] = tileView;
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
//        for (int j = 5; j < 6; j++) {
//            //link CheckersTileView with CheckersPieceView
//            //            CheckersTileView* currentTile = self.boardTilesArr[i][j];
//            
//            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
//            //            currentTile.pieceView = pieceView;
//            //            [currentTile addSubview:pieceView];
//            
//            //link Piece with CheckersPieceView
//            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
//            [pieceView setPieceInfoWithPiece:regularPiece];
//            
//            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
//            [_currentGame.pieces addObject:pieceView];
//        }

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
- (void)possibleMoveIndicator:(TileCoordinates *) coord withHeight:(float)height
{
    self.possibleMoves = [[NSMutableArray alloc] init];
    [self regularPiecePossibleMoves:coord];
    
    for (TileCoordinates *  coordinates in self.possibleMoves) {
        [self placePossibleMoveImageOnTile:coordinates withHeight:height];
    }
}


- (void)placePossibleMoveImageOnTile:(TileCoordinates *)coord withHeight:(float)height
{
    CGRect suggestionFrame = CGRectMake(0, 0, height, height);

    SuggestionView * suggestionView = [[SuggestionView alloc] initWithFrame:suggestionFrame];
    Suggestion * suggest = [[Suggestion alloc] initWithCurrentX:coord.x currentY:coord.y imageName:[Globals suggest]];
    [suggestionView setSuggestionInfoWithSuggestion:suggest];
    [_currentGame.moveSuggestion addObject:suggestionView];
    
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



- (void)whitePiecesCoordinates
{
    whitePiecesArr = [[NSMutableArray alloc ]init];
    for (CheckersPieceView *  pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideWhite) {
            [whitePiecesArr addObject:pieceView];
        }
    }
}

- (void)blackPiecesCoordinates
{
    blackPiecesArr = [[NSMutableArray alloc ]init];
    for (CheckersPieceView *  pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideBlack) {
            [blackPiecesArr addObject:pieceView];
        }
    }
}

- (void) detectClickedCellStatus:(TileCoordinates *)coord
{
    isClickedWhite = NO;
    isClickedBlack = NO;
    //Add pieces to whitePiecesArr and blackPiecesArr
    [self blackPiecesCoordinates];
    [self whitePiecesCoordinates];
    
    
    //White clicked
    for (CheckersPieceView *  pieceView in whitePiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            isClickedWhite = YES;
        }
    }
    //Black clicked
    for (CheckersPieceView *  pieceView in blackPiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            isClickedBlack = YES;
        }
    }
    
    
}

- (void)getCurrentClickedPieceObject:(TileCoordinates *) coord
{
    for (CheckersPieceView * pieceView in _currentGame.pieces) {
        if (pieceView.IndexX == coord.x && pieceView.IndexY == coord.y) {
            clickedPieceView = pieceView;
        }
    }
}

#pragma mark - Possible Moves
- (void) checkNorthForRegularPieceMove:(TileCoordinates *) coord
{
    
}


#pragma mark - Piece Movements

- (void)regularPiecePossibleMoves:(TileCoordinates *) coord
{
    [self getCurrentClickedPieceObject:coord];
    
    if (isClickedWhite) {
        [self regularPieceMovementNorth:coord];
        [self regularPieceMovementEast:coord];
        [self regularPieceMovementWest:coord];
    }
    else if (isClickedBlack)
    {
        [self regularPieceMovementEast:coord];
        [self regularPieceMovementWest:coord];
        [self regularPieceMovementSouth:coord];
    }
}

- (BOOL)isCellOccupied:(TileCoordinates *) coord
{
    for (CheckersPieceView * pieceView in _currentGame.pieces) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            return YES;
        }
    }
    return NO;
}

//- (void)regularPieceMovementNorth:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.y != 0) {
//        tempCoord.y--;
//        [self.possibleMoves addObject:tempCoord];
//    }
//    
//}
- (void)regularPieceMovementNorth:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (tempCoord.y != 0) {
        tempCoord.y--;
        for (CheckersPieceView * pieceView in _currentGame.pieces) {
            NSLog(@"%d,%d",pieceView.IndexX,pieceView.IndexY);
            //Check if north of clicked cell is in pieces array
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y) {
                //Check if north's side is same with clickedPiece, if it's different, then add it to possibleMoves array
                if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                    //Add opposite color piece to possibleEaten array
                    [self.possibleEaten addObject:tempCoord];
                    tempCoord.y--;
                    if (![self isCellOccupied:tempCoord]) {
                        [self.possibleMoves addObject:tempCoord];
                    }
                }
            }
            // if north of the clicked cell is empty
            else if (![self isCellOccupied:tempCoord]){
                [self.possibleMoves addObject:tempCoord];
            }
        }
    }
}

//- (void)regularPieceMovementSouth:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.y != [Globals NumberOfTilesInXDirection]-1) {
//        tempCoord.y++;
//        [self.possibleMoves addObject:tempCoord];
//    }
//    
//}
- (void)regularPieceMovementSouth:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (tempCoord.y != [Globals NumberOfTilesInXDirection]-1) {
        tempCoord.y++;
        [self.possibleMoves addObject:tempCoord];
    }
    
}
- (void)regularPieceMovementEast:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (tempCoord.x != [Globals NumberOfTilesInXDirection]-1) {
        tempCoord.x++;
        [self.possibleMoves addObject:tempCoord];
    }
    
}

- (void)regularPieceMovementWest:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (tempCoord.x != 0) {
        tempCoord.x--;
        [self.possibleMoves addObject:tempCoord];
    }
    
}




@end
