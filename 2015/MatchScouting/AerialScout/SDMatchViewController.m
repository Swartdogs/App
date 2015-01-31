//
//  SDMatchViewController.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchViewController.h"
#import "SDMatchStore.h"
#import "SDMatch.h"
#import "SDViewServer.h"
#import "SDToolsView.h"
#import "SDAboutView.h"
#import "SDTitleView.h"
#import "SDMatchScheduleView.h"
#import "SDMatchCell.h"
#import "SDEventStore.h"

@interface SDMatchViewController () {
    bool isIOS7;
}
    -(void)navButtons;


@end

@implementation SDMatchViewController

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SDMatch* match;
    SDMatchStore* store = [SDMatchStore sharedStore];
    if(buttonIndex == 0) {
        while([[store allMatches] count] > 0) {
            [store removeMatch:[[store allMatches] objectAtIndex:0]];
        }
        
        [[SDEventStore sharedStore] setHeaderIsShown:NO];
        [[SDEventStore sharedStore] setBuildListTitle:@""];
        [store saveChanges];
        [[self tableView] reloadData];

    } else if (buttonIndex == 1) {
        int i = 0;
        
        while(i < [[store allMatches] count]) {
            match = [[store allMatches] objectAtIndex:i];
            
            if(match.isCompleted == 31) {
                [store removeMatch:match];
            } else {
                i++;
            }
        }
        
        if(([[store allMatches] count] > 0) && ([[[SDEventStore sharedStore] buildListTitle] length] > 0)) {
            [[SDEventStore sharedStore] setHeaderIsShown:YES];
        } else {
            [[SDEventStore sharedStore] setHeaderIsShown:NO];
        }
        
        [store saveChanges];
        [[self tableView] reloadData];
    }
}

- (id) init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self) {
        myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
        [[myTitle matchLabel] setText:@""];
        
        eventTitle = [[SDEventStore sharedStore] eventTitle];
        buildListTitle = [[SDEventStore sharedStore] buildListTitle];
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            isIOS7 = YES;
        } else {
            isIOS7 = NO;
        }
        
        self.navigationController.navigationBar.translucent = NO;
        
        [self navButtons];
        toolsShown = NO;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void) navButtons {
    [[myTitle matchLabel] setText:@"Scouting List"];
    self.navigationItem.titleView = myTitle.view;
    
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                 target:self
                                 action:@selector(editMatchList:)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewMatch:)];
    
    [[self navigationItem] setLeftBarButtonItem:editItem];
    [[self navigationItem] setRightBarButtonItem:addItem];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    UIBarButtonItem *aboutItem = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showAbout:)];
    
    UIBarButtonItem *scheduleItem = [[UIBarButtonItem alloc] initWithTitle:@"Schedule"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(showSchedule:)];
    
    
    if(!isIOS7) {
        [scheduleItem setWidth:70];
        [aboutItem setWidth:70];
    } else {
        [scheduleItem setWidth:75];
        [aboutItem setWidth:50];
    }
    NSArray* items = [NSArray arrayWithObjects:aboutItem, flexItem, scheduleItem, nil];
    [self setToolbarItems:items animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib* nib = [UINib nibWithNibName:@"SDMatchCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SDMatchCell"];
    [[self tableView] setRowHeight:38];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[self tableView] isEditing]) {
        [[myTitle matchLabel] setText:@"Edit List"];
    } else {
        [[myTitle matchLabel] setText:@"Scouting List"];
    }
    [[self tableView] reloadData];
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
    
    toolsShown = NO;
    
    [[SDViewServer getInstance] setNavControl:[self navigationController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL header = [[SDEventStore sharedStore] scoutHeader];
    BOOL update = [[SDEventStore sharedStore] shouldUpdateHeader];
    
    if(header) {
        if(update && ([[[SDMatchStore sharedStore] allMatches] count] > 0)) {
            eventTitle = [[SDEventStore sharedStore] eventTitle];
            [[SDEventStore  sharedStore] updateHeader:NO];
        }
        return [NSString stringWithFormat:@"%@:  %@", [eventTitle uppercaseString], [[SDEventStore sharedStore] buildListTitle]];
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[SDMatchStore sharedStore] allMatches] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDMatch* cellMatch = [[[SDMatchStore sharedStore] allMatches] objectAtIndex:[indexPath row]];
    
    SDMatchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDMatchCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [[cell matchNumberLabel] setText:[NSString stringWithFormat:@"%d", cellMatch.matchNumber]];
    [[cell teamNumberLabel] setText:[NSString stringWithFormat:@"%d", cellMatch.teamNumber]];
    [[cell checkmarkImage] setHidden:(cellMatch.isCompleted != 31)];
    
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* matches = [[SDMatchStore sharedStore] allMatches];
    SDMatch *selectedMatch = [matches objectAtIndex:[indexPath row]];
    
    SDMatchSummaryView *newView = [[SDMatchSummaryView alloc] initWithNibName:@"SDMatchSummaryView" bundle:nil];
    [newView setMatch:selectedMatch];
    [[self navigationController] navigationBar].translucent = NO;
    
    if(selectedMatch.isCompleted == 15) {
        SDMatch* selectedMatchCopy = [[SDMatch alloc] initWithCopy:selectedMatch];
        [[SDViewServer getInstance] showViewNewIndex:0 oldIndex:-1 matchData:selectedMatch matchCopy:selectedMatchCopy];
        
    } else {
        SDMatch* selectedMatchCopy = [[SDMatch alloc] initWithCopy:selectedMatch];
        if(selectedMatchCopy.noShow == 1) selectedMatchCopy.isCompleted = 15;
        
        [[SDViewServer getInstance] setIsNewMatch:NO];
        [[SDViewServer getInstance] setMatchEdit:NO];
        
        int newIndex = !(selectedMatch.isCompleted & 2)  ? 1:
                       !(selectedMatch.isCompleted & 4)  ? 2:
                       !(selectedMatch.isCompleted & 8)  ? 3:
                                                           0;
        
        [[SDViewServer getInstance] showViewNewIndex:newIndex + 1 oldIndex:-1 matchData:selectedMatch matchCopy:selectedMatchCopy];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[self tableView] isEditing]) {
        return YES;
    } else {
        return NO;
    }
}

