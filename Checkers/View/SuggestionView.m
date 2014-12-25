//
//  SuggestionView.m
//  Checkers
//
//  Created by DOA Software Mac on 24/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "SuggestionView.h"

@interface SuggestionView ()

@property (nonatomic) UIImageView* pieceImageView;
@property (nonatomic) UIImage* currentImage;
@end


@implementation SuggestionView

- (void)setSuggestionInfoWithSuggestion:(Suggestion *) suggestion
{
    _suggestionInfo = suggestion;
    
    _currentImage = [UIImage imageNamed:suggestion.imageNameStr];
    _pieceImageView = [[UIImageView alloc] initWithImage:_currentImage];
    _pieceImageView.frame = CGRectMake(0, 0, self.frame.size.height * 1.0, self.frame.size.height * 1.0);
    
    [self addSubview:_pieceImageView];

}

- (NSInteger)indexX
{
    return _suggestionInfo.curX;
}

- (NSInteger)indexY
{
    return _suggestionInfo.curY;
}


@end
