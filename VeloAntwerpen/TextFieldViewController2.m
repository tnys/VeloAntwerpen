//
//  TextFieldViewController2.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "TextFieldViewController2.h"


@implementation TextFieldViewController2


@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[delegate textWasFinished:textField.text forKey:key];
	[self.navigationController popViewControllerAnimated:YES];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[textField becomeFirstResponder];
	self.title = NSLocalizedString(@"Bicycle ID", @"");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
