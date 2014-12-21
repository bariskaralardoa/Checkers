//
//  Globals.h
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

+ (int)NumberOfTilesInXDirection;
+ (int)NumberOfTilesInYDirection;


+ (NSString *)documentsDirectory;
+ (NSString *)dataFilePath;

@end
