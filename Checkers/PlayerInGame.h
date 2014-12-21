//
//  PlayerInGame.h
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInfo.h"

@interface PlayerInGame : NSObject

- (instancetype)initWithPlayerInfo:(PlayerInfo*)playerInfo;

@property (nonatomic) NSNumber* CurrentPoint;

@end
