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

@property (nonatomic) UIImageView *suggestImageView;
@property (nonatomic) UIImage *suggestImage;
@property (nonatomic) CheckersPieceView *clickedPieceView;
@property (nonatomic) TileCoordinates *clickedPossibleMoves;
@property (nonatomic) TileCoordinates *clickedCapturedPiece;
@property (nonatomic) Game *currentGame;

@property (strong, nonatomic) NSMutableArray *boardTilesArr;
@property (strong, nonatomic) NSMutableArray *possibleMovesArr;
@property (strong, nonatomic) NSMutableArray *possibleEatenArr;
@property (strong, nonatomic) NSMutableArray *blackPiecesArr;
@property (strong, nonatomic) NSMutableArray *whitePiecesArr;

@property (assign, nonatomic) BOOL isClickedWhite;
@property (assign, nonatomic) BOOL isClickedBlack;
@property (assign, nonatomic) BOOL isCheckPieceSelected;
@property (assign, nonatomic) BOOL isInPossibleMoves;
@property (assign, nonatomic) BOOL isInPossibleEaten;
@property (assign, nonatomic) BOOL isCheckingNextPossibleEatableMove;

@property (assign, nonatomic) BOOL isEligibleForNextEdibleMove;
//isInPossibleMoveAndNextEligiblePossibleMove
//isEligibleToMove

@end

@implementation GameEngine

- (NSMutableArray*)possibleMovesArr
{
    if (!_possibleMovesArr) {
        _possibleMovesArr = [[NSMutableArray alloc] init];
    }
    return _possibleMovesArr;
}

- (NSMutableArray*)possibleEatenArr
{
    if (!_possibleEatenArr) {
        _possibleEatenArr = [[NSMutableArray alloc] init];
    }
    return _possibleEatenArr;
}

#pragma mark Singleton
__strong static id _sharedObject = nil;
+ (GameEngine*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/* IGameState Members  */
#pragma mark - IGameState Members

- (void)startNewGameWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer withTileHeight:(float)tileHeight withPieceHeight:(float)pieceHeight
{
    whitePlayer.currentPoint = 0;
    blackPlayer.currentPoint = 0;
    _currentGame = [[Game alloc] initWithWhitePlayer:whitePlayer withBlackPlayer:blackPlayer];
    
    [self generateTilesWithTileHeight:tileHeight];
    [self generatePiecesWithHeight:pieceHeight];
}

- (void)nextTurn
{
    [_currentGame nextTurn];
}

- (NSString*)endGame
{
    if (self.whitePiecesArr.count == 0) {
        return @"Black wins";
    }
    else if (self.blackPiecesArr.count == 0) {
        return @"White wins";
    }
    return @"";
}

/* ISetupBoard Members  */
#pragma mark - ISetupBoard Members

- (void)generateTilesWithTileHeight:(float)tileHeight
{
    for (int row = 0; row < [Globals NumberOfTilesInXDirection]; row++) {
        for (int col = 0; col < [Globals NumberOfTilesInYDirection]; col++) {
            CheckersTileView* tileView = [[CheckersTileView alloc] initWithFrame:CGRectMake(col * tileHeight, row * tileHeight, tileHeight, tileHeight)];
            
            if ((col + row) % 2 == 1) {
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Globals whiteBoardSquare]]];
            }
            else {
                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Globals brownBoardSquare]]];
            }
            
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
            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            //link Piece with CheckersPieceView
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals blackRegular] currentPositionX:i currentPositionY:j playerSideType:pieceSideBlack];
            [pieceView setPieceInfoWithPiece:regularPiece];
            [_currentGame.pieces addObject:pieceView];
        }
        
        for (int k = 5; k < 7; k++) {
            CheckersPieceView* pieceView = [[CheckersPieceView alloc] initWithFrame:pieceFrame];
            RegularPiece* regularPiece = [[RegularPiece alloc] initWithImageName:[Globals whiteRegular] currentPositionX:i currentPositionY:k playerSideType:pieceSideWhite];
            [pieceView setPieceInfoWithPiece:regularPiece];
            [_currentGame.pieces addObject:pieceView];
        }
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

