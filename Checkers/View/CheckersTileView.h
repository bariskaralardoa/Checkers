    //
//  CheckersTileView.h
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersPieceView.h"
#import "SuggestionView.h"
#import "SelectedPieceView.h"

@class  TileCoordinates;

@interface CheckersTileView : UIView

@property (nonatomic,retain) CheckersPieceView* pieceView;
@property (nonatomic,retain) SuggestionView* suggestionView;
@property (nonatomic,retain) SelectedPieceView* selectedPieceView;
@property(nonatomic) TileCoordinates *tileCoordinates;

@property(nonatomic) NSInteger indexX;
@property(nonatomic) NSInteger indexY;

@property(nonatomic) BOOL isClicked;


@end
