//
//  Simple_ROT13ViewController.m
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Simple_ROT13ViewController.h"
#import "AlgorithmSelectorViewController.h"
#import "Algo.h"

@implementation Simple_ROT13ViewController

@synthesize textView, chooseAlgoButton, cipherButton;
@synthesize undoValue;
@synthesize isLandscapeLeft, isLandscapeRight, isPortrait, isPortraitUpsideDown, isResized;
@synthesize popoverController;

#pragma mark -
#pragma mark controller/view lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];

    self.isLandscapeLeft = NO;
    self.isLandscapeRight = NO;
    self.isPortrait= YES;
    self.isPortraitUpsideDown = NO;
    // Set to yes by default to manage landscape starting on iPad
    self.isResized = YES;
    
    self.textView.text = NSLocalizedString(@"Enter text to cipher", @"Enter text to cipher");
    
    [self registerForKeyboardNotifications];
}


- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
}

// Allow view to become the first responder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// Set view as first responder in order to immediately respond to shakes
- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (YES);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.isLandscapeLeft = YES;
        self.isLandscapeRight = NO;
        self.isPortrait= NO;
        self.isPortraitUpsideDown = NO;
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.isLandscapeLeft = NO;
        self.isLandscapeRight = YES;
        self.isPortrait= NO;
        self.isPortraitUpsideDown = NO;
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.isLandscapeLeft = NO;
        self.isLandscapeRight = NO;
        self.isPortrait= YES;
        self.isPortraitUpsideDown = NO;
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.isLandscapeLeft = NO;
        self.isLandscapeRight = NO;
        self.isPortrait= NO;
        self.isPortraitUpsideDown = YES;
    }
    self.isResized = NO;
}

- (void)didReceiveMemoryWarning {
    
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    self.undoValue = nil;
    [undoValue release];
}

- (void)viewDidUnload {
    self.textView = nil;
    self.chooseAlgoButton = nil;
    self.cipherButton = nil;
    self.undoValue = nil;
}

- (void)dealloc {
    [textView release];
    [chooseAlgoButton release];
    [cipherButton release];
    [undoValue release];
    [popoverController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Keyboard management functions

- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (self.isResized == NO) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGRect bkgndRect = textView.superview.superview.frame;
        if (self.isLandscapeLeft) {
            bkgndRect.size.height -= kbSize.width;
        } else if (self.isLandscapeRight) {
            bkgndRect.size.height -= kbSize.width;
        } else if (self.isPortrait) {
            bkgndRect.size.height -= kbSize.height;
        } else if (self.isPortraitUpsideDown) {
            bkgndRect.size.height -= kbSize.height;
        }
        [textView.superview.superview setFrame:bkgndRect];
        
        [UIView commitAnimations];
        self.isResized = YES;
    }
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark -
#pragma mark UI management functions

// On device shaking, undo previous encoding
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        if (self.undoValue != nil && self.undoValue != @"") {
            textView.text = undoValue;
        }
    }
}

// This function encode input text using l33t rot13 algorithm
- (void)cipherRot13 {
	
	NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
	
	NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
	NSMutableDictionary *rot13Map = [NSMutableDictionary dictionaryWithCapacity:52];
	
	// Prepare map for rot13 lowercase char
	for (int i = 0; i < [alphabet length]; i++) {
		NSString *rot13char = [NSString stringWithFormat:@"%C",[alphabet characterAtIndex:(i+13)%26]];
		[rot13Map setValue:rot13char forKey:[NSString stringWithFormat:@"%C",[alphabet characterAtIndex:i]]];
 	}
    
	// Prepare map for rot13 uppercase char
	for (int i = 0; i < [alphabet length]; i++) {
		NSString *rot13char = [NSString stringWithFormat:@"%C",[[alphabet uppercaseString] characterAtIndex:(i+13)%26]];
		[rot13Map setValue:rot13char forKey:[NSString stringWithFormat:@"%C",[[alphabet uppercaseString] characterAtIndex:i]]];
 	}
	
    // Convert text
	NSString *converted = @"";
	for (int i = 0; i < [textViewValue length]; i++) {
		NSString *c = [NSString stringWithFormat:@"%C",[textViewValue characterAtIndex:i]];
		NSString *rot13 = [rot13Map objectForKey:c];
		if (rot13 == nil) {
			converted = [converted stringByAppendingString:c];
		} else {
			converted = [converted stringByAppendingString:rot13];
		}
	}
	
	textView.text = converted;
}

// This function encode input text using l33t rot13 algorithm
- (void)cipherRot13Leet {

	NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
	
	NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyz";
	NSString *leetLower = @"48cd3f9h!jk1mn0pqr57uvwxy2";
	NSString *leetUpper = @"48CD3F9H!JK1MN0PQR57UVWXY2";
	
	NSMutableDictionary *rot13Map = [NSMutableDictionary dictionaryWithCapacity:52];
	
	// Prepare map for rot13 lowercase char
	for (int i = 0; i < [alphabet length]; i++) {
		NSString *rot13char = [NSString stringWithFormat:@"%C",[leetLower characterAtIndex:(i+13)%26]];
		[rot13Map setValue:rot13char forKey:[NSString stringWithFormat:@"%C",[alphabet characterAtIndex:i]]];
 	}
	
	// Prepare map for rot13 uppercase char
	for (int i = 0; i < [alphabet length]; i++) {
		NSString *rot13char = [NSString stringWithFormat:@"%C",[leetUpper characterAtIndex:(i+13)%26]];
		[rot13Map setValue:rot13char forKey:[NSString stringWithFormat:@"%C",[[alphabet uppercaseString] characterAtIndex:i]]];
 	}
	
    // Convert input text
	NSString *converted = @"";
	for (int i = 0; i < [textViewValue length]; i++) {
		NSString *c = [NSString stringWithFormat:@"%C",[textViewValue characterAtIndex:i]];
		NSString *rot13 = [rot13Map objectForKey:c];
		if (rot13 == nil) {
			converted = [converted stringByAppendingString:c];
		} else {
			converted = [converted stringByAppendingString:rot13];
		}
	}
    
	textView.text = converted;
}

// This function encode input text using rot13 algorithm, then apply it l33t swaps
- (void)cipherButtonPressed:(id)sender {
	
	if ([self.chooseAlgoButton.title isEqualToString:ALGO_ROT13_LEET]) {
        [self cipherRot13Leet];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_ROT13]) {
        [self cipherRot13];
        
    }
}

- (void)chooseAlgoButtonPressed:(id)sender {

    AlgorithmSelectorViewController *selectorViewController = [[AlgorithmSelectorViewController alloc] initWithNibName:@"AlgorithmSelectorViewController" bundle:nil];
    selectorViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    selectorViewController.parentView = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(![popoverController isPopoverVisible]){
            // Popover is not visible
            popoverController = [[UIPopoverController alloc] initWithContentViewController:selectorViewController];
            [popoverController setPopoverContentSize: CGSizeMake(320.0, selectorViewController.tableView.rowHeight * 5.5) animated:YES];
            [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            [popoverController dismissPopoverAnimated:YES];
            popoverController = nil;
        }
        
    } else {
        [self.navigationController presentModalViewController:selectorViewController animated:YES];
        [selectorViewController release];
    }
}

@end