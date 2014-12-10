//
//  CheckersBoardView.h
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersBoard.h"

@interface CheckersBoardView : UIView

-(instancetype) initWithFrame:(CGRect)frame andBoard: (CheckersBoard *) board;

@end