- (NSArray*)getSelectedPieceArr
{
    return _currentGame.selectedPieceArr;
}

#pragma mark - IPieceMovements Members

- (void)handleMoveAndCapture:(TileCoordinates*)coord
{
    if (self.isInPossibleMoves) {
        [self movePiece:coord];
    }
    else if (self.isInPossibleEaten) {
        [self movePiece:coord];
        [self capturePiece];
    }
}

- (void)movePiece:(TileCoordinates*)coord
{
    SelectedPieceView* lastSelectedPieceView = _currentGame.selectedPieceArr[0];
    for (CheckersPieceView* pieceView in [_currentGame.pieces copy]) {
        if (pieceView.IndexX == lastSelectedPieceView.indexX && pieceView.IndexY == lastSelectedPieceView.indexY) {
            pieceView.pieceInfo.currentPositionX = self.clickedPossibleMoves.x;
            pieceView.pieceInfo.currentPositionY = self.clickedPossibleMoves.y;
            pieceView.IndexX = self.clickedPossibleMoves.x;
            pieceView.IndexY = self.clickedPossibleMoves.y;
            [self convertRegularPieceToCheckPiece:coord pieceView:pieceView];
        }
    }
}

- (void)capturePiece
{
    for (CheckersPieceView* pieceView in [_currentGame.pieces copy]) {
        if (pieceView.IndexX == self.clickedCapturedPiece.x && pieceView.IndexY == self.clickedCapturedPiece.y) {
            [_currentGame.pieces removeObject:pieceView];
            //Update whitePiecesArr and blackPiecesArr
            [self fillBlackPiecesArr];
            [self fillWhitePiecesArr];
        }
    }
}

- (void)convertRegularPieceToCheckPiece:(TileCoordinates*)clickedPossibleMove pieceView:(CheckersPieceView*)pieceView
{
    //Convert black regular
    if (clickedPossibleMove.y == [Globals NumberOfTilesInXDirection] - 1 && pieceView.pieceInfo.sideType == pieceSideBlack) {
        [self createCheckPiece:pieceSideBlack withPieceView:pieceView withImageName:[Globals blackChecker]];
        [_currentGame.pieces removeObject:pieceView];
    }
    //convert white regular
    else if (clickedPossibleMove.y == 0 && pieceView.pieceInfo.sideType == pieceSideWhite) {
        [self createCheckPiece:pieceSideWhite withPieceView:pieceView withImageName:[Globals whiteChecker]];
        [_currentGame.pieces removeObject:pieceView];
    }
}

- (void)createCheckPiece:(PlayerSideType)playerSideType withPieceView:(CheckersPieceView*)pieceView withImageName:(NSString*)imageName
{
    CheckersPieceView* newPieceView = [[CheckersPieceView alloc] initWithFrame:pieceView.frame];
    CheckPiece* checkPiece = [[CheckPiece alloc] initWithImageName:imageName currentPositionX:pieceView.IndexX currentPositionY:pieceView.IndexY playerSideType:playerSideType];
    [newPieceView setPieceInfoWithPiece:checkPiece];
    
    newPieceView.IndexX = pieceView.IndexX;
    newPieceView.IndexY = pieceView.IndexY;
    
    [_currentGame.pieces addObject:newPieceView];
}

#pragma mark Piece and cell states

