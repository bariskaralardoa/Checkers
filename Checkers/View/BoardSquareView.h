//
//  BoardSquareView.h
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersBoard.h"

@interface BoardSquareView : UIView

- (instancetype) initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(CheckersBoard *)board;


@end
