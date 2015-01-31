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
#import "SDSearchStore.h"
#import "SDSearch.h"

@interface SDMatchScheduleView () {
    NSMutableArray* searchNumbers;
    NSMutableArray* searchMatchItems;
    SDSearch* searchItem;
    BOOL displayResults;
}

@property (nonatomic) NSMutableArray* searchResults;

- (void) navButtons;
- (void) searchSchedule;

@end

@implementation SDMatchScheduleView

- (void) dismissSchedule:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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
    
    [self presentViewController:navController animated:YES completion:nil];
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

- (void) searchSchedule {
    int searchNumber;
    [searchMatchItems removeAllObjects];
    [searchNumbers removeAllObjects];
    
    NSArray* allScheduleItems = [[SDScheduleStore sharedStore] allSchedules];
    
    for(SDSchedule* item in allScheduleItems) {
        NSNumberFormatter* numFormat = [[NSNumberFormatter alloc] init];
        [numFormat setNumberStyle:NSNumberFormatterNoStyle];
        if([searchItem.type isEqualToString:@"Robot"]) {
            int number = [[numFormat numberFromString:searchItem.name] intValue];
            if(number == item.teamRed1) {
                [searchMatchItems addObject:item];
                searchNumber = 1;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            } else if(number == item.teamRed2) {
                [searchMatchItems addObject:item];
                searchNumber = 2;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            } else if(number == item.teamRed3) {
                [searchMatchItems addObject:item];
                searchNumber = 3;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            } else if(number == item.teamBlue1) {
                [searchMatchItems addObject:item];
                searchNumber = 4;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            } else if(number == item.teamBlue2) {
                [searchMatchItems addObject:item];
                searchNumber = 5;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            } else if(number == item.teamBlue3) {
                [searchMatchItems addObject:item];
                searchNumber = 6;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            }
        } else if([searchItem.type isEqualToString:@"Match"]) {
            int number = [[numFormat numberFromString:searchItem.name] intValue];
            if(number == item.matchNumber) {
                [searchMatchItems addObject:item];
                searchNumber = 7;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            }
        } else if([searchItem.type isEqualToString:@"Time"]) {
            if([item.matchTime isEqualToString:searchItem.name]) {
                [searchMatchItems addObject:item];
                searchNumber = 8;
                [searchNumbers addObject:[NSNumber numberWithInt:searchNumber]];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[[SDSearchStore sharedStore].all count]];
    
    searchMatchItems = [[NSMutableArray alloc] init];
    searchNumbers = [[NSMutableArray alloc] init];
    displayResults = NO;
    
    NSMutableArray* scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:@"All"];
    [scopeButtonTitles addObject:@"Robots"];
    [scopeButtonTitles addObject:@"Matches"];
    [scopeButtonTitles addObject:@"Times"];
    
    self.searchDisplayController.searchBar.scopeButtonTitles = scopeButtonTitles;
    
    UINib* nib = [UINib nibWithNibName:@"SDScheduleCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SDScheduleCell"];
    
    [self.tableView setRowHeight:42];
    
    [self navButtons];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:@"Match Schedule"];
    
    self.schedule = [[SDScheduleStore sharedStore] allSchedules];
    [[SDSearchStore sharedStore] importSearchItems];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSArray* sections = [[SDSearchStore sharedStore] order];
        return [sections count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSArray* sections = [[SDSearchStore sharedStore] order];
        return [[sections objectAtIndex:section] count];
    } else if(displayResults) {
        return [searchMatchItems count];
    } else {
        return [self.schedule count];
    }
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSArray* sectionNames = [[SDSearchStore sharedStore] sectionNames];
        return (NSString*)[sectionNames objectAtIndex:section];
    } else {
        NSString* eventTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"AerialScoutEventPrefKey"];
        return [NSString stringWithFormat:@"%@", [eventTitle uppercaseString]];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"SearchCell";
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSArray* sections = [[SDSearchStore sharedStore] order];
        SDSearch* search = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = search.name;
        cell.detailTextLabel.text = search.type;
        
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
                case 7:
                    [cell matchNumberLabel].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                    break;
                case 8:
                    [cell matchTimeLabel].backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
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

#pragma mark - Content Filtering

- (void) updateFilteredContentForSearchString:(NSString*)searchString searchType:(NSString*)searchType {
    
    self.searchResults = [[SDSearchStore sharedStore].all mutableCopy];
    
    NSString* strippedStr = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray* searchItems = nil;
    if(strippedStr.length > 0) {
        searchItems = [strippedStr componentsSeparatedByString:@" "];
    }
    
    NSMutableArray* andMatchPredicates = [NSMutableArray array];
    
    for(NSString* searchString in searchItems) {
        NSExpression* lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression* rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate* finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                         rightExpression:rhs modifier:
                                       NSDirectPredicateModifier type:NSContainsPredicateOperatorType
                                                                                 options:NSCaseInsensitivePredicateOption];
        
        [andMatchPredicates addObject:finalPredicate];
    }
    
    NSCompoundPredicate* finalCompoundPredicate = nil;
    
    if(searchType != nil) {
        if(andMatchPredicates.count > 0) {
            NSCompoundPredicate* compPredicate1 = (NSCompoundPredicate*)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
            NSPredicate* compPredicate2 = [NSPredicate predicateWithFormat:@"(SELF.type == %@)", searchType];
            
            finalCompoundPredicate = (NSCompoundPredicate*)[NSCompoundPredicate andPredicateWithSubpredicates:@[compPredicate1, compPredicate2]];
        } else {
            finalCompoundPredicate = (NSCompoundPredicate*)[NSPredicate predicateWithFormat:@"(SELF.type == %@)", searchType];
        }
    } else {
        finalCompoundPredicate = (NSCompoundPredicate*)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    }
    
    self.searchResults = [[self.searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSString* scope;
    
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    scope = (selectedScopeButtonIndex == 1) ? @"Robot" :
            (selectedScopeButtonIndex == 2) ? @"Match" :
            (selectedScopeButtonIndex == 3) ? @"Time":
                                              nil;
    
    [self updateFilteredContentForSearchString:searchString searchType:scope];
    [[SDSearchStore sharedStore] filterArray:self.searchResults];
    return YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString* searchString = [self.searchDisplayController.searchBar text];
    NSString* scope;
    
    scope = (searchOption == 1) ? @"Robot" :
            (searchOption == 2) ? @"Match" :
            (searchOption == 3) ? @"Time" : nil;
    
    [self updateFilteredContentForSearchString:searchString searchType:scope];
    [[SDSearchStore sharedStore] filterArray:self.searchResults];
    return YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    displayResults = NO;
    [self.tableView reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* sections = [[SDSearchStore sharedStore] order];
    searchItem = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.searchDisplayController setActive:NO animated:YES];
    self.searchDisplayController.searchBar.text = searchItem.name;
    displayResults = YES;
    [self searchSchedule];
    [self.tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
