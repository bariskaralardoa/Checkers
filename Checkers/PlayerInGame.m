//
//  PlayerInGame.m
//  Checkers
//
//  Created by DOA Software Mac on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "PlayerInGame.h"

@interface PlayerInGame ()

@property (nonatomic) PlayerInfo* Player;
@end

@implementation PlayerInGame

- (instancetype)initWithPlayerInfo:(PlayerInfo*)playerInfo;
{
    self = [super init];
    if (self) {
        _Player = playerInfo;
    }
    return self;
}

@end
