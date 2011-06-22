//
//  SecondViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "ListViewController.h"
#import "Station.h"
#import "StationDetailViewController.h"

@implementation ListViewController

@synthesize tableView, stations;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"List";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:[UIApplication sharedApplication].delegate action:@selector(reload)] autorelease];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsUpdated:) name:STATIONS_UPDATED_NOTIFICATIONNAME object:nil];
	
	[[UIApplication sharedApplication].delegate reload];
}

-(void)stationsUpdated:(NSNotification*)notif
{
	self.stations = [[UIApplication sharedApplication].delegate stations];
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stations count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"cell";
	UITableViewCell *cell = nil;
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	Station* s = [stations objectAtIndex:indexPath.row];
	cell.textLabel.text = s.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d slots, %d free", s.slots, s.free];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	StationDetailViewController* ctrl = [[[StationDetailViewController alloc] initWithNibName:@"StationDetailView" bundle:[NSBundle mainBundle]] autorelease];
	ctrl.station = [stations objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:ctrl animated:YES];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

	self.tableView = nil;
}


- (void)dealloc
{
	self.tableView = nil;
    [super dealloc];
}

@end