- (void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SDMatchStore* store = [SDMatchStore sharedStore];
        SDMatch* match = [[store allMatches] objectAtIndex:[indexPath row]];
        
        [store removeMatch:match];
        [store writeCSVFile];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction) addNewMatch:(id)sender {
    SDMatch* newMatch = [[SDMatchStore sharedStore] createMatch];
    
    [[SDViewServer getInstance] setIsNewMatch:YES];
    [[SDViewServer getInstance] setMatchEdit:NO];
    
    [self navigationController].navigationBar.translucent = NO;
    [[SDViewServer getInstance] showViewNewIndex:1 oldIndex:-1 matchData:newMatch matchCopy:newMatch];
}

- (IBAction) clearTable:(id)sender {
    
    UIActionSheet* clearAction = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete ALL"
                                                    otherButtonTitles:@"Delete Completed", nil];
    
    [clearAction showFromBarButtonItem:[[self toolbarItems] objectAtIndex:0] animated:YES];
}

- (IBAction) doneWithEdit:(id)sender {
    self.navigationItem.titleView = nil;
    [self navButtons];
    [[self tableView] setEditing:NO animated:YES];
}

- (IBAction) editMatchList:(id)sender {
    
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:@"Edit List"];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithEdit:)];
    
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    UIBarButtonItem* flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* clearItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearTable:)];
    
    UIBarButtonItem* uploadItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:@selector(showTools:)];
    
    [clearItem setWidth:70];
    [uploadItem setWidth:70];
    
    NSArray *items = [NSArray arrayWithObjects:clearItem, flexItem, uploadItem, nil];
    [self setToolbarItems:items animated:NO];
    
    [[self tableView] setEditing:YES animated:YES];
}

- (IBAction) showAbout:(id)sender {
    SDAboutView *aboutView = [[SDAboutView alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aboutView];
    
    
    if(isIOS7) {
        [[navController navigationBar] setBarTintColor:[UIColor orangeColor]];
        [[navController navigationBar] setTintColor:[UIColor whiteColor]];
    } else {
        [[navController navigationBar] setTintColor:[UIColor orangeColor]];
    }
    
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction) showSchedule:(id)sender {
    SDMatchScheduleView* scheduleView = [[SDMatchScheduleView alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:scheduleView];
    
    
    if(isIOS7) {
        [[navController navigationBar] setBarTintColor:[UIColor orangeColor]];
        [[navController navigationBar] setTintColor:[UIColor whiteColor]];
    } else {
        [[navController navigationBar] setTintColor:[UIColor orangeColor]];
    }
    
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction) showTools:(id)sender {
    SDToolsView* toolView = [[SDToolsView alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:toolView];
    
    
    if(isIOS7) {
        [[navController navigationBar] setBarTintColor:[UIColor orangeColor]];
        [[navController navigationBar] setTintColor:[UIColor whiteColor]];
    } else {
        [[navController navigationBar] setTintColor:[UIColor orangeColor]];
    }
    
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
    toolsShown = YES;
}

@end
