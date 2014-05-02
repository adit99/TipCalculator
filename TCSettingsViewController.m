//
//  TCSettingsViewController.m
//  TipCalculator
//
//  Created by Aditya Jayaraman on 4/30/14.
//  Copyright (c) 2014 Aditya Jayaraman. All rights reserved.
//

#import "TCSettingsViewController.h"

@interface TCSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
- (IBAction)onChange:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *roundUpForGroups;
- (IBAction)onRoundUpChange:(id)sender;

@end

@implementation TCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Settings";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //When the view loads, set the selected Tip index to the default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTip = [defaults integerForKey:@"defaultTip"];
    [self.defaultTipControl setSelectedSegmentIndex:defaultTip];
    
    bool roundUpForGroups = [defaults integerForKey:@"roundUpForGroups"];
    [self.roundUpForGroups setOn:roundUpForGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChange:(id)sender {
    NSLog(@"Default Tip Changed");
    
    //When the default Tip index changes, set the defaultTipIndex in the standardUserDefaults
    int defaultTipIndex = self.defaultTipControl.selectedSegmentIndex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:defaultTipIndex forKey:@"defaultTip"];
    [defaults synchronize];
}

- (IBAction)onRoundUpChange:(id)sender {
    NSLog(@"Round up for groups Changed");

    bool roundUpForGroups = self.roundUpForGroups.isOn;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:roundUpForGroups forKey:@"roundUpForGroups"];
    [defaults synchronize];
}

@end
