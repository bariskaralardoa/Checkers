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
#import "CheckPiece.h"
#import "BoardView.h"
#import "Game.h"
#import "Globals.h"
#import "SuggestionView.h"
#import "Suggestion.h"
#import "Eatable.h"
#import "SelectedPiece.h"
#import "SelectedPieceView.h"


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
    BOOL isCheckPieceSelected;
    CheckersPieceView * clickedPieceView;
    BOOL isInPossibleMoves;
    BOOL isInPossibleEaten;
    
    TileCoordinates * clickedPossibleMoves;
    TileCoordinates * clickedCapturedPiece;
    
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
#pragma mark - IGameState Members

/// Ekincan
- (void)startNewGameWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer withTileHeight:(float)tileHeight withPieceHeight:(float)pieceHeight
{
    whitePlayer.currentPoint = 0;
    blackPlayer.currentPoint = 0;
    _currentGame = [[Game alloc] initWithWhitePlayer:whitePlayer withBlackPlayer:blackPlayer];
    
    
    [self generateTilesWithTileHeight:tileHeight];
    [self generatePiecesWithHeight:pieceHeight]; /// Ekincan: Bu tabi ki statik olmayacak. Üşendim yukardaki fonk. koymaya :)
}

- (void)nextTurn
{
    [_currentGame nextTurn];
}

- (NSString *)endGame
{
    if (whitePiecesArr.count == 0) {
        NSLog(@"Black wins");
        return @"Black wins";
    }
    else if (blackPiecesArr.count == 0) {
        NSLog(@"White wins");
        return @"White wins";
    }
    return @"";
}

/* ISetupBoard Members  */
#pragma mark - ISetupBoard Members
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

//        for (int j = 1; j < 3; j++) {
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
        
        
        
        
        
//        for (int j = 6; j < 7; j++) {
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

        
        for (int k = 3; k < 4; k++) {
            //            CheckersTileView* currentTile = self.boardTilesArr[i][k];
            
            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //
            //            currentTile.pieceView = pieceView;
            //            [currentTile addSubview:pieceView];
            
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals whiteChecker] currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
            [pieceView setPieceInfoWithPiece:regularPiece];
            
            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.pieces addObject:pieceView];
        }

        for (int j = 4; j < 5; j++) {
            //link CheckersTileView with CheckersPieceView
            //            CheckersTileView* currentTile = self.boardTilesArr[i][j];
            
            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //            currentTile.pieceView = pieceView;
            //            [currentTile addSubview:pieceView];
            
            //link Piece with CheckersPieceView
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackChecker] currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
            [pieceView setPieceInfoWithPiece:regularPiece];
            
            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
            [_currentGame.pieces addObject:pieceView];
        }

//        for (int k = 1; k < 2; k++) {
//            //            CheckersTileView* currentTile = self.boardTilesArr[i][k];
//
//            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
//            //
//            //            currentTile.pieceView = pieceView;
//            //            [currentTile addSubview:pieceView];
//
//            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals whiteRegular] currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
//            [pieceView setPieceInfoWithPiece:regularPiece];
//
//            //            pieceView.center = CGPointMake(currentTile.frame.size.width / 2, currentTile.frame.size.height / 2);
//            [_currentGame.pieces addObject:pieceView];
//        }
    }
}

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

- (NSArray *)getSelectedPieceArr
{
    return _currentGame.selectedPieceArr;
}




#pragma mark - IPieceMovements Members


- (void)handleMoveAndCapture:(TileCoordinates *)coord
{
    if (isInPossibleMoves) {
        [self movePiece:coord];
    }
    else if (isInPossibleEaten) {
        [self movePiece:coord];
        [self capturePiece];
    }
}

- (void)movePiece:(TileCoordinates *)coord
{
//    if ([_currentGame.selectedPieceArr count]>0) {
        SelectedPieceView * lastSelectedPieceView = _currentGame.selectedPieceArr[0];
        for (CheckersPieceView *  pieceView in [_currentGame.pieces copy]) {
            if (pieceView.IndexX == lastSelectedPieceView.indexX && pieceView.IndexY == lastSelectedPieceView.indexY) {
                pieceView.pieceInfo.currentPositionX = clickedPossibleMoves.x;
                pieceView.pieceInfo.currentPositionY = clickedPossibleMoves.y;
                pieceView.IndexX = clickedPossibleMoves.x;
                pieceView.IndexY = clickedPossibleMoves.y;
                [self convertRegularPiece:coord pieceView:pieceView];
                
            }
        }
//    }
    
    
}

