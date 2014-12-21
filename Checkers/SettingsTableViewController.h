//
//  SettingsTableViewController.h
//  Checkers
//
//  Created by DOA Software Mac on 21/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *playerNameTextField;
- (IBAction)done:(id)sender;

@end
