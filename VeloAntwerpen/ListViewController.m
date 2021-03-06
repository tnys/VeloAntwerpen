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
#import "SmallActivityIndicator.h"
#import "AsyncImageView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ListViewController

@synthesize tableView, stations;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = NSLocalizedString(@"List", @"");
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeSorting:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:[UIApplication sharedApplication].delegate action:@selector(reload)] autorelease];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsUpdated:) name:STATIONS_UPDATED_NOTIFICATIONNAME object:nil];
	[[UIApplication sharedApplication].delegate reload];
}

-(void)changeSorting:(id)btn
{
	sortMode = !sortMode;
	dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
		[self stationsUpdated:nil];
	});
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[GANTracker sharedTracker] trackPageview:@"/ListView" withError:nil];
	
	viewVisible = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	viewVisible = NO;
}

-(void)stationsUpdated:(NSNotification*)notif
{
	if (viewVisible)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[[SmallActivityIndicator instance] show:NSLocalizedString(@"Updating data..", @"") inView:self.tableView];
		});
	}
	
	[self filterContentForSearchText:nil scope:nil];

	
	if (viewVisible)
	{
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self.tableView reloadData];
			[[SmallActivityIndicator instance] hide];
		});
	}
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (sortMode)
		return 1;
	else
		return [[stationsIndexed allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (sortMode)
		return @"";
	else
		return [[[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (sortMode)
		return [stations count];
	else
	{
		NSString* key = [[[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
		NSArray* arr = [stationsIndexed valueForKey:key];
		return [arr count];
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return [[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)] indexOfObject:title];
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
		cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
	}
	else 
	{
		AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
    }


	Station* s = nil;
	if (sortMode)
		s = [stations objectAtIndex:indexPath.row];
	else
	{
		NSString* key = [[[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section];
		NSArray* arr = [stationsIndexed valueForKey:key];
		s = [arr objectAtIndex:indexPath.row];
	}
	cell.imageView.image = [s tableViewImage];
	cell.imageView.layer.borderWidth = 0;
	cell.imageView.layer.cornerRadius = 0;
	
	if (!cell.imageView.image)
	{
		cell.imageView.image = [UIImage imageNamed:@"map.png"];
		CGRect frame;
		frame.size.width=40; frame.size.height=40;
		frame.origin.x=2; frame.origin.y=2;
		AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		asyncImage.layer.borderColor = [UIColor blackColor].CGColor;
		asyncImage.layer.borderWidth = 1.0;
		asyncImage.layer.cornerRadius = 3.0;
		[asyncImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&zoom=14&size=40x40&maptype=roadmap&sensor=true", s.latitude, s.longitude]] andSaveIn:[s tableViewImageFilename]];
		[cell.contentView addSubview:asyncImage];
	}
	else
	{
		cell.imageView.layer.borderWidth = 1.0;
		cell.imageView.layer.cornerRadius = 3.0;
	}
	
	CLLocation* currentLocation = [[UIApplication sharedApplication].delegate currentLocation];
	CLLocationDistance distance = [currentLocation distanceFromLocation:[[[CLLocation alloc] initWithLatitude:s.latitude longitude:s.longitude] autorelease]];
	cell.textLabel.text = s.name;
	if (s.free == 1)
		cell.detailTextLabel.textColor = [UIColor orangeColor];
	else if (s.free == 0)
		cell.detailTextLabel.textColor = [UIColor redColor];
	else
		cell.detailTextLabel.textColor = [UIColor darkGrayColor];
	cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d slots, %d free, distance: %.1f km", @""), s.slots, s.free, distance / 1000.0];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	StationDetailViewController* ctrl = [[[StationDetailViewController alloc] initWithNibName:@"StationDetailView" bundle:[NSBundle mainBundle]] autorelease];
	Station* s = nil;
	if (sortMode)
		s = [stations objectAtIndex:indexPath.row];
	else
	{
		NSString* key = [[[stationsIndexed allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section];
		NSArray* arr = [stationsIndexed valueForKey:key];
		s = [arr objectAtIndex:indexPath.row];
	}
	ctrl.station = s;
	[self.navigationController pushViewController:ctrl animated:YES];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	self.stations = [[UIApplication sharedApplication].delegate stations];

	if (sortMode) // sort by distance
	{
		CLLocation* currentLocation = [[UIApplication sharedApplication].delegate currentLocation];
		self.stations = [self.stations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			
			CLLocationDistance distance1 = [currentLocation distanceFromLocation:[[[CLLocation alloc] initWithLatitude:[obj1 latitude] longitude:[obj1 longitude]] autorelease]];
			CLLocationDistance distance2 = [currentLocation distanceFromLocation:[[[CLLocation alloc] initWithLatitude:[obj2 latitude] longitude:[obj2 longitude]] autorelease]];
			if (distance1 < distance2)
				return NSOrderedAscending;
			else
				return NSOrderedDescending;
		}];
	}
	
	// now filter list
	if (searchText || scope)
	{
		NSMutableArray* newStations = [NSMutableArray arrayWithCapacity:10];
		for (Station* s in stations)
		{
//			if ([scope isEqualToString:@"All"] || [s.name isEqualToString:scope] )
			{
				NSComparisonResult result = [s.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result == NSOrderedSame)
				{
					[newStations addObject:s];
				}
			}
		}
		
		[stations release];
		stations = [newStations retain];
	}

	if (!sortMode)
	{
		[stationsIndexed release];
		stationsIndexed = [[NSMutableDictionary alloc] initWithCapacity:26];
		for (Station* s in stations)
		{
			unichar ch = '#';
			if ([s.name length])
				ch = [s.name characterAtIndex:0];
			NSArray* arr = [stationsIndexed valueForKey:[NSString stringWithFormat:@"%c", ch]];
			NSMutableArray* newArr = [arr mutableCopy];
			if (!newArr)
				newArr = [[NSMutableArray alloc] initWithCapacity:10];
			[newArr addObject:s];
			[stationsIndexed setValue:newArr forKey:[NSString stringWithFormat:@"%c", ch]];
		}
	}
	
	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self filterContentForSearchText:nil scope:nil];	
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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
