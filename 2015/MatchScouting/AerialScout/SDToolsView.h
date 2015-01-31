//
//  SDToolsView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDReachability.h"

@class SDFileUpload;

@interface SDToolsView : UIViewController <UIAlertViewDelegate, UITextFieldDelegate> {
    SDFileUpload* fileUpload;
    
    __weak IBOutlet UITextField* hostField;
    __weak IBOutlet UITextField* userNameField;
    __weak IBOutlet UITextField* userPassField;
    __weak IBOutlet UILabel* uploadStatusLabel;
    __weak IBOutlet UILabel* connectionStatusLabel;
    __weak IBOutlet UIActivityIndicatorView* uploadActivity;
    __weak IBOutlet UIButton* startButton;
    __weak IBOutlet UIButton* cancelButton;
    
    SDReachability* internetReach;
}

- (IBAction) settingsEdit:(id)sender;
- (IBAction) backgroundTap:(id)sender;
- (IBAction) sendFile:(id)sender;
- (IBAction) cancelSend:(id)sender;

@end
