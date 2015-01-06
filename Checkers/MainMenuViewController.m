//
//  MainMenuViewController.m
//  Checkers
//
//  Created by DOA Software Mac on 20/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CheckersViewController.h"
#import "Globals.h"
#import "PlayerInfo.h"


@interface MainMenuViewController ()

@property (strong,nonatomic) PlayerInfo * blackPlayerInfo;
@property (strong,nonatomic) PlayerInfo * whitePlayerInfo;

@end

@implementation MainMenuViewController
{
    NSString * playerName;
    NSNumber * whitePlayerWinCount;
    NSNumber * blackPlayerWinCount;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setDefaultPlistValues];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startGameSegue"]) {
        [self getPlayerInformations];
        
        CheckersViewController * checkersVC = [segue destinationViewController];
        
        checkersVC.blackPlayerInfo = self.blackPlayerInfo;
        checkersVC.whitePlayerInfo = self.whitePlayerInfo;
    }

}


- (void)setDefaultPlistValues {
    NSString *path = [Globals dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        playerName = [unarchiver decodeObjectForKey:@"PlayerName"];
        whitePlayerWinCount = [unarchiver decodeObjectForKey:@"WhitePlayerWinCount"];
        blackPlayerWinCount = [unarchiver decodeObjectForKey:@"BlackPlayerWinCount"];
        
        [unarchiver finishDecoding];
    }
    else{ //Create path and set default values
        playerName = @"Baris";
        whitePlayerWinCount = [NSNumber numberWithInteger:0];
        blackPlayerWinCount = [NSNumber numberWithInteger:0];
        
        [self saveToPlist];
        
    }
}


- (void)saveToPlist {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:playerName forKey:@"PlayerName"];
    [archiver encodeObject:whitePlayerWinCount forKey:@"WhitePlayerWinCount"];
    [archiver encodeObject:blackPlayerWinCount forKey:@"BlackPlayerWinCount"];

    [archiver finishEncoding];
    [data writeToFile:[Globals dataFilePath] atomically:YES];
}


- (void) getPlayerInformations
{
    
    self.blackPlayerInfo = [PlayerInfo new];
    self.blackPlayerInfo.name = @"Computer";
    self.blackPlayerInfo.wins = blackPlayerWinCount;
    
    self.whitePlayerInfo = [PlayerInfo new];
    self.whitePlayerInfo.name = playerName;
    self.whitePlayerInfo.wins = whitePlayerWinCount;

}


@end
