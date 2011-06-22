//
//  FirstViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 22/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController {
	IBOutlet MKMapView* mapView;
	BOOL zoomedOnce;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;


-(IBAction)zoomToCurrentLocation;
-(void)reload;
@end

