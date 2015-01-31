//
//  SDToolsView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDToolsView.h"
#import "SDMatchStore.h"
#import "SDFileUpload.h"
#import "SDTitleView.h"

@interface SDToolsView ()

- (void) updateReachability:(SDReachability*)curReach;

@end

@implementation SDToolsView

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init {
    self = [super initWithNibName:@"SDToolsView" bundle:nil];
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(quitTools:)];
    
    [[self navigationItem] setRightBarButtonItem:doneItem animated:NO];
    
    fileUpload = [[SDFileUpload alloc] init];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) reachabilityChanged:(NSNotification*)note {
    SDReachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass:[SDReachability class]]);
    [self updateReachability:curReach];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) updateReachability:(SDReachability *)curReach {
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable: {
            [uploadStatusLabel setText:@"No Internet Connection"];
            [connectionStatusLabel setText:@""];
            [startButton setEnabled:NO];
            break;
        }
            
        case ReachableViaWiFi: {
            [uploadStatusLabel setText:@""];
            [connectionStatusLabel setText:@"WiFi"];
            [startButton setEnabled:YES];
            break;
        }
            
        case ReachableViaWWAN: {
            [uploadStatusLabel setText:@""];
            [connectionStatusLabel setText:@"Cellular"];
            [startButton setEnabled:YES];
            break;
        }
        default:;
    }
}

- (void) uploadBusy:(NSNotification*)note {
    NSDictionary* info = [note userInfo];
    
    if([[info objectForKey:@"Info"] isEqual:@"YES"]) {
        [uploadActivity startAnimating];
    } else {
        [uploadActivity stopAnimating];
        [cancelButton setEnabled:NO];
        [startButton setEnabled:YES];
        [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    }
}

- (void) uploadStatus:(NSNotification*)note {
    NSDictionary* info = [note userInfo];
    [uploadStatusLabel setText:[info objectForKey:@"Info"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [uploadActivity setHidesWhenStopped:YES];
    [startButton setTitleColor:[UIColor lightGrayColor] forState:2];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:2];
    [cancelButton setEnabled:NO];
    
    internetReach = [SDReachability reachabilityForInternetConnection];
}

- (void) viewDidUnload {
    hostField = nil;
    userNameField = nil;
    userPassField = nil;
    uploadStatusLabel = nil;
    uploadActivity = nil;
    fileUpload = nil;
    
    startButton = nil;
    cancelButton = nil;
    connectionStatusLabel = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:@"File Upload"];
    
    NSString* hostName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AerialScoutHostPrefKey"];
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AerialScoutUserNamePrefKey"];
    NSString* userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"AerialScoutUserPasswordPrefKey"];
    
    [hostField setText:hostName];
    [userNameField setText:userName];
    [userPassField setText:userPassword];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(uploadStatus:) name:@"Status" object:nil];
    [nc addObserver:self selector:@selector(uploadBusy:) name:@"Busy" object:nil];
    [nc addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [internetReach startNotifier];
    [self updateReachability:internetReach];
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) cancelSend:(id)sender {
    [fileUpload stopUpload];
}

- (IBAction) quitTools:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [internetReach stopNotifier];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) sendFile:(id)sender {
    [startButton setEnabled:NO];
    [cancelButton setEnabled:YES];
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    
    [uploadStatusLabel setText:@""];
    
    [fileUpload startUpload:[[SDMatchStore sharedStore] csvFilePath]
                toFtpServer:[hostField text]
                   userName:[userNameField text]
               userPassword:[userPassField text]];
}

- (IBAction) settingsEdit:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[hostField text] forKey:@"AerialScoutHostPrefKey"];
    [[NSUserDefaults standardUserDefaults] setObject:[userNameField text] forKey:@"AerialScoutUserNamePrefKey"];
    [[NSUserDefaults standardUserDefaults] setObject:[userPassField text] forKey:@"AerialScoutUserPasswordPrefKey"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
