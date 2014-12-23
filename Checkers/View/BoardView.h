//
//  BoardView.h
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersTileView.h"

@interface BoardView : UIView

@property (nonatomic,strong) CheckersTileView * tileView;

-(void) viewTapped: (UIGestureRecognizer *) recognizer;

@end
