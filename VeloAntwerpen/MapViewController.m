//
//  FirstViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "MapViewController.h"
#import "StationAnnotation.h"
#import "Station.h"
#import "StationDetailViewController.h"
#import "SmallActivityIndicator.h"

@implementation MapViewController

@synthesize mapView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"VeloAntwerpen";
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:[UIApplication sharedApplication].delegate action:@selector(reload)] autorelease];

	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navicon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(zoomToCurrentLocation)] autorelease];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsUpdated:) name:STATIONS_UPDATED_NOTIFICATIONNAME object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	viewVisible = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	viewVisible = NO;
}

-(IBAction)zoomToCurrentLocation
{
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta=0.015;
	span.longitudeDelta=0.015; 
	
	CLLocationCoordinate2D location=self.mapView.userLocation.coordinate;
	
	region.span=span;
	region.center=location;
	
	[self.mapView setRegion:region animated:TRUE];
	[self.mapView regionThatFits:region];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if (!zoomedOnce)
	{
		[self zoomToCurrentLocation];
		zoomedOnce = YES;
	}
}

-(void)stationsUpdated:(NSNotification*)notif
{
	if (viewVisible)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[[SmallActivityIndicator instance] show:NSLocalizedString(@"Updating data..", @"") inView:self.view];
		});
	}

	[self reload];

	if (viewVisible)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[[SmallActivityIndicator instance] hide];
		});
	}
}

-(void)reload
{
	NSArray* stations = [[[UIApplication sharedApplication].delegate stations] retain];
	
	[mapView removeAnnotations:mapView.annotations];
	for (Station* station in stations)
	{
		StationAnnotation* ann = [[StationAnnotation alloc] init];
		ann.station = station;
		dispatch_async(dispatch_get_main_queue(), ^{
			[mapView addAnnotation:ann];
		});
		[ann release];
	}
	
	[stations release];
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	StationDetailViewController* ctrl = [[[StationDetailViewController alloc] initWithNibName:@"StationDetailView" bundle:[NSBundle mainBundle]] autorelease];
	ctrl.station = [view.annotation station];
	[self.navigationController pushViewController:ctrl animated:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	if ([annotation isKindOfClass:[StationAnnotation class]])
	{
		StationAnnotation* stationAnnotation = (StationAnnotation*)annotation;
		
		MKPinAnnotationView* av = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"]; 
		if (stationAnnotation.station.free)
			av.pinColor = MKPinAnnotationColorGreen;
		else
			av.pinColor = MKPinAnnotationColorRed;
		av.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		av.canShowCallout = YES;
		av.calloutOffset = CGPointMake(-5, 5);
		av.animatesDrop=TRUE;
		
		return av;
	}
	return nil;
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
	self.mapView = nil;
}


- (void)dealloc
{
	self.mapView = nil;
    [super dealloc];
}

@end
