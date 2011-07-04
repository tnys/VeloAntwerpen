//
//  TextViewViewController2.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 25/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "TextViewViewController2.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextViewViewController2

@synthesize textView;
@synthesize descriptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [descriptionLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textField
{
	[delegate textWasFinished:textField.text forKey:key];
	
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Description", @"");
	//Is het probleem met de fiets niet duidelijk zichtbaar, omschrijf dan hier kort waar de techniekers van Velo op moeten letten.
	self.descriptionLabel.text = NSLocalizedString(@"Is the problem with the bicycle not immediately visible, please describe it briefly so the Velo technicians can easily find it.", @"");
	textView.layer.cornerRadius = 5.0;
	[textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
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