- (void)capturePiece
{
    for (CheckersPieceView *  pieceView in [_currentGame.pieces copy]) {
        if (pieceView.IndexX == clickedCapturedPiece.x && pieceView.IndexY == clickedCapturedPiece.y) {
            [_currentGame.pieces removeObject:pieceView];
            //Update whitePiecesArr and blackPiecesArr
            [self blackPiecesCoordinates];
            [self whitePiecesCoordinates];
        }
    }
}



- (void)convertRegularPiece:(TileCoordinates *)clickedPossibleMove pieceView:(CheckersPieceView *)pieceView
{
    //Convert black regular
    if (clickedPossibleMove.y == [Globals NumberOfTilesInXDirection]-1 && pieceView.pieceInfo.sideType == pieceSideBlack) {
        [self createCheckPiece:pieceSideBlack withPieceView:pieceView withImageName:[Globals blackChecker]];
        [_currentGame.pieces removeObject:pieceView];
    }
    //convert white regular
    else if (clickedPossibleMove.y == 0 && pieceView.pieceInfo.sideType == pieceSideWhite){

        [self createCheckPiece:pieceSideWhite withPieceView:pieceView withImageName:[Globals whiteChecker]];
        [_currentGame.pieces removeObject:pieceView];

    }

}

- (void) createCheckPiece:(PlayerSideType )playerSideType withPieceView:(CheckersPieceView *)pieceView withImageName:(NSString *)imageName
{
    CheckersPieceView* newPieceView = [[CheckersPieceView alloc]initWithFrame:pieceView.frame];
    CheckPiece* checkPiece = [[CheckPiece alloc] initWithImageName:imageName currentPositionX:pieceView.IndexX currentPositionY:pieceView.IndexY playerSideType:playerSideType];
    [newPieceView setPieceInfoWithPiece:checkPiece];
    
    newPieceView.IndexX = pieceView.IndexX;
    newPieceView.IndexY = pieceView.IndexY;
    
    [_currentGame.pieces addObject:newPieceView];
    

}

//- (void) createCheckPieceOn:(TileCoordinates *)coord withHeight:(float)height
//{
//    CGRect pieceFrame = CGRectMake(0, 0, height, height);
//    CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
//    
//    RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:coord.x currentPositionY:coord.y playerSideType:pieceSideBlack];
//    [pieceView setPieceInfoWithPiece:regularPiece];
//    [_currentGame.pieces addObject:pieceView];
//    
//}

- (void) createPieceOn:(TileCoordinates *)coord withHeight:(float)height
{
    CGRect pieceFrame = CGRectMake(0, 0, height, height);
    CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
    
    RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:coord.x currentPositionY:coord.y playerSideType:pieceSideBlack];
    [pieceView setPieceInfoWithPiece:regularPiece];
    [_currentGame.pieces addObject:pieceView];
    
}

#pragma mark Piece and cell states


- (void) detectClickedCellStatus:(TileCoordinates *)coord
{
    isClickedWhite = NO;
    isClickedBlack = NO;
    isCheckPieceSelected = NO;
    //Add pieces to whitePiecesArr and blackPiecesArr
    [self blackPiecesCoordinates];
    [self whitePiecesCoordinates];
    
    
    //White clicked
    for (CheckersPieceView *  pieceView in whitePiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            isClickedWhite = YES;
            if ([pieceView.pieceInfo.imageNameStr isEqualToString:[Globals whiteChecker]]) {
                isCheckPieceSelected = YES;
            }
        }
    }
    //Black clicked
    for (CheckersPieceView *  pieceView in blackPiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            isClickedBlack = YES;
            if ([pieceView.pieceInfo.imageNameStr isEqualToString:[Globals blackChecker]]) {
                isCheckPieceSelected = YES;
            }
        }
    }

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


- (void)getCurrentClickedPieceObject:(TileCoordinates *) coord
{
    for (CheckersPieceView * pieceView in _currentGame.pieces) {
        if (pieceView.IndexX == coord.x && pieceView.IndexY == coord.y) {
            clickedPieceView = pieceView;
            clickedPieceView.IndexX = pieceView.IndexX;
            clickedPieceView.IndexY = pieceView.IndexY;
        }
    }
}


