//
//  StationDetailViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "StationDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation StationDetailViewController

@synthesize mapView, nameLbl, tableView, station;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setStation:(Station *)s
{
	if (s != station)
	{
		[station release];
		station = [s retain];
		
		if (station)
		{
			self.view;
			nameLbl.text = station.name;
			
			[station thumbnailImage:^(UIImage *img) {
				self.mapView.image = img;
			}];
			
			[reverseGeocoder cancel];
			[reverseGeocoder release];
			[detailedLocation release];
			
			reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:CLLocationCoordinate2DMake(station.latitude, station.longitude)];
			reverseGeocoder.delegate = self;
			[reverseGeocoder start];
		}
	}
}

#pragma mark MKReverseGeocoder
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	detailedLocation = [placemark retain];
	[self.tableView reloadData];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0)
		return 76.0;
	return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return 3;
	else
		return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0 && indexPath.row == 0)
	{
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil] autorelease];
		cell.textLabel.text = NSLocalizedString(@"address", @"");
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		cell.detailTextLabel.numberOfLines = 4;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.detailTextLabel.text = station.name;
		if (detailedLocation)
		{
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n", [detailedLocation thoroughfare], 
										 [detailedLocation subThoroughfare], 
										 [detailedLocation postalCode], 
										 [detailedLocation locality], 
										 [detailedLocation country]];
		}
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
		return cell;
	}
	else if (indexPath.section == 0)
	{
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
		
		if (indexPath.row == 1)
		{
			cell.textLabel.text = NSLocalizedString(@"slots", @"");
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", station.slots];
		}
		else if (indexPath.row == 2)
		{
			cell.textLabel.text = NSLocalizedString(@"free", @"");
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", station.free];
		}
		return cell;
	}
	else if (indexPath.section == 1)
	{
		static NSString *CellIdentifier = @"buttoncell";
		UITableViewCell *cell = nil;
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		}
		if (indexPath.row == 0)
			cell.textLabel.text = NSLocalizedString(@"Directions To Here", @"");
		else if (indexPath.row == 1)
			cell.textLabel.text = NSLocalizedString(@"Directions From Here", @"");
		return cell;
	}
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CLLocationCoordinate2D currentLocation = [[[UIApplication sharedApplication].delegate currentLocation] coordinate];
	if (indexPath.section == 1 && indexPath.row == 0)
	{
		[[GANTracker sharedTracker] trackEvent:@"directionsToHere" action:@"tap" label:nil value:-1 withError:nil];

		NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
						 currentLocation.latitude, currentLocation.longitude,
						 station.latitude, station.longitude];
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
		
	}
	else if (indexPath.section == 1 && indexPath.row == 1)
	{
		[[GANTracker sharedTracker] trackEvent:@"directionsFromHere" action:@"tap" label:nil value:-1 withError:nil];

		NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
						 station.latitude, station.longitude,
						 currentLocation.latitude, currentLocation.longitude];
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[GANTracker sharedTracker] trackPageview:@"/StationDetailView" withError:nil];
	
	self.title = NSLocalizedString(@"Details", @"");
	self.mapView.layer.cornerRadius = 5.0;
	self.mapView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	self.mapView.layer.borderWidth = 1.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.tableView = nil;
	self.mapView = nil;
	self.nameLbl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
	[reverseGeocoder cancel];
	[reverseGeocoder release];
	reverseGeocoder = nil;
	[detailedLocation release];
	detailedLocation = nil;
	self.tableView = nil;
	self.mapView = nil;
	self.nameLbl = nil;
	self.station = nil;
	[super dealloc];
}

@end
