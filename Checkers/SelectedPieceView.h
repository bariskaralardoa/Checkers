//
//  SelectedPieceView.h
//  Checkers
//
//  Created by DOA Software Mac on 28/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPiece.h"

@interface SelectedPieceView : UIView

@property (nonatomic, retain) SelectedPiece* selectedPieceInfo;
@property (nonatomic, readonly) NSInteger indexX;
@property (nonatomic, readonly) NSInteger indexY;

- (void)setSelectedPieceInfoWithPiece:(SelectedPiece *) selectedPiece;




@end