- (BOOL)isLegalMove:(TileCoordinates *)coord
{
    isInPossibleMoves = NO;
    isInPossibleEaten = NO;
    
    for (TileCoordinates * posMove in _possibleMoves) {
        if (coord.x == posMove.x && coord.y == posMove.y) {
            clickedPossibleMoves = posMove;
            isInPossibleMoves = YES;
            return YES;
        }
    }
    for (Eatable * eat in _possibleEaten) {
        if (coord.x == eat.coordinateOfPossibleMove.x && coord.y == eat.coordinateOfPossibleMove.y) {
            clickedPossibleMoves = eat.coordinateOfPossibleMove;
            clickedCapturedPiece = eat.coordinatesOfCapturedPiece;
            isInPossibleEaten = YES;
            return YES;
        }
    }
    return NO;
}




#pragma mark Move indicators
- (void)possibleMoveIndicator:(TileCoordinates *) coord withHeight:(float)height
{
    //reset
    [_currentGame.moveSuggestion removeAllObjects];
    
    self.possibleMoves = [[NSMutableArray alloc] init];
    self.possibleEaten = [[NSMutableArray alloc] init];
    
    if (isCheckPieceSelected) {
//        [self checkPiecePossibleMoves:coord withHeight:height];
        [self checkPiecePossibleMoves:coord withHeight:height];

    }
    else{
        [self regularPiecePossibleMoves:coord withHeight:height];
    }
    for (TileCoordinates *  coordinates in self.possibleMoves) {
        [self placePossibleMoveImageOnTile:coordinates withHeight:height];
    }
    //Cycle through coordinateOfPossibleMove
    for (Eatable *  eat in self.possibleEaten) {
        
        [self placePossibleMoveImageOnTile:eat.coordinateOfPossibleMove withHeight:height];
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


- (void)selectedPieceIndicator:(TileCoordinates *) coord withHeight:(float)height
{
    //reset
    [_currentGame.selectedPieceArr removeAllObjects];
    
    
    if ([self isCellOccupied:coord]) {
        //Place selected piece indicator only if it's current player's turn
        if ((isClickedWhite && _currentGame.currentPlayer == _currentGame.whitePlayer) || (isClickedBlack && _currentGame.currentPlayer == _currentGame.blackPlayer)) {
            [self placeSelectedPieceImageOnTile:coord withHeight:height];
        }
    }
}


- (void)placeSelectedPieceImageOnTile:(TileCoordinates *)coord withHeight:(float)height
{
    CGRect selectedPieceFrame = CGRectMake(0, 0, height, height);
    
    SelectedPieceView * selectedPieceView = [[SelectedPieceView alloc] initWithFrame:selectedPieceFrame];
    SelectedPiece * selectedPiece = [[SelectedPiece alloc] initWithCurrentX:coord.x currentY:coord.y imageName:[Globals selectedPiece]];
    [selectedPieceView setSelectedPieceInfoWithPiece:selectedPiece];
    [_currentGame.selectedPieceArr addObject:selectedPieceView];
    
}

- (void)clearIndicatorsWithPossibleEatenAndPossibleMovesArrays:(TileCoordinates *)coord
{
    [_currentGame.selectedPieceArr removeAllObjects];
    [_currentGame.moveSuggestion removeAllObjects];
    [self.possibleEaten removeAllObjects];
    [self.possibleMoves removeAllObjects];
}

#pragma mark - Possible Moves
- (void) checkNorthForRegularPieceMove:(TileCoordinates *) coord
{
    
}


#pragma mark - Piece Movements

- (void)regularPiecePossibleMoves:(TileCoordinates *) coord withHeight:(float)height
{
    float pieceHeight = height * [Globals pieceHeightToTileHeightProportion];
    
    [self getCurrentClickedPieceObject:coord];
    
    if (isClickedWhite && _currentGame.currentPlayer == _currentGame.whitePlayer) {
        
        [self regularPieceMovementNorth:coord];
        [self regularPieceMovementEast:coord];
        [self regularPieceMovementWest:coord];

        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEaten count]>0) {
            [self.possibleMoves removeAllObjects];
        }
        
//        // Set selected piece indicator
//        [self selectedPieceIndicator:coord withHeight:pieceHeight];
        
    }
    else if (isClickedBlack && _currentGame.currentPlayer == _currentGame.blackPlayer) {
        [self regularPieceMovementEast:coord];
        [self regularPieceMovementWest:coord];
        [self regularPieceMovementSouth:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEaten count]>0) {
            [self.possibleMoves removeAllObjects];
        }
    }
}

