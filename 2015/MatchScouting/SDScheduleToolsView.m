//
//  SDScheduleToolsView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDScheduleToolsView.h"
#import "SDTitleView.h"
#import "SDSchedule.h"
#import "SDScheduleStore.h"
#import "SDMatchStore.h"
#import "SDMatch.h"
#import "SDEvent.h"
#import "SDEventGroup.h"
#import "SDEventStore.h"
#import "SDEventTableCell.h"

@interface SDScheduleToolsView () {
    NSString* findEventID;
}
- (void)   buildMatchList;
- (void)   selectIndex:(int)index fromArray:(NSArray*)array;
- (NSURL*) smartURLForString:(NSString*)str;
- (void)   stopGetWithStatus:(NSString*)status;

@property (nonatomic, strong, readwrite) NSURLConnection* urlConnection;
@end

@implementation SDScheduleToolsView

@synthesize buildListButtons;
@synthesize urlConnection;
@synthesize dismissBlock;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 0) {
            [getStatusLabel setText:@"Building List..."];
            [showActivity startAnimating];
            [getStartButton setEnabled:NO];
            [buildButton setEnabled:NO];
            [[[self navigationItem] rightBarButtonItem] setEnabled:NO];

            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(buildMatchList) userInfo:nil repeats:NO];
        }
    }
}

- (void) buildMatchList {
    SDMatch* newMatch;
    
    SDMatchStore* matchStore = [SDMatchStore sharedStore];
    SDScheduleStore* scheduleStore = [SDScheduleStore sharedStore];
    
    while([[matchStore allMatches] count] > 0) {
        [matchStore removeMatch:[[matchStore allMatches] objectAtIndex:0]];
    }
    
    for(int i = 0; i < [[scheduleStore allSchedules] count]; i++) {
        scheduleItem = [[scheduleStore allSchedules] objectAtIndex:i];
        
        newMatch = [matchStore createMatch];
        newMatch.matchNumber = scheduleItem.matchNumber;
        newMatch.isCompleted |= 1;

        switch(buildGroup) {
            case 0: newMatch.teamNumber = scheduleItem.teamRed1; break;
            case 1: newMatch.teamNumber = scheduleItem.teamRed2; break;
            case 2: newMatch.teamNumber = scheduleItem.teamRed3; break;
            case 3: newMatch.teamNumber = scheduleItem.teamBlue1; break;
            case 4: newMatch.teamNumber = scheduleItem.teamBlue2; break;
            case 5: newMatch.teamNumber = scheduleItem.teamBlue3; break;
        }
    }
    
    [matchStore saveChanges];
    
    if ([[[SDMatchStore sharedStore] allMatches] count] > 0) {
        if(buildGroup < 3) {
            [[SDEventStore sharedStore] setBuildListTitle: [NSString stringWithFormat:@"Red %d", buildGroup + 1]];
        } else {
            [[SDEventStore sharedStore] setBuildListTitle: [NSString stringWithFormat:@"Blue %d", buildGroup - 2]];
        }
    }
    
    [getStatusLabel setText:@"Build Completed"];
    [showActivity stopAnimating];
    [getStartButton setEnabled:NO];
    [buildButton setEnabled:(buildGroup >= 0)];
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
}

- (void) connection:(NSURLConnection*) theConnection didFailWithError:(NSError *)error {
    [self stopGetWithStatus:@"Connection Failed"];
}

- (void) connectionDidFinishLoading:(NSURLConnection*) theConnection {
    [self stopGetWithStatus:@"Schedule Downloaded"];
    [[SDEventStore sharedStore] setEventTitle:bufferSelectEvent];
    [[SDScheduleStore sharedStore] saveChanges];
}

