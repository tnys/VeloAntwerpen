//
//  TextViewViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldViewController.h"

@interface TextViewViewController : UIViewController {
    NSString* key;
	IBOutlet UITextView* textView;
	id<TextFieldViewDelegate> delegate;
	
	WEPopoverController* popover;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, assign) id<TextFieldViewDelegate> delegate;
@property (nonatomic, assign) WEPopoverController* popover;

@end