- (void)detectClickedCellStatus:(TileCoordinates*)coord
{
    self.isClickedWhite = NO;
    self.isClickedBlack = NO;
    self.isCheckPieceSelected = NO;
    self.isInPossibleMoves = NO;
    self.isInPossibleEaten = NO;
    //Add pieces to whitePiecesArr and blackPiecesArr
    [self fillBlackPiecesArr];
    [self fillWhitePiecesArr];
    
    //White clicked
    for (CheckersPieceView* pieceView in self.whitePiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            self.isClickedWhite = YES;
            if ([pieceView.pieceInfo.imageNameStr isEqualToString:[Globals whiteChecker]]) {
                self.isCheckPieceSelected = YES;
            }
        }
    }
    //Black clicked
    for (CheckersPieceView* pieceView in self.blackPiecesArr) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            self.isClickedBlack = YES;
            if ([pieceView.pieceInfo.imageNameStr isEqualToString:[Globals blackChecker]]) {
                self.isCheckPieceSelected = YES;
            }
        }
    }
}

- (void)fillWhitePiecesArr
{
    self.whitePiecesArr = [[NSMutableArray alloc] init];
    for (CheckersPieceView* pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideWhite) {
            [self.whitePiecesArr addObject:pieceView];
        }
    }
}

- (void)fillBlackPiecesArr
{
    self.blackPiecesArr = [[NSMutableArray alloc] init];
    for (CheckersPieceView* pieceView in _currentGame.pieces) {
        if (pieceView.pieceInfo.sideType == pieceSideBlack) {
            [self.blackPiecesArr addObject:pieceView];
        }
    }
}

- (void)setCurrentClickedPieceObject:(TileCoordinates*)coord
{
    for (CheckersPieceView* pieceView in _currentGame.pieces) {
        if (pieceView.IndexX == coord.x && pieceView.IndexY == coord.y) {
            self.clickedPieceView = pieceView;
            self.clickedPieceView.IndexX = pieceView.IndexX;
            self.clickedPieceView.IndexY = pieceView.IndexY;
        }
    }
}

- (BOOL)isLegalMove:(TileCoordinates*)coord
{
    for (TileCoordinates* posMove in self.possibleMovesArr) {
        if (coord.x == posMove.x && coord.y == posMove.y) {
            self.clickedPossibleMoves = posMove;
            self.isInPossibleMoves = YES;
            self.isEligibleForNextEdibleMove = NO;
            return YES;
        }
    }
    for (Eatable* eat in self.possibleEatenArr) {
        if (coord.x == eat.coordinateOfPossibleMove.x && coord.y == eat.coordinateOfPossibleMove.y) {
            self.clickedPossibleMoves = eat.coordinateOfPossibleMove;
            self.clickedCapturedPiece = eat.coordinatesOfCapturedPiece;
            self.isInPossibleEaten = YES;
            self.isEligibleForNextEdibleMove = YES;
            return YES;
        }
    }
    self.isEligibleForNextEdibleMove = YES;
    return NO;
}

#pragma mark Move indicators

- (void)calculatePossibleMovesWithMoveSuggestionIndicator:(TileCoordinates*)coord withHeight:(float)height isCheckingNextEdiblePossibleMoves:(BOOL)isChecking
{
    //reset
    [_currentGame.moveSuggestion removeAllObjects];
    
    self.possibleMovesArr = [[NSMutableArray alloc] init];
    self.possibleEatenArr = [[NSMutableArray alloc] init];
    
    if (self.isCheckPieceSelected) {
        [self makeCheckPiecePossibleMoves:coord withHeight:height];
    }
    else { //Regular piece selected
        [self makeRegularPiecePossibleMoves:coord withHeight:height];
    }
    //If isEligibleForNextEdibleMove false, which means that possibleEatenArr is empty
    //and possibleMovesArr has elements in it. Having only possibleMovesArr has element prevents player to move again
    if ((self.isEligibleForNextEdibleMove)) {
        for (Eatable* eat in self.possibleEatenArr) {
            [self placePossibleMoveImageOnTile:eat.coordinateOfPossibleMove withHeight:height];
        }
    }
    else
    {
        [self.possibleEatenArr removeAllObjects];
    }
    
    //If we are checking next possible edible move, we dont need to check possible moves
    if (!isChecking) {
        for (TileCoordinates* coordinates in self.possibleMovesArr) {
            [self placePossibleMoveImageOnTile:coordinates withHeight:height];
        }
    }
}

