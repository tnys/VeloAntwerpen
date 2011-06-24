//
//  TextFieldViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "TextFieldViewController.h"


@implementation TextFieldViewController

@synthesize textField, key, delegate, popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.contentSizeForViewInPopover = CGSizeMake(200, 2 * 44 - 1);
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		self.view;
    }
    return self;
}

- (void)dealloc
{
	self.textField = nil;
	self.key = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	self.textField = nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[delegate textWasFinished:textField.text forKey:key];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[popover dismissPopoverAnimated:YES];
	
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
