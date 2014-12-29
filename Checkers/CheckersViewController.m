//
//  CheckersViewController.m
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersViewController.h"
#import "ISetupBoard.h"
#import "IGameState.h"
#import "IPieceMovements.h"
#import "GameEngine.h"
#import "Globals.h"
#import "TileCoordinates.h"
#import "Suggestion.h"
#import "SuggestionView.h"
#import "SelectedPieceView.h"

//#import "CheckersBoard.h"
//#import "CheckersBoardView.h"

@interface CheckersViewController ()

@property id <ISetupBoard> boardSetupEngine;
@property id <IGameState> gameStateEngine;
@property id <IPieceMovements> pieceMovementsEngine;

@end
@implementation CheckersViewController {
    NSArray* currentPieces;
    NSArray* currentMoveSuggestion;
    NSArray* currentSelectedPiece;
    TileCoordinates * clickedCoordinate;
    float pieceHeight;
}

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
        // EKincan: Alttakiler yanlış, bu init fonksiyonu hiçbir zaman çağırılmaz.
        //        _boardSetupEngine = engine;
        //        [_boardSetupEngine generateTilesWithTileHeight:30];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{

    // Ekincan: alttaki player yaratmalar geçici bir çözüm. Normalde playerInfo, daha önceden kaydedilmiş bir player olarak alınmalı ve bu ekranda değil daha önceki bir ekranda ilk olarak yaratılıp, global bir yere koyulmalı. Yani isme göre saklanmalı kaç kez kazandığı, kaybettiği adamın. Şimdilik burada, değişmesi lazım. PlayerInfo yani bizim için şu ana kadar options'dan falan ismini girip oynamış her oyuncuyu represent ediyor.
//    PlayerInfo* blackPlayerInfo = [PlayerInfo new];
//    blackPlayerInfo.name = @"Black Player";
//    blackPlayerInfo.loses = 0;
//    blackPlayerInfo.wins = 0;
//
//    PlayerInfo* whitePlayerInfo = [PlayerInfo new];
//    whitePlayerInfo.name = @"White Player";
//    whitePlayerInfo.loses = 0;
//    whitePlayerInfo.wins = 0;

    // Ekincan: PlayerInGame bize o oyun için gerekli olan playerlar sadece, şimdilik puanını tutuyoruz ama ileride başka istatistikler ve bilgiler de tutulabilinir. İçinde ana playerInfo'yu da tutuyoruz tabi, daha sonra kazanınca player onun wins'ini 1 arttırıp yeniden dosya sistemine kaydetmek için. Bir oyun bittiğinde yeni bir oyun başlarken bu playerInGame baştan yaratılmalı.
    PlayerInGame* blackPlayer = [[PlayerInGame alloc] initWithPlayerInfo:self.blackPlayerInfo];
    PlayerInGame* whitePlayer = [[PlayerInGame alloc] initWithPlayerInfo:self.whitePlayerInfo];

    // Ekincan: Burada önce game engine yoksa eğer yarat, singleton yani. Normalde bu ekrana başka bir ekrandan gelineceği için, o önceki ekrandan buraya game engine pass edilebilir.
    _boardSetupEngine = [GameEngine sharedInstance];
    _gameStateEngine = [GameEngine sharedInstance];
    _pieceMovementsEngine = [GameEngine sharedInstance];
    
    
    float tileHeight = _boardViewOnController.frame.size.width / [Globals NumberOfTilesInXDirection];
    pieceHeight = tileHeight * 0.8;
    [_gameStateEngine startNewGameWithWhitePlayer:whitePlayer withBlackPlayer:blackPlayer withTileHeight:tileHeight withPieceHeight:pieceHeight]; /// Bu fonksiyon bizim için tile array'ını doldurdu ama henüz render edilmedi.
    
    //    [_boardSetupEngine generateTilesWithTileHeight:40];
    [self RenderTiles:[_boardSetupEngine getTiles]]; // Bu method, daha önceki adımda yaratılmış tile'ları render edecek. Bu fonkisyon bir kere her oyun başıdna çağırılıyor şu anda çünkü tile üzerinde oyun içinde bir değişiklik olmaz, rengi falan aynı. Yarın bir gün mayın falan koyma gibi dangalakça şeyler gelirse bu yine çağrılmalı.
    [self RenderPieces:[_boardSetupEngine getPieces] withTileArray:[_boardSetupEngine getTiles]]; // Bu da pieceleri generate edicek.

    //        [self.boardViewOnController generateTiles];
    //    [self.boardViewOnController generatePieces];
    //
    [self addGestureRecognizer];
}

- (void)RenderTiles:(NSArray*)tiles
{

    for (int row = 0; row < [Globals NumberOfTilesInXDirection]; row++) {
        for (int col = 0; col < [Globals NumberOfTilesInYDirection]; col++) {
            [_boardViewOnController addSubview:tiles[row][col]];
        }
    }
}