- (BOOL)isPossibleEatenArrayEmpty
{
    if ([self.possibleEatenArr count] > 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)placePossibleMoveImageOnTile:(TileCoordinates*)coord withHeight:(float)height
{
    CGRect suggestionFrame = CGRectMake(0, 0, height, height);
    
    SuggestionView* suggestionView = [[SuggestionView alloc] initWithFrame:suggestionFrame];
    Suggestion* suggest = [[Suggestion alloc] initWithCurrentX:coord.x currentY:coord.y imageName:[Globals suggest]];
    [suggestionView setSuggestionInfoWithSuggestion:suggest];
    [self.currentGame.moveSuggestion addObject:suggestionView];
}

- (void)setSelectedPieceIndicator:(TileCoordinates*)coord withHeight:(float)height
{
    //reset
    [self.currentGame.selectedPieceArr removeAllObjects];
    
    if ([self isCellOccupied:coord]) {
        //Place selected piece indicator only if it's current player's turn
        if ((self.isClickedWhite && self.currentGame.currentPlayer == self.currentGame.whitePlayer) || (self.isClickedBlack && self.currentGame.currentPlayer == self.currentGame.blackPlayer)) {
            [self placeSelectedPieceImageOnTile:coord withHeight:height];
        }
    }
}

- (void)placeSelectedPieceImageOnTile:(TileCoordinates*)coord withHeight:(float)height
{
    CGRect selectedPieceFrame = CGRectMake(0, 0, height, height);
    
    SelectedPieceView* selectedPieceView = [[SelectedPieceView alloc] initWithFrame:selectedPieceFrame];
    SelectedPiece* selectedPiece = [[SelectedPiece alloc] initWithCurrentX:coord.x currentY:coord.y imageName:[Globals selectedPiece]];
    [selectedPieceView setSelectedPieceInfoWithPiece:selectedPiece];
    [self.currentGame.selectedPieceArr addObject:selectedPieceView];
}

- (void)clearIndicatorsAndArrays
{
    [self.currentGame.selectedPieceArr removeAllObjects];
    [self.currentGame.moveSuggestion removeAllObjects];
    [self.possibleEatenArr removeAllObjects];
    [self.possibleMovesArr removeAllObjects];
}

#pragma mark - Piece Movements
- (void)makeRegularPiecePossibleMoves:(TileCoordinates*)coord withHeight:(float)height
{
    [self setCurrentClickedPieceObject:coord];
    
    if (self.isClickedWhite && self.currentGame.currentPlayer == self.currentGame.whitePlayer) {
        [self calculateRegularPieceMovementNorth:coord];
        [self calculateRegularPieceMovementEast:coord];
        [self calculateRegularPieceMovementWest:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEatenArr count] > 0) {
            [self.possibleMovesArr removeAllObjects];
        }
     }
    else if (self.isClickedBlack && self.currentGame.currentPlayer == self.currentGame.blackPlayer) {
        [self calculateRegularPieceMovementEast:coord];
        [self calculateRegularPieceMovementWest:coord];
        [self calculateRegularPieceMovementSouth:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEatenArr count] > 0) {
            [self.possibleMovesArr removeAllObjects];
        }
    }
}

