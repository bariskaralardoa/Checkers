//
//  CheckersViewController.m
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersViewController.h"
#import "MainMenuViewController.h"
#import "ISetupBoard.h"
#import "IGameState.h"
#import "IPieceMovements.h"
#import "GameEngine.h"
#import "Globals.h"
#import "TileCoordinates.h"
#import "Suggestion.h"
#import "SuggestionView.h"
#import "SelectedPieceView.h"

@interface CheckersViewController ()

@property id <ISetupBoard> boardSetupEngine;
@property id <IGameState> gameStateEngine;
@property id <IPieceMovements> pieceMovementsEngine;

@property (strong, nonatomic) NSArray* currentPieces;
@property (strong, nonatomic) NSArray* currentMoveSuggestion;
@property (strong, nonatomic) NSArray* currentSelectedPiece;
@property (nonatomic) TileCoordinates * clickedCoordinate;

@property (assign, nonatomic) float pieceHeight;
@property (assign, nonatomic) BOOL isPieceMustMove;

@end

@implementation CheckersViewController

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (instancetype)initWithGameEngine:(GameEngine*)engine
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup player properties on screen
    self.whitePlayerLabel.text = self.whitePlayerInfo.name;
    self.whitePlayerPointLabel.text = [NSString stringWithFormat:@"%@",self.whitePlayerInfo.wins];
    self.blackPlayerLabel.text = self.blackPlayerInfo.name;
    self.blackPlayerPointLabel.text = [NSString stringWithFormat:@"%@",self.blackPlayerInfo.wins];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    PlayerInGame* blackPlayer = [[PlayerInGame alloc] initWithPlayerInfo:self.blackPlayerInfo];
    PlayerInGame* whitePlayer = [[PlayerInGame alloc] initWithPlayerInfo:self.whitePlayerInfo];
    
    self.boardSetupEngine = [GameEngine sharedInstance];
    self.gameStateEngine = [GameEngine sharedInstance];
    self.pieceMovementsEngine = [GameEngine sharedInstance];
    
    float tileHeight = _boardViewOnController.frame.size.width / [Globals NumberOfTilesInXDirection];
    self.pieceHeight = tileHeight * [Globals pieceHeightToTileHeightProportion];
    
    [self.gameStateEngine startNewGameWithWhitePlayer:whitePlayer withBlackPlayer:blackPlayer withTileHeight:tileHeight withPieceHeight:self.pieceHeight];
    
    [self RenderTiles:[self.boardSetupEngine getTiles]];
    [self RenderPieces:[self.boardSetupEngine getPieces] withTileArray:[self.boardSetupEngine getTiles]];
    
    [self addGestureRecognizer];
}

- (void)RenderTiles:(NSArray*)tiles
{
    for (int row = 0; row < [Globals NumberOfTilesInXDirection]; row++) {
        for (int col = 0; col < [Globals NumberOfTilesInYDirection]; col++) {
            [self.boardViewOnController addSubview:tiles[row][col]];
        }
    }
}

