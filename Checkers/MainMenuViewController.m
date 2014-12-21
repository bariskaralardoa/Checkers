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


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        [self loadDataFromPlist];
        [self getPlayerInformations];
        
        CheckersViewController * checkersVC = [segue destinationViewController];
        
        checkersVC.blackPlayerInfo = self.blackPlayerInfo;
        checkersVC.whitePlayerInfo = self.whitePlayerInfo;
    }

}

- (void)loadDataFromPlist {
    NSString *path = [Globals dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        playerName = [unarchiver decodeObjectForKey:@"PlayerName"];
#warning  Get no of wins
        [unarchiver finishDecoding];
    }
}

- (void) getPlayerInformations
{
    
    self.blackPlayerInfo = [PlayerInfo new];
    self.blackPlayerInfo.name = @"Computer";
    self.blackPlayerInfo.wins = 0;
    self.blackPlayerInfo.loses = 0;
    
    self.whitePlayerInfo = [PlayerInfo new];
    self.whitePlayerInfo.name = playerName;
    self.whitePlayerInfo.wins = 0;
    self.whitePlayerInfo.loses = 0;

}


@end