- (void)RenderPieces:(NSArray*)pieces withTileArray:(NSArray*)tiles
{

    [currentPieces makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (CheckersPieceView* pieceView in pieces) {
        CheckersTileView* tileToPlace = tiles[pieceView.IndexY][pieceView.IndexX];
        tileToPlace.pieceView = pieceView;

        [tileToPlace addSubview:pieceView];
        pieceView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
        //        [pieceView refreshImage];
    }
    currentPieces = [pieces copy]; // Tutalım ki bir sonraki gelişte yok edebilelim hepsini
}

- (void)RenderMoveSuggestion:(NSArray*)moveSuggestion withTileArray:(NSArray*)tiles
{
    
    [currentMoveSuggestion makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (SuggestionView* suggestionView in moveSuggestion) {
        CheckersTileView* tileToPlace = tiles[suggestionView.indexY][suggestionView.indexX];
        tileToPlace.suggestionView = suggestionView;
        
        [tileToPlace addSubview:suggestionView];
        suggestionView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
    }
    currentMoveSuggestion = [moveSuggestion copy];
}

- (void)RenderSelectedPiece:(NSArray*)selectedPiece withTileArray:(NSArray*)tiles
{
    
    [currentSelectedPiece makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (SelectedPieceView* selectedPieceView in selectedPiece) {
        CheckersTileView* tileToPlace = tiles[selectedPieceView.indexY][selectedPieceView.indexX];
        tileToPlace.selectedPieceView = selectedPieceView;
        
        [tileToPlace addSubview:selectedPieceView];
        selectedPieceView.center = CGPointMake(tileToPlace.frame.size.width / 2, tileToPlace.frame.size.height / 2);
    }
    currentSelectedPiece = [selectedPiece copy];
}


#pragma mark - Touch functions

- (void)addGestureRecognizer
{
    ///[self.boardViewOnController addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.boardViewOnController action:@selector(viewTapped:) ]];
    [self.boardViewOnController addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardViewTapped:) ]]; /// Ekincan. Bu fonksiyonu yarat bir yerde
//    [self.boardViewOnController addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.boardViewOnController action:@selector([_pieceMovementsEngine  ])]];

    //[_pieceMovementsEngine ]
    
}


-(void) boardViewTapped: (UIGestureRecognizer *) recognizer
{
    CGPoint touchPoint = [recognizer locationInView:_boardViewOnController];
    //    CGPoint touchPoint2 = [recognizer locationOfTouch:0 inView:nil];
    //    CGPoint touchPoint3 = [recognizer locationOfTouch:0 inView:self];
    float tileHeight = _boardViewOnController.frame.size.width / [Globals NumberOfTilesInXDirection];
    
    clickedCoordinate = [[TileCoordinates alloc] initWithX:floor(touchPoint.x/tileHeight) withY:floor(touchPoint.y/tileHeight)];
    
    [self.pieceMovementsEngine detectClickedCellStatus:clickedCoordinate];

    //Check if clicked in range of possibleMoves or possibleEaten arrays
    if ([self.pieceMovementsEngine isLegalMove:clickedCoordinate]) {
        [self.pieceMovementsEngine handleMoveAndCapture:clickedCoordinate];
        [self RenderPieces:[_boardSetupEngine getPieces] withTileArray:[_boardSetupEngine getTiles]]; // Bu da pieceleri generate edicek.
        
        //Selected piece
        [self.pieceMovementsEngine selectedPieceIndicator:clickedCoordinate withHeight:pieceHeight];
        [self RenderSelectedPiece:[_pieceMovementsEngine getSelectedPieceArr] withTileArray:[_boardSetupEngine getTiles]];
    }
    else
    {
//    [_pieceMovementsEngine createPieceOn:clickedCoordinate withHeight:pieceHeight];
//    [_pieceMovementsEngine whitePiecesCoordinates:clickedCoordinate];
//    [self RenderPieces:[_boardSetupEngine getPieces] withTileArray:[_boardSetupEngine getTiles]]; // Bu da pieceleri generate edicek.


    //Move suggestion
    [self.pieceMovementsEngine possibleMoveIndicator:clickedCoordinate withHeight:tileHeight];
    [self RenderMoveSuggestion:[_pieceMovementsEngine getMoveSuggestion] withTileArray:[_boardSetupEngine getTiles]];
    
    //Selected piece
    [self.pieceMovementsEngine selectedPieceIndicator:clickedCoordinate withHeight:pieceHeight];
    [self RenderSelectedPiece:[_pieceMovementsEngine getSelectedPieceArr] withTileArray:[_boardSetupEngine getTiles]];

    }
}


//@implementation CheckersViewController
//{
//    CheckersBoard * board;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    //Create game board
//    board = [[CheckersBoard alloc] init];
//    [board setToInitialState];
//
//    //Create view
//    CheckersBoardView * boardPiecesView = [[CheckersBoardView alloc] initWithFrame:CGRectMake(0,100,320,320) andBoard:board];
//    [self.view addSubview:boardPiecesView];
//    //CGRectMake(88,151,600,585)
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