- (void)RenderPieces:(NSArray*)pieces withTileArray:(NSArray*)tiles
{
    [self.currentPieces makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (CheckersPieceView* pieceView in pieces) {
        CheckersTileView* tileToPlace = tiles[pieceView.IndexY][pieceView.IndexX];
        tileToPlace.pieceView = pieceView;
        
        [tileToPlace addSubview:pieceView];
        pieceView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
    }
    self.currentPieces = [pieces copy];
}

- (void)RenderMoveSuggestion:(NSArray*)moveSuggestion withTileArray:(NSArray*)tiles
{
    [self.currentMoveSuggestion makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (SuggestionView* suggestionView in moveSuggestion) {
        CheckersTileView* tileToPlace = tiles[suggestionView.indexY][suggestionView.indexX];
        tileToPlace.suggestionView = suggestionView;
        
        [tileToPlace addSubview:suggestionView];
        suggestionView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
    }
    self.currentMoveSuggestion = [moveSuggestion copy];
}

- (void)RenderSelectedPiece:(NSArray*)selectedPiece withTileArray:(NSArray*)tiles
{
    [self.currentSelectedPiece makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (SelectedPieceView* selectedPieceView in selectedPiece) {
        CheckersTileView* tileToPlace = tiles[selectedPieceView.indexY][selectedPieceView.indexX];
        tileToPlace.selectedPieceView = selectedPieceView;
        
        [tileToPlace addSubview:selectedPieceView];
        selectedPieceView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
    }
    self.currentSelectedPiece = [selectedPiece copy];
}

#pragma mark - Touch functions

- (void)addGestureRecognizer
{
    [self.boardViewOnController addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardViewTapped:) ]];
}

-(void) boardViewTapped: (UIGestureRecognizer *) recognizer
{
    CGPoint touchPoint = [recognizer locationInView:_boardViewOnController];
    
    float tileHeight = _boardViewOnController.frame.size.width / [Globals NumberOfTilesInXDirection];
    
    self.clickedCoordinate = [[TileCoordinates alloc] initWithX:floor(touchPoint.x/tileHeight) withY:floor(touchPoint.y/tileHeight)];
    
    [self.pieceMovementsEngine detectClickedCellStatus:self.clickedCoordinate];
    
    //Check if clicked in range of possibleMoves or possibleEaten arrays
    if ([self.pieceMovementsEngine isLegalMove:self.clickedCoordinate]) {
        self.isPieceMustMove = NO;
        [self.pieceMovementsEngine handleMoveAndCapture:self.clickedCoordinate];
        [self RenderPieces:[self.boardSetupEngine getPieces] withTileArray:[self.boardSetupEngine getTiles]]; // Bu da pieceleri generate edicek.
        
        //Clear indicators and empty array
        [self.pieceMovementsEngine clearIndicatorsAndArrays];
        
        //Check again for edible possible next move
        [self.pieceMovementsEngine detectClickedCellStatus:self.clickedCoordinate];
        
        [self.pieceMovementsEngine calculatePossibleMovesWithMoveSuggestionIndicator:self.clickedCoordinate withHeight:tileHeight isCheckingNextEdiblePossibleMoves:YES];
        [self RenderMoveSuggestion:[self.pieceMovementsEngine getMoveSuggestion] withTileArray:[self.boardSetupEngine getTiles]];
        
        [self.pieceMovementsEngine setSelectedPieceIndicator:self.clickedCoordinate withHeight:self.pieceHeight];
        
        //Next turn if possibleEaten array is empty,
        //Same player continues if possibleEaten has elements
        if ([self.pieceMovementsEngine isPossibleEatenArrayEmpty]) {
            [self.pieceMovementsEngine clearIndicatorsAndArrays];
            [self.gameStateEngine nextTurn];
            [self changActivePlayerLabelImage];
            [self checkEndGame];
        }
        else
        {
            self.isPieceMustMove = YES;
        }
        
        [self RenderSelectedPiece:[self.pieceMovementsEngine getSelectedPieceArr] withTileArray:[self.boardSetupEngine getTiles]];
    }
    else if (self.isPieceMustMove)
    {
        //This prevents player to click on another cell while player must continue playing
    }
    else
    {
        //Move suggestion
        [self.pieceMovementsEngine calculatePossibleMovesWithMoveSuggestionIndicator:self.clickedCoordinate withHeight:tileHeight isCheckingNextEdiblePossibleMoves:NO];
        [self RenderMoveSuggestion:[self.pieceMovementsEngine getMoveSuggestion] withTileArray:[self.boardSetupEngine getTiles]];
        
        //Selected piece
        [self.pieceMovementsEngine setSelectedPieceIndicator:self.clickedCoordinate withHeight:self.pieceHeight];
        [self RenderSelectedPiece:[self.pieceMovementsEngine getSelectedPieceArr] withTileArray:[self.boardSetupEngine getTiles]];
    }
}

- (void)checkEndGame
{
    if ([[self.gameStateEngine endGame] isEqualToString:@"White wins"]) {
        int whiteWinsCount = [self.whitePlayerInfo.wins intValue];
        self.whitePlayerInfo.wins = [NSNumber numberWithInt:whiteWinsCount + 1];
        [self saveNoOfWins];
        [self alertView:[NSString stringWithFormat:@"%@ wins",self.whitePlayerInfo.name]];
        
    }
    else if ([[self.gameStateEngine endGame] isEqualToString:@"Black wins"]) {
        int whiteWinsCount = [self.blackPlayerInfo.wins intValue];
        self.blackPlayerInfo.wins = [NSNumber numberWithInt:whiteWinsCount + 1];
        [self saveNoOfWins];
        [self alertView:[NSString stringWithFormat:@"%@ wins",self.blackPlayerInfo.name]];
    }
}

- (void)changActivePlayerLabelImage
{
    if ([self.whiteImageView.image isEqual:[UIImage imageNamed:@"name.png"]]) {
        [self.whiteImageView setImage:[UIImage imageNamed:@"name-active"]];
        [self.blackImageView setImage:[UIImage imageNamed:@"name"]];
    }
    else if ([self.whiteImageView.image isEqual:[UIImage imageNamed:@"name-active.png"]]) {
        [self.whiteImageView setImage:[UIImage imageNamed:@"name"]];
        [self.blackImageView setImage:[UIImage imageNamed:@"name-active"]];
    }
}

- (IBAction)exitButton:(id)sender {
    [self returnToInitialVc];
}

#pragma mark Alertview
- (void)alertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self returnToInitialVc];
    }
}

- (void)returnToInitialVc
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    MainMenuViewController *mainMenuVC =
    [storyboard instantiateViewControllerWithIdentifier:@"mainMenuViewController"];
    
    [self presentViewController:mainMenuVC
                       animated:YES
                     completion:nil];
}

#pragma mark - Save to and loading from plist
- (void)saveNoOfWins {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.whitePlayerInfo.name forKey:@"PlayerName"];
    [archiver encodeObject:self.whitePlayerInfo.wins forKey:@"WhitePlayerWinCount"];
    [archiver encodeObject:self.blackPlayerInfo.wins forKey:@"BlackPlayerWinCount"];
    [archiver finishEncoding];
    [data writeToFile:[Globals dataFilePath] atomically:YES];
}


@end
