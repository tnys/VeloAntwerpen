//
//  TextFieldViewController.h
//  VeloAntwerpen
//
//  Created by Tom Nys on 23/06/11.
//  Copyright 2011 Netwalk VOF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
@protocol TextFieldViewDelegate <NSObject>

-(void)textWasFinished:(NSString*)text forKey:(NSString*)key;

@end

@interface TextFieldViewController : UIViewController {
    NSString* key;
	IBOutlet UITextField* textField;
	id<TextFieldViewDelegate> delegate;
	
	WEPopoverController* popover;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) IBOutlet UITextField* textField;
@property (nonatomic, assign) id<TextFieldViewDelegate> delegate;
@property (nonatomic, assign) WEPopoverController* popover;

@end