- (void)checkPiecePossibleMoves:(TileCoordinates *) coord withHeight:(float)height
{
    [self getCurrentClickedPieceObject:coord];
    
    if (isClickedWhite && _currentGame.currentPlayer == _currentGame.whitePlayer) {
        [self checkPieceMovementNorth:coord];
        [self checkPieceMovementSouth:coord];
        [self checkPieceMovementEast:coord];
        [self checkPieceMovementWest:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEaten count]>0) {
            [self.possibleMoves removeAllObjects];
        }
        //        [self regularPieceMovementNorth:coord];
        //        [self regularPieceMovementEast:coord];
        //        [self regularPieceMovementWest:coord];
        
        // Set selected piece indicator
//        float pieceHeight = height * 0.8;
//        [self selectedPieceIndicator:coord withHeight:pieceHeight];
        
        
        //[_currentGame nextTurn];
    }
    else if (isClickedBlack && _currentGame.currentPlayer == _currentGame.blackPlayer) {
        [self checkPieceMovementNorth:coord];
        [self checkPieceMovementSouth:coord];
        [self checkPieceMovementEast:coord];
        [self checkPieceMovementWest:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEaten count]>0) {
            [self.possibleMoves removeAllObjects];
        }
        //        [self regularPieceMovementEast:coord];
        //        [self regularPieceMovementWest:coord];
        //        [self regularPieceMovementSouth:coord];
        
        //        [_currentGame nextTurn];
        
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



//- (void)regularPieceMovementNorthhhh:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.y != 0) {
//        tempCoord.y--;
//        
//        if ([self isCellOccupied:tempCoord]) {
//                            [self.possibleEaten addObject:tempCoord];
//                tempCoord.y--;
//                if (![self isCellOccupied:tempCoord]) {
//                    [self.possibleMoves addObject:tempCoord];
//                }
//            
//
//        }
//        // if north of the clicked cell is empty
//        else
//        {
//            [self.possibleMoves addObject:tempCoord];
//
//        }
//    }
//}


//- (void)regularPieceMovementNorth:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.y != 0) {
//        tempCoord.y--;
//        [self.possibleMoves addObject:tempCoord];
//    }
//    
//}

- (void)checkPieceMovementNorth:(TileCoordinates *) coord
{
    TileCoordinates * coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates * possibleEatablePieceCoord;
    TileCoordinates * possibleEatenMove;
    int edibleCounter = 0;
    
    if (coords.y != 0) {
        coords.y--;
        while (coords.y>=0) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    //[self.possibleEaten removeAllObjects];
                    return;
                }
                for (CheckersPieceView * pieceView in _currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                            possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                            edibleCounter++;
                        }
                        else { // if first closest piece's side is same with player's side
                            return;
                        }
                    }
                }
            }
            else if (edibleCounter == 0) { //cell is empty and there isnt any piece yet
                TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMoves addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEaten addObject:possibleEatenAndMove];
                [self.possibleMoves removeAllObjects];
            }
            coords.y--;
        }//while
    }
}


- (void)regularPieceMovementNorth:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.y != 0) {
        tempCoord.y--;
        for (CheckersPieceView * pieceView in _currentGame.pieces) {
            NSLog(@"%d,%d",pieceView.IndexX,pieceView.IndexY);
            //Check if north of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.y != 1) {
                //Check if north's side is same with clickedPiece, if it's different, and if the next north cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates * possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.y--;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEaten addObject:possibleEatenAndMove];
                        
                        //return;
                    }
                    //Back to previous position
                    tempCoord.y++;
                }
            }
            // if north of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]){
                [self.possibleMoves addObject:tempCoord];
                return;
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

- (void)checkPieceMovementSouth:(TileCoordinates *) coord
{
    TileCoordinates * coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates * possibleEatablePieceCoord;
    TileCoordinates * possibleEatenMove;
    int edibleCounter = 0;
    
    if (coord.y != [Globals NumberOfTilesInXDirection]-1) {
        coords.y++;
        while (coords.y<=[Globals NumberOfTilesInXDirection]-1) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    //[self.possibleEaten removeAllObjects];
                    return;
                }
                for (CheckersPieceView * pieceView in _currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                            possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                            edibleCounter++;
                        }
                        else { // if first closest piece's side is same with player's side
                            return;
                        }
                    }
                }
            }
            else if (edibleCounter == 0) { //cell is empty and there isnt any piece yet
                TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMoves addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEaten addObject:possibleEatenAndMove];
                [self.possibleMoves removeAllObjects];
            }
            coords.y++;
        }//while
    }
}

- (void)regularPieceMovementSouth:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.y != [Globals NumberOfTilesInXDirection]-1) {
        tempCoord.y++;
        for (CheckersPieceView * pieceView in _currentGame.pieces) {
            NSLog(@"%d,%d",pieceView.IndexX,pieceView.IndexY);
            //Check if south of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.y != [Globals NumberOfTilesInXDirection]-2) {
                //Check if south's side is same with clickedPiece, if it's different, and if the next south cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates * possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.y++;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEaten addObject:possibleEatenAndMove];
                        
                        //return;
                    }
                    //Back to previous position
                    tempCoord.y--;
                }
            }
            // if south of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]){
                [self.possibleMoves addObject:tempCoord];
                return;
            }
        }
    }
    
}

//- (void)regularPieceMovementEast:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.x != [Globals NumberOfTilesInXDirection]-1) {
//        tempCoord.x++;
//        [self.possibleMoves addObject:tempCoord];
//    }
//    
//}

- (void)checkPieceMovementEast:(TileCoordinates *) coord
{
    TileCoordinates * coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates * possibleEatablePieceCoord;
    TileCoordinates * possibleEatenMove;
    int edibleCounter = 0;
    
    if (coord.x != [Globals NumberOfTilesInXDirection]-1) {
        coords.x++;
        while (coords.x<=[Globals NumberOfTilesInXDirection]-1) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    //[self.possibleEaten removeAllObjects];
                    return;
                }
                for (CheckersPieceView * pieceView in _currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                            possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                            edibleCounter++;
                        }
                        else { // if first closest piece's side is same with player's side
                            return;
                        }
                    }
                }
            }
            else if (edibleCounter == 0) { //cell is empty and there isnt any piece yet
                TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMoves addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEaten addObject:possibleEatenAndMove];
                [self.possibleMoves removeAllObjects];
            }
            coords.x++;
        }//while
    }
}


- (void)regularPieceMovementEast:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.x != [Globals NumberOfTilesInXDirection]-1) {
        tempCoord.x++;
        for (CheckersPieceView * pieceView in _currentGame.pieces) {
            NSLog(@"%d,%d",pieceView.IndexX,pieceView.IndexY);
            //Check if east of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.x != [Globals NumberOfTilesInXDirection]-2) {
                //Check if east's side is same with clickedPiece, if it's different, and if the next south cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates * possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.x++;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEaten addObject:possibleEatenAndMove];
                        
                        //return;
                    }
                    //Back to previous position
                    tempCoord.x--;
                }
            }
            // if east of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]){
                [self.possibleMoves addObject:tempCoord];
                return;
            }
        }
    }

}

//- (void)regularPieceMovementWest:(TileCoordinates *) coord
//{
//    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
//    if (tempCoord.x != 0) {
//        tempCoord.x--;
//        [self.possibleMoves addObject:tempCoord];
//    }
//    
//}

- (void)checkPieceMovementWest:(TileCoordinates *) coord
{
    TileCoordinates * coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates * possibleEatablePieceCoord;
    TileCoordinates * possibleEatenMove;
    int edibleCounter = 0;
    
    if (coords.x != 0) {
        coords.x--;
        while (coords.x>=0) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    //[self.possibleEaten removeAllObjects];
                    return;
                }
                for (CheckersPieceView * pieceView in _currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                            possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                            edibleCounter++;
                        }
                        else { // if first closest piece's side is same with player's side
                            return;
                        }
                    }
                }
            }
            else if (edibleCounter == 0) { //cell is empty and there isnt any piece yet
                TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMoves addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEaten addObject:possibleEatenAndMove];
                [self.possibleMoves removeAllObjects];
            }
            coords.x--;
        }//while
    }
}


- (void)regularPieceMovementWest:(TileCoordinates *) coord
{
    TileCoordinates * tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.x != 0) {
        tempCoord.x--;
        for (CheckersPieceView * pieceView in _currentGame.pieces) {
            NSLog(@"%d,%d",pieceView.IndexX,pieceView.IndexY);
            //Check if west of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.x != 1) {
                //Check if west's side is same with clickedPiece, if it's different, and if the next north cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates * possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];;
                    tempCoord.x--;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable * possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEaten addObject:possibleEatenAndMove];
                        
                        //return;
                    }
                    //Back to previous position
                    tempCoord.x++;
                }
            }
            // if west of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]){
                [self.possibleMoves addObject:tempCoord];
                return;
            }
        }
    }
    

}




@end
