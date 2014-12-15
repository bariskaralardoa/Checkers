//
//  CheckersViewController.m
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersViewController.h"
#import "CheckersBoard.h"
#import "CheckersBoardView.h"


@interface CheckersViewController ()



@end

@implementation CheckersViewController
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [self.boardViewOnController generateTiles];
    [self.boardViewOnController generatePieces];
    
    [self addGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGestureRecognizer
{
    [self.boardViewOnController addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.boardViewOnController action:@selector(viewTapped:)]];
}

//@implementation CheckersViewController
//{
//    CheckersBoard * board;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //Create game board
//    board = [[CheckersBoard alloc] init];
//    [board setToInitialState];
//    
//    //Create view
//    CheckersBoardView * boardPiecesView = [[CheckersBoardView alloc] initWithFrame:CGRectMake(0,100,320,320) andBoard:board];
//    [self.view addSubview:boardPiecesView];
//    //CGRectMake(88,151,600,585)
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
