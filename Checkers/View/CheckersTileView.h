    //
//  CheckersTileView.h
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersPieceView.h"

@class  TileCoordinates;

@interface CheckersTileView : UIView

@property (nonatomic,retain) CheckersPieceView* pieceView;

@property(nonatomic) NSInteger indexX;

@property(nonatomic) NSInteger indexY;

@property(nonatomic) BOOL isClicked;
@property(nonatomic) TileCoordinates *tileCoordinates;



@end
