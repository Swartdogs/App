//
//  SDMatchScheduleView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/23/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchScheduleView.h"
#import "SDTitleView.h"
#import "SDSchedule.h"
#import "SDScheduleCell.h"
#import "SDScheduleToolsView.h"
#import "SDScheduleStore.h"
#import "SDEventStore.h"
#import "SDMatchStore.h"

@interface SDMatchScheduleView () {
    NSMutableArray* searchNumbers;
    NSMutableArray* searchMatchItems;
    NSMutableArray* teamList;
    BOOL            displayResults;
}

@property (nonatomic) NSMutableArray* searchResults;

- (void) buildTeamList;
- (bool) isNewTeam:(int)team inList:(NSMutableArray*)list;
- (void) navButtons;
- (void) searchSchedule:(int)teamNumber;

@end

@implementation SDMatchScheduleView

- (void) buildTeamList {
    NSMutableArray* list = [[NSMutableArray alloc] initWithCapacity:120];
    NSArray* schedules = [[SDScheduleStore sharedStore] allSchedules];
    
    for (SDSchedule* schedule in schedules) {
        if ([self isNewTeam:schedule.teamBlue1 inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamBlue1]];
        if ([self isNewTeam:schedule.teamBlue2 inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamBlue2]];
        if ([self isNewTeam:schedule.teamBlue3 inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamBlue3]];
        if ([self isNewTeam:schedule.teamRed1  inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamRed1]];
        if ([self isNewTeam:schedule.teamRed2  inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamRed2]];
        if ([self isNewTeam:schedule.teamRed3  inList:list]) [list addObject:[NSNumber numberWithInt:schedule.teamRed3]];
    }
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [list sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    [teamList removeAllObjects];
    
    for (NSNumber* teamNumber in list) {
        [teamList addObject:[NSString stringWithFormat:@"%d", [teamNumber intValue]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dismissSchedule:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (bool) isNewTeam:(int)team inList:(NSMutableArray *)list {
    for (NSString* number in list) {
        if ([number intValue] == team) return NO;
    }
    return YES;
}

- (void) navButtons {
    UIBarButtonItem* toolItem = [[UIBarButtonItem alloc] initWithTitle:@"Tools"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(showTools:)];
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSchedule:)];
    
    [[self navigationItem] setLeftBarButtonItem:toolItem];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    
}

- (void) searchSchedule:(int)teamNumber {
    [searchMatchItems removeAllObjects];
    [searchNumbers removeAllObjects];
    
    NSArray* allScheduleItems = [[SDScheduleStore sharedStore] allSchedules];
    
    for(SDSchedule* item in allScheduleItems) {
        if(teamNumber == item.teamRed1) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:1]];
        } else if(teamNumber == item.teamRed2) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:2]];
        } else if(teamNumber == item.teamRed3) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:3]];
        } else if(teamNumber == item.teamBlue1) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:4]];
        } else if(teamNumber == item.teamBlue2) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:5]];
        } else if(teamNumber == item.teamBlue3) {
            [searchMatchItems addObject:item];
            [searchNumbers addObject:[NSNumber numberWithInt:6]];
        }
    }
}

- (void) showTools:(id)sender {
    SDScheduleToolsView* toolsView = [[SDScheduleToolsView alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:toolsView];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [[navController navigationBar] setTintColor:[UIColor whiteColor]];
        [[navController navigationBar] setBarTintColor:[UIColor orangeColor]];
    } else {
        [[navController navigationBar] setTintColor:[UIColor orangeColor]];
    }
    
    navController.navigationBar.translucent = NO;
    
    [toolsView setDismissBlock:^{
        displayResults = NO;
        self.searchDisplayController.searchBar.text = @"";
        [self.tableView reloadData];
    }];
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:120];
    
    searchMatchItems =  [[NSMutableArray alloc] init];
    searchNumbers =     [[NSMutableArray alloc] init];
    teamList =          [[NSMutableArray alloc] initWithCapacity:120];
    displayResults = NO;
    
    UINib* nib = [UINib nibWithNibName:@"SDScheduleCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SDScheduleCell"];
    
    [self.tableView setRowHeight:42];
    
    [self navButtons];
}

