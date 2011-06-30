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

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.velo-antwerpen.be/"]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Contact", @"");
	self.reportLbl.text = NSLocalizedString(@"Problems with your bicycle? Report them now!", @"");
	[self.reportBtn setTitle:NSLocalizedString(@"Report problem", @"") forState:UIControlStateNormal];
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
