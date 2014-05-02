//
//  TCViewController.m
//  TipCalculator
//
//  Created by Aditya Jayaraman on 4/29/14.
//  Copyright (c) 2014 Aditya Jayaraman. All rights reserved.
//

#import "TCViewController.h"
#import "TCSettingsViewController.h"

@interface TCViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

//perperson
@property (weak, nonatomic) IBOutlet UITextField *numPersons;
@property (weak, nonatomic) IBOutlet UILabel *perPersonTotal;

//reset
- (IBAction)onClick:(id)sender;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
        
        //Set the default tip to the first index when the controller is initialized
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"defaultTip"];
        //Set the roundUpforGroups flag to false when the controller is initialized
        [defaults setBool:FALSE forKey:@"roundUpForGroups"];


        [defaults synchronize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateValues];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender {
    
    [self.billTextField setText:@""];
    [self.numPersons setText:@"1"];
    [self updateValues];
}

- (IBAction)onTap:(id)sender {
    
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues {
    NSLog(@"update values called");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL roundUpforGroups = [defaults boolForKey:@"roundUpForGroups"];
    
    float billAmount = [self.billTextField.text floatValue];
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    
    float controlTip = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float tipAmount = controlTip;
    float totalAmount = billAmount + tipAmount;
    int numPersons = [self.numPersons.text intValue];
    
    //We dont like divide by 0 :)
    if (numPersons == 0) {
        numPersons = 1;
    }
    
    //new math if we are rounding up
    float perPersonTotal = totalAmount / numPersons;
    if (roundUpforGroups && numPersons > 1) {
        perPersonTotal = ceilf(perPersonTotal);
        totalAmount  = perPersonTotal * numPersons;
        tipAmount  = totalAmount - billAmount;
    }
    
    self.perPersonTotal.text = [NSString stringWithFormat:@"$%0.2f", perPersonTotal];
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[TCSettingsViewController alloc] init] animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Tip Calculator";
    NSLog(@"view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
    
    //When the view appears, set the selected Tip index to the default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTip = [defaults integerForKey:@"defaultTip"];
    [self.tipControl setSelectedSegmentIndex:defaultTip];
    [self updateValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.title = @"Back";
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

@end