- (void) viewDidUnload {
    searchMatchItems = nil;
    searchNumbers = nil;
    self.searchResults = nil;
    teamList = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:@"Match Schedule"];
    
    self.schedule = [[SDScheduleStore sharedStore] allSchedules];
    [self buildTeamList];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        if ([self.searchResults count] > 0) return 1;
        return 0;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else if(displayResults) {
        return [searchMatchItems count];
    } else {
        return [self.schedule count];
    }
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    } else {
        NSString* eventTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScoutEventPrefKey"];
        return [NSString stringWithFormat:@"%@", [eventTitle uppercaseString]];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"SearchCell";
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSString* teamNumber = [self.searchResults objectAtIndex:indexPath.row];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        cell.textLabel.text = teamNumber;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
        
    } else if(displayResults) {
        SDSchedule* cellSchedule;
        SDScheduleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDScheduleCell"];
        cellSchedule = [searchMatchItems objectAtIndex:indexPath.row];
        
        [[cell matchNumberLabel] setText:[NSString stringWithFormat:@"Match %3d", cellSchedule.matchNumber]];
        [[cell matchTimeLabel] setText:cellSchedule.matchTime];
        [[cell red1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed1]];
        [[cell red2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed2]];
        [[cell red3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed3]];
        [[cell blue1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue1]];
        [[cell blue2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue2]];
        [[cell blue3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue3]];
        
        [cell red1Label].textColor = [UIColor redColor];
        [cell red2Label].textColor = [UIColor redColor];
        [cell red3Label].textColor = [UIColor redColor];
        [cell red1Label].backgroundColor = [UIColor whiteColor];
        [cell red2Label].backgroundColor = [UIColor whiteColor];
        [cell red3Label].backgroundColor = [UIColor whiteColor];
        
        [cell blue1Label].textColor = [UIColor blueColor];
        [cell blue2Label].textColor = [UIColor blueColor];
        [cell blue3Label].textColor = [UIColor blueColor];
        [cell blue1Label].backgroundColor = [UIColor whiteColor];
        [cell blue2Label].backgroundColor = [UIColor whiteColor];
        [cell blue3Label].backgroundColor = [UIColor whiteColor];
        
        [cell matchNumberLabel].backgroundColor = [UIColor whiteColor];
        [cell matchTimeLabel].backgroundColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([searchNumbers count] > 0) {
            switch ([(NSNumber*)[searchNumbers objectAtIndex:indexPath.row] intValue]) {
                case 1:
                    [[cell red1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed1]];
                    [cell red1Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 2:
                    [[cell red2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed2]];
                    [cell red2Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 3:
                    [[cell red3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed3]];
                    [cell red3Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 4:
                    [[cell blue1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue1]];
                    [cell blue1Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 5:
                    [[cell blue2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue2]];
                    [cell blue2Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 6:
                    [[cell blue3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue3]];
                    [cell blue3Label].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                default:
                    break;
            }
        }
        
        return cell;
        
    } else {
        SDSchedule* cellSchedule;
        SDScheduleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDScheduleCell"];
        cellSchedule = [self.schedule objectAtIndex:indexPath.row];
        
        [[cell matchNumberLabel] setText:[NSString stringWithFormat:@"Match %3d", cellSchedule.matchNumber]];
        [[cell matchTimeLabel] setText:cellSchedule.matchTime];
        [[cell red1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed1]];
        [[cell red2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed2]];
        [[cell red3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamRed3]];
        [[cell blue1Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue1]];
        [[cell blue2Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue2]];
        [[cell blue3Label] setText:[NSString stringWithFormat:@"%d", cellSchedule.teamBlue3]];
        
        [cell matchNumberLabel].backgroundColor = [UIColor whiteColor];
        [cell matchTimeLabel].backgroundColor = [UIColor whiteColor];
        
        [cell red1Label].textColor = [UIColor redColor];
        [cell red2Label].textColor = [UIColor redColor];
        [cell red3Label].textColor = [UIColor redColor];
        [cell red1Label].backgroundColor = [UIColor whiteColor];
        [cell red2Label].backgroundColor = [UIColor whiteColor];
        [cell red3Label].backgroundColor = [UIColor whiteColor];
        
        [cell blue1Label].textColor = [UIColor blueColor];
        [cell blue2Label].textColor = [UIColor blueColor];
        [cell blue3Label].textColor = [UIColor blueColor];
        [cell blue1Label].backgroundColor = [UIColor whiteColor];
        [cell blue2Label].backgroundColor = [UIColor whiteColor];
        [cell blue3Label].backgroundColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        [self.searchDisplayController setActive:NO animated:YES];
        displayResults = YES;

        int searchIndex = [[self.searchResults objectAtIndex:indexPath.row] intValue];
        self.searchDisplayController.searchBar.text = [NSString stringWithFormat:@"%i", searchIndex];
        [self searchSchedule:searchIndex];

        [self.tableView reloadData];
    }
}

#pragma mark - Content Filtering

- (void) updateFilteredContentForSearchString:(NSString*)searchString searchType:(NSString*)searchType {
    NSArray* results = [teamList filteredArrayUsingPredicate:
                       [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchString]];
    
    self.searchResults = [results mutableCopy];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self updateFilteredContentForSearchString:searchString searchType:nil];
    return YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString* searchString = [self.searchDisplayController.searchBar text];
    [self updateFilteredContentForSearchString:searchString searchType:nil];
    return YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    displayResults = NO;
    [self.tableView reloadData];
}

@end
