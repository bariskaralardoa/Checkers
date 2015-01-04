//
//  CheckersViewController.h
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"
#import "PlayerInfo.h"

@interface CheckersViewController : UIViewController

@property (strong, nonatomic) IBOutlet BoardView *boardViewOnController;

@property (strong, nonatomic) IBOutlet UILabel *whitePlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *whitePlayerPointLabel;
@property (strong, nonatomic) IBOutlet UIImageView *whiteImageView;


@property (strong, nonatomic) IBOutlet UILabel *blackPlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackPlayerPointLabel;
@property (strong, nonatomic) IBOutlet UIImageView *blackImageView;

@property (strong,nonatomic) PlayerInfo * blackPlayerInfo;
@property (strong,nonatomic) PlayerInfo * whitePlayerInfo;

@end
