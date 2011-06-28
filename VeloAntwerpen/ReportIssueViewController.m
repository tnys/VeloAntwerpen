//
//  ReportIssueViewController.m
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import "ReportIssueViewController.h"
#import "TextFieldViewController.h"
#import "TextViewViewController.h"
#import "SmallActivityIndicator.h"

#import "TextFieldViewController2.h"
#import "TextViewViewController2.h"
#import "CategoryViewController.h"

@implementation ReportIssueViewController

@synthesize popoverController, bikeId, description, category;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[photo release];
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
	
	self.title = NSLocalizedString(@"Report problem", @"");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)reportTapped:(id)btn
{
	[[SmallActivityIndicator instance] show:NSLocalizedString(@"Sending report..", @"") inView:self.view];
	
	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[[SmallActivityIndicator instance] hide];
		[self.navigationController popViewControllerAnimated:YES];
	});
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		    return 4;
		else
			return 3;
	}
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	if (indexPath.section == 0)
	{
		NSString *CellIdentifier = @"Cell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (indexPath.row == 0)
		{
			cell.textLabel.text = NSLocalizedString(@"Bicycle ID", @"");
			cell.detailTextLabel.text = bikeId;
		}
		else if (indexPath.row == 1)
		{
			cell.textLabel.text = NSLocalizedString(@"Category", @"");
			cell.detailTextLabel.text = category;
		}
		else if (indexPath.row == 2)
		{
			cell.textLabel.text = NSLocalizedString(@"Details", @"");
			cell.detailTextLabel.text = description;
		}
		else if (indexPath.row == 3)
		{
			cell.textLabel.text = NSLocalizedString(@"Photo", @"");
			if (photo)
				cell.detailTextLabel.text = NSLocalizedString(@"Update picture", @"");
			else
				cell.detailTextLabel.text = NSLocalizedString(@"Add a picture", @"");
		}
	}
	else if (indexPath.section == 1)
	{
		NSString *CellIdentifier = @"Button";
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		}
		
		cell.textLabel.text = NSLocalizedString(@"Submit", @"");
	}
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[photo release];
	photo = [[info valueForKey:UIImagePickerControllerEditedImage] retain];
	[self.tableView reloadData];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)textWasFinished:(NSString*)text forKey:(NSString*)key
{
	if ([key isEqualToString:@"ID"])
		self.bikeId = text;
	else if ([key isEqualToString:@"Type"])
		self.category = text;
	else if ([key isEqualToString:@"Description"])
		self.description = text;
	[self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		if (indexPath.row < 3)
		{
			ReportBackViewController* contentViewController = nil;
			
			if (indexPath.row == 0)
			{
				contentViewController = [[TextFieldViewController2 alloc] initWithNibName:@"TextFieldView2" bundle:[NSBundle mainBundle]];
				contentViewController.view;
				contentViewController.key = @"ID";
				((TextFieldViewController2*)contentViewController).textField.text = self.bikeId;
				((TextFieldViewController2*)contentViewController).textField.placeholder = NSLocalizedString(@"Bicycle ID", @"");
			}
			else if (indexPath.row == 1)
			{
				contentViewController = [[CategoryViewController alloc] initWithNibName:@"CategoryView" bundle:[NSBundle mainBundle]];
				contentViewController.key = @"Type";
				((CategoryViewController*)contentViewController).selectedCategory = self.category;
				((CategoryViewController*)contentViewController).categories = [NSArray arrayWithObjects:NSLocalizedString(@"Steer", @""), 
													NSLocalizedString(@"Brakes", @""),
													NSLocalizedString(@"Tire", @""),
													NSLocalizedString(@"Light", @""),
													nil];
				
			}
			else if (indexPath.row == 2)
			{
				contentViewController = [[TextViewViewController2 alloc] initWithNibName:@"TextViewView2" bundle:[NSBundle mainBundle]];
				contentViewController.view;
				contentViewController.key = @"Description";
				((TextViewViewController2*)contentViewController).textView.text = self.description;
			}

			contentViewController.delegate = self;

			[self.navigationController pushViewController:contentViewController animated:YES];
						
			[contentViewController release];
		}
		else if (indexPath.row == 3)
		{
			UIImagePickerController* ctrl = [[UIImagePickerController alloc] init];
			ctrl.delegate = self;
			ctrl.allowsEditing = YES;
			ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:ctrl animated:YES];
		}
	}
	else if (indexPath.section == 1)
	{
		[self reportTapped:nil];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
