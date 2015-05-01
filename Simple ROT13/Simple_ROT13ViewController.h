//
//  Simple_ROT13ViewController.h
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface Simple_ROT13ViewController : UIViewController <ADBannerViewDelegate> {

}

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *chooseAlgoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cipherButton;

@property (nonatomic, strong) NSString *undoValue;
@property (nonatomic, strong) UIPopoverController *popoverController;

#ifdef SIMPLE_ROT_13_FREE
@property (nonatomic, strong) ADBannerView *adView;
@property (nonatomic, assign) BOOL bannerIsVisible;
#endif

- (IBAction)chooseAlgoButtonPressed:(id)sender;

- (IBAction)cipherButtonPressed:(id)sender;

- (void)cipherRot13Leet;
- (void)cipherRot13;

- (void)registerForKeyboardNotifications;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