- (void)makeCheckPiecePossibleMoves:(TileCoordinates*)coord withHeight:(float)height
{
    [self setCurrentClickedPieceObject:coord];
    
    if (self.isClickedWhite && self.currentGame.currentPlayer == self.currentGame.whitePlayer) {
        [self calculateCheckPieceMovementNorth:coord];
        [self calculateCheckPieceMovementSouth:coord];
        [self calculateCheckPieceMovementEast:coord];
        [self calculateCheckPieceMovementWest:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEatenArr count] > 0) {
            [self.possibleMovesArr removeAllObjects];
        }
    }
    else if (self.isClickedBlack && self.currentGame.currentPlayer == self.currentGame.blackPlayer) {
        [self calculateCheckPieceMovementNorth:coord];
        [self calculateCheckPieceMovementSouth:coord];
        [self calculateCheckPieceMovementEast:coord];
        [self calculateCheckPieceMovementWest:coord];
        //if edible piece is found, remove all objects in possibleMoves array that may be found in other directions
        if ([self.possibleEatenArr count] > 0) {
            [self.possibleMovesArr removeAllObjects];
        }
    }
}

- (BOOL)isCellOccupied:(TileCoordinates*)coord
{
    for (CheckersPieceView* pieceView in self.currentGame.pieces) {
        if (coord.x == pieceView.IndexX && coord.y == pieceView.IndexY) {
            return YES;
        }
    }
    return NO;
}

- (void)calculateCheckPieceMovementNorth:(TileCoordinates*)coord
{
    TileCoordinates* coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates* possibleEatablePieceCoord;
    TileCoordinates* possibleEatenMove;
    int edibleCounter = 0;
    
    if (coords.y != 0) {
        coords.y--;
        while (coords.y >= 0) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    return;
                }
                for (CheckersPieceView* pieceView in self.currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
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
                TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMovesArr addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEatenArr addObject:possibleEatenAndMove];
                [self.possibleMovesArr removeAllObjects];
            }
            coords.y--;
        } //while
    }
}

- (void)calculateRegularPieceMovementNorth:(TileCoordinates*)coord
{
    TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.y != 0) {
        tempCoord.y--;
        for (CheckersPieceView* pieceView in self.currentGame.pieces) {
            //Check if north of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.y != 1) {
                //Check if north's side is same with clickedPiece, if it's different, and if the next north cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates* possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.y--;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEatenArr addObject:possibleEatenAndMove];
                    }
                    //Back to previous position
                    tempCoord.y++;
                }
            }
            // if north of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]) {
                [self.possibleMovesArr addObject:tempCoord];
                return;
            }
        }
    }
}

- (void)calculateCheckPieceMovementSouth:(TileCoordinates*)coord
{
    TileCoordinates* coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates* possibleEatablePieceCoord;
    TileCoordinates* possibleEatenMove;
    int edibleCounter = 0;
    
    if (coord.y != [Globals NumberOfTilesInXDirection] - 1) {
        coords.y++;
        while (coords.y <= [Globals NumberOfTilesInXDirection] - 1) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    return;
                }
                for (CheckersPieceView* pieceView in self.currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
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
                TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMovesArr addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEatenArr addObject:possibleEatenAndMove];
                [self.possibleMovesArr removeAllObjects];
            }
            coords.y++;
        } //while
    }
}

- (void)calculateRegularPieceMovementSouth:(TileCoordinates*)coord
{
    TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.y != [Globals NumberOfTilesInXDirection] - 1) {
        tempCoord.y++;
        for (CheckersPieceView* pieceView in self.currentGame.pieces) {
            //Check if south of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.y != [Globals NumberOfTilesInXDirection] - 2) {
                //Check if south's side is same with clickedPiece, if it's different, and if the next south cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates* possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.y++;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEatenArr addObject:possibleEatenAndMove];
                    }
                    //Back to previous position
                    tempCoord.y--;
                }
            }
            // if south of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]) {
                [self.possibleMovesArr addObject:tempCoord];
                return;
            }
        }
    }
}

- (void)calculateCheckPieceMovementEast:(TileCoordinates*)coord
{
    TileCoordinates* coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates* possibleEatablePieceCoord;
    TileCoordinates* possibleEatenMove;
    int edibleCounter = 0;
    
    if (coord.x != [Globals NumberOfTilesInXDirection] - 1) {
        coords.x++;
        while (coords.x <= [Globals NumberOfTilesInXDirection] - 1) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    return;
                }
                for (CheckersPieceView* pieceView in self.currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
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
                TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMovesArr addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEatenArr addObject:possibleEatenAndMove];
                [self.possibleMovesArr removeAllObjects];
            }
            coords.x++;
        } //while
    }
}

- (void)calculateRegularPieceMovementEast:(TileCoordinates*)coord
{
    TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.x != [Globals NumberOfTilesInXDirection] - 1) {
        tempCoord.x++;
        for (CheckersPieceView* pieceView in self.currentGame.pieces) {
            //Check if east of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.x != [Globals NumberOfTilesInXDirection] - 2) {
                //Check if east's side is same with clickedPiece, if it's different, and if the next south cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates* possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    tempCoord.x++;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEatenArr addObject:possibleEatenAndMove];
                    }
                    //Back to previous position
                    tempCoord.x--;
                }
            }
            // if east of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]) {
                [self.possibleMovesArr addObject:tempCoord];
                return;
            }
        }
    }
}

- (void)calculateCheckPieceMovementWest:(TileCoordinates*)coord
{
    TileCoordinates* coords = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    TileCoordinates* possibleEatablePieceCoord;
    TileCoordinates* possibleEatenMove;
    int edibleCounter = 0;
    
    if (coords.x != 0) {
        coords.x--;
        while (coords.x >= 0) {
            //Check if cell is occupied, if it is, check side and if side is opposite, add that cell to possibleEatablePieceCoord
            if ([self isCellOccupied:coords]) {
                if (edibleCounter != 0) {
                    return;
                }
                for (CheckersPieceView* pieceView in self.currentGame.pieces) {
                    if (pieceView.IndexX == coords.x && pieceView.IndexY == coords.y) {
                        //if clicked cell's side is different, add that coord to possibleEaten
                        if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
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
                TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                [self.possibleMovesArr addObject:tempCoord];
            }
            else if (edibleCounter == 1) { //cell is empty and there were found a piece
                possibleEatenMove = [[TileCoordinates alloc] initWithX:coords.x withY:coords.y];
                Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:possibleEatenMove];
                [self.possibleEatenArr addObject:possibleEatenAndMove];
                [self.possibleMovesArr removeAllObjects];
            }
            coords.x--;
        } //while
    }
}

- (void)calculateRegularPieceMovementWest:(TileCoordinates*)coord
{
    TileCoordinates* tempCoord = [[TileCoordinates alloc] initWithX:coord.x withY:coord.y];
    if (coord.x != 0) {
        tempCoord.x--;
        for (CheckersPieceView* pieceView in self.currentGame.pieces) {
            //Check if west of clicked cell is in pieces array and is in eligible position on board
            if (pieceView.IndexX == tempCoord.x && pieceView.IndexY == tempCoord.y && coord.x != 1) {
                //Check if west's side is same with clickedPiece, if it's different, and if the next north cell is empty,
                //then add possibleEatablePieceCoord and tempCoord to possibleEaten array
                if (pieceView.pieceInfo.sideType != self.clickedPieceView.pieceInfo.sideType) {
                    TileCoordinates* possibleEatablePieceCoord = [[TileCoordinates alloc] initWithX:tempCoord.x withY:tempCoord.y];
                    ;
                    tempCoord.x--;
                    if (![self isCellOccupied:tempCoord]) {
                        Eatable* possibleEatenAndMove = [[Eatable alloc] initWithCapturedPiece:possibleEatablePieceCoord possibleMoves:tempCoord];
                        [self.possibleEatenArr addObject:possibleEatenAndMove];
                    }
                    //Back to previous position
                    tempCoord.x++;
                }
            }
            // if west of the clicked cell is empty, add
            else if (![self isCellOccupied:tempCoord]) {
                [self.possibleMovesArr addObject:tempCoord];
                return;
            }
        }
    }
}
@end
