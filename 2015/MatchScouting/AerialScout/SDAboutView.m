//
//  SDAboutView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDAboutView.h"
#import "SDTitleView.h"

@interface SDAboutView ()

@end

@implementation SDAboutView

- (id) init {
    self = [super initWithNibName:@"SDAboutView" bundle:nil];
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(quitAbout:)];
    
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    
    self.navigationItem.titleView = myTitle.view;
    
    [[myTitle matchLabel] setText:@"About"];
}

- (IBAction) quitAbout:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
