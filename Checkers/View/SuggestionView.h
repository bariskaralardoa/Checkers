//
//  SuggestionView.h
//  Checkers
//
//  Created by DOA Software Mac on 24/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Suggestion.h"

@interface SuggestionView : UIView

@property (nonatomic, retain) Suggestion* suggestionInfo;
@property (nonatomic, readonly) NSInteger indexX;
@property (nonatomic, readonly) NSInteger indexY;

- (void)setSuggestionInfoWithSuggestion:(Suggestion *) suggestion;

@end