- (void) connection:(NSURLConnection*)theConnection didReceiveData:(NSData *)data {
    NSRange     dataRange;
    NSString*   dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dataString = [[dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]
                  componentsJoinedByString:@" "];

    htmlSchedule = [htmlSchedule stringByAppendingString: dataString];
    
    NSArray* replies = [htmlSchedule componentsSeparatedByString:@"</tr>"];
    int replyCount = (int)[replies count] - 1;
    
    NSString* lastReply = [replies objectAtIndex:replyCount];
    if([lastReply length] == 0) replyCount--;

    htmlSchedule = lastReply;
    
    for(int i = 0; i < replyCount; i++) {
        NSString* dataItem = [replies objectAtIndex:i];
        dataRange = [dataItem rangeOfString:@"<tr>" options:NSRegularExpressionSearch];
        
        if (dataRange.location != NSNotFound) {
            dataItem = [dataItem substringFromIndex:dataRange.location];
            NSArray* fields = [dataItem componentsSeparatedByString:@"</td>"];
            
            if (fields.count >= 8) {
                scheduleItem = [[SDScheduleStore sharedStore] createSchedule];
               
                for (int i = 0; i < 8; i++) {
                    dataItem = [fields objectAtIndex:i];
                    
                    while ((dataRange = [dataItem rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                        dataItem = [dataItem stringByReplacingCharactersInRange:dataRange withString:@""];

                    dataItem = [dataItem stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ()"]];
//                    NSLog(@"Field=%@", dataItem);
                    
                    switch (i) {
                        case 0: scheduleItem.matchNumber = [dataItem intValue];
                                break;
                        case 1: scheduleItem.matchTime = [dataItem substringFromIndex:4];
                                break;
                        case 2: scheduleItem.teamRed1 = [dataItem intValue];
                                break;
                        case 3: scheduleItem.teamRed2 = [dataItem intValue];
                                break;
                        case 4: scheduleItem.teamRed3 = [dataItem intValue];
                                break;
                        case 5: scheduleItem.teamBlue1 = [dataItem intValue];
                                break;
                        case 6: scheduleItem.teamBlue2 = [dataItem intValue];
                                break;
                        case 7: scheduleItem.teamBlue3 = [dataItem intValue];
                                break;
                    }
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection*)theConnection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse;
    NSString*          contentTypeHeader;
    
    httpResponse = (NSHTTPURLResponse*) response;
    
    if((httpResponse.statusCode/100) != 2) {
        [self stopGetWithStatus:[NSString stringWithFormat:@"HTTP Error %zd", (ssize_t) httpResponse.statusCode]];
    } else {
        contentTypeHeader = [httpResponse MIMEType];
        
        if(contentTypeHeader == nil) {
            [self stopGetWithStatus:@"No Content Type"];
        } else if(!([contentTypeHeader isEqual:@"text/html"])) {
            [self stopGetWithStatus:[NSString stringWithFormat:@"Unsupported Content Type (%@)", contentTypeHeader]];
        }
    }
}

- (id) init {
    self = [super initWithNibName:@"SDScheduleToolsView" bundle:nil];
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(quitEdit:)];
    
    findEventID = [[NSString alloc] init];
    bufferSelectEvent = @"";
    
    [[self navigationItem] setRightBarButtonItem:doneItem animated:NO];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) selectIndex:(int)index fromArray:(NSArray *)array {
    for(int i = 0; i < [array count]; i++) {
        [(SDGradientButton*)[array objectAtIndex:i] setSelected:(i==index)];
    }
}

- (NSURL*) smartURLForString:(NSString *)str {
    NSURL*    result ;
    NSString* trimmedStr;
    NSRange   schemeMarkerRange;
    NSString* scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if((trimmedStr != nil) && (trimmedStr.length != 0)) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if(schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme!=nil);
            
            if(([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL Scheme.
            }
        }
    }
    
    return result;
}

- (void) stopGetWithStatus:(NSString *)status {
    if(self.urlConnection != nil) {
        [self.urlConnection cancel];
        self.urlConnection = nil;
    }
    
    [getStatusLabel setText:status];
    [showActivity stopAnimating];
    
    [getStartButton setEnabled:YES];
    [buildButton setEnabled:(buildGroup >= 0)];
    
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib* nib = [UINib nibWithNibName:@"SDEventTableCell" bundle:nil];
    
    [eventTable registerNib:nib forCellReuseIdentifier:@"SDEventTableCell"];
    
    [eventTable setRowHeight:66];
    
    scheduleItem = nil;
    [getStartButton setTitleColor:[UIColor lightGrayColor] forState:2];
    [buildButton setTitleColor:[UIColor lightGrayColor] forState:2];
    
    
}

- (void) viewDidUnload {
    buildButton      = nil;
    buildListButtons = nil;
    getStartButton   = nil;
    scheduleItem     = nil;
    showActivity     = nil;
    eventTable       = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:@"Tools"];
    
    [getStartButton setEnabled:NO];
    
    buildGroup = -1;
    [self selectIndex:buildGroup fromArray:buildListButtons];
    [buildButton setEnabled:NO];
    [showActivity setHidesWhenStopped:YES];
    
    [eventTable reloadData];
}

// IBActions

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) buildList:(id)sender {
    if([[[SDMatchStore sharedStore] allMatches] count] > 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Recycle Match" message:@"Building a Scout List will delete the existing Matches in the List. Proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        
        alertView.tag = 1;
        [alertView show];
    
    } else {
        [getStatusLabel setText:@"Building List..."];
        [showActivity startAnimating];
        [getStartButton setEnabled:NO];
        [buildButton setEnabled:NO];
        [[[self navigationItem] rightBarButtonItem] setEnabled:NO];

        [self buildMatchList];
    }
}

- (IBAction) buildListButtonTap:(id)sender {
    [getStatusLabel setText:@""];
    
    int index = (int)[sender tag];
    buildGroup = index;
    [self selectIndex:index fromArray:buildListButtons];
    [buildButton setEnabled:(buildGroup >= 0)];
}



- (IBAction) startGetSchedule:(id)sender {
    NSURL* urlPath;
    NSURLRequest* urlRequest;
    
    [[self view] endEditing:YES];
    
    [showActivity startAnimating];
    [getStartButton setEnabled:NO];

    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    
    [getStatusLabel setText:@""];
    
    if([[[SDEventStore sharedStore] selectedID] length] < 1) {
        urlPath = nil;
    } else {
    
        NSString* url = @"http://frc-events.usfirst.org/2015/";
        url = [url stringByAppendingString:[[SDEventStore sharedStore] selectedID]];
        url = [url stringByAppendingString:@"/qualifications"];
        urlPath = [self smartURLForString:url];
        
    }
    
    if(urlPath == nil) {
        [self stopGetWithStatus:@"Invalid URL"];
    } else {
        [[SDScheduleStore sharedStore] removeAll];
        [[SDScheduleStore sharedStore] saveChanges];
        
        htmlSchedule = [[NSString alloc] init];
        urlRequest = [NSURLRequest requestWithURL:urlPath];
        self.urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];

        [[SDEventStore sharedStore] setEventTitle:@""];
        [getStatusLabel setText:@"Receiving..."];
    }
}

- (IBAction) quitEdit:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[SDEventStore sharedStore] allGroups] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SDEventStore sharedStore] getGroupCountInSection:(int)section];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[SDEventStore sharedStore] getGroupNameInSection:(int)section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SDEventTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDEventTableCell"];

    SDEventGroup* group = [[[SDEventStore sharedStore] allGroups] objectAtIndex:[indexPath section]];
    SDEvent* event = [[[SDEventStore sharedStore] allEvents] objectAtIndex:(group.groupStartIndex + [indexPath row])];
    
    cell.eventName.text     = event.eventName;
    cell.eventDate.text     = event.eventDate;
    cell.eventLocation.text = event.eventLocation;
    cell.eventVenue.text    = event.eventVenue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDEventGroup* selectGroup = [[[SDEventStore sharedStore] allGroups] objectAtIndex:[indexPath section]];
    SDEvent* selectEvent = [[[SDEventStore sharedStore] allEvents] objectAtIndex:(selectGroup.groupStartIndex + [indexPath row])];
    bufferSelectEvent = selectEvent.eventName;
    [[SDEventStore sharedStore] setSeletedID:selectEvent.eventID];
    [getStartButton setEnabled:YES];
}

@end
