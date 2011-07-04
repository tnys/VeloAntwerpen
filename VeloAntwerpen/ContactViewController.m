//
//  ContactViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "ContactViewController.h"
#import "ReportIssueViewController.h"

@implementation ContactViewController
@synthesize veloMobileButton;

@synthesize reportBtn, reportLbl;

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
    [veloMobileButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)reportIssue:(id)btn
{
	[[GANTracker sharedTracker] trackEvent:@"reportIssue" action:@"tap" label:nil value:-1 withError:nil];

	ReportIssueViewController* ctrl = [[[ReportIssueViewController alloc] initWithNibName:@"ReportIssueView" bundle:[NSBundle mainBundle]] autorelease];
	[self.navigationController pushViewController:ctrl animated:YES];
}

-(IBAction)veloAntwerpenLink:(id)btn
{
	[[GANTracker sharedTracker] trackEvent:@"veloAntwerpenLink" action:@"tap" label:nil value:-1 withError:nil];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.velo-mobile.be/"]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.veloMobileButton.titleLabel.numberOfLines = 4;
	self.veloMobileButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.veloMobileButton.titleLabel.textAlignment = UITextAlignmentLeft;
	//Velo Mobile is de beste manier om een Velo te vinden in de stad Antwerpen. Surf naar http://www.velo-mobile.be voor alle verdere informatie over de software.
	[self.veloMobileButton setTitle:NSLocalizedString(@"Velo Mobile is the best tool to find a Velo in Antwerp.  Go to http://www.velo-mobile.be for more information.", @"") forState:UIControlStateNormal];
	self.title = NSLocalizedString(@"Contact", @"");
	self.reportLbl.text = NSLocalizedString(@"Problems with your bicycle? Report them now!", @"");
	[self.reportBtn setTitle:NSLocalizedString(@"Report problem", @"") forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setVeloMobileButton:nil];
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
