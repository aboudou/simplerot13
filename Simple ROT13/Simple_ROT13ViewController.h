//
//  Simple_ROT13ViewController.h
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Simple_ROT13ViewController : UIViewController {    

}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *chooseAlgoButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cipherButton;
@property (nonatomic, copy) NSString *undoValue;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (IBAction)chooseAlgoButtonPressed:(id)sender;

- (IBAction)cipherButtonPressed:(id)sender;

- (void)cipherRot13Leet;
- (void)cipherRot13;

- (void)registerForKeyboardNotifications;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

