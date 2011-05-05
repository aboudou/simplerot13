//
//  Simple_ROT13ViewController.h
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Simple_ROT13ViewController : UIViewController {
	IBOutlet UITextView *textView;
	IBOutlet UIBarButtonItem *chooseAlgoButton;
	IBOutlet UIBarButtonItem *cipherButton;
    IBOutlet NSString *undoValue;
    BOOL isLandscapeLeft;
    BOOL isLandscapeRight;
    BOOL isPortrait;
    BOOL isPortraitUpsideDown;
    BOOL isResized;
    
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIBarButtonItem *chooseAlgoButton;
@property (nonatomic, retain) UIBarButtonItem *cipherButton;
@property (nonatomic, copy) NSString *undoValue;
@property (nonatomic, assign) BOOL isLandscapeLeft;
@property (nonatomic, assign) BOOL isLandscapeRight;
@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, assign) BOOL isPortraitUpsideDown;
@property (nonatomic, assign) BOOL isResized;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (IBAction)chooseAlgoButtonPressed:(id)sender;

- (IBAction)cipherButtonPressed:(id)sender;

- (void)cipherRot13Leet;
- (void)cipherRot13;

- (void)registerForKeyboardNotifications;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

