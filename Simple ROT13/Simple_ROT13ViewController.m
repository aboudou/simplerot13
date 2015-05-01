//
//  Simple_ROT13ViewController.m
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "Simple_ROT13ViewController.h"
#import "AlgorithmSelectorViewController.h"
#import "Algo.h"

@implementation Simple_ROT13ViewController

@synthesize textView, chooseAlgoButton, cipherButton;
@synthesize undoValue;
@synthesize popoverController;
#ifdef SIMPLE_ROT_13_FREE
@synthesize adView, bannerIsVisible;
#endif



#pragma mark - Controller/view lifecycle
- (void)viewDidLoad {

    [super viewDidLoad];

    // Localisation
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"blank_editor"]) {
        [self.textView setText:NSLocalizedString(@"Enter text to cipher", @"")];
    }
    [self.cipherButton setTitle:NSLocalizedString(@"cipherButton", @"")];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"default_cipher"] != nil && [[[NSUserDefaults standardUserDefaults] stringForKey:@"default_cipher"] length] > 0) {
        [self.chooseAlgoButton setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"default_cipher"]];
    }

    [self registerForKeyboardNotifications];

    [self.navigationController.navigationBar setTranslucent:NO];
    
#ifdef SIMPLE_ROT_13_FREE
    //self.adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
    self.adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    [self.view addSubview:self.adView];
    self.bannerIsVisible = NO;
#endif
    
}


- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];

#ifdef SIMPLE_ROT_13_FREE
    adView.frame = CGRectOffset(adView.frame, 0, -[self getBannerHeight]);
    
    adView.delegate=self;
    self.bannerIsVisible=NO;
#endif
}

// Allow view to become the first responder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// Set view as first responder in order to immediately respond to shakes
- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

// iOS from 6.0
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#ifdef SIMPLE_ROT_13_FREE
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (self.bannerIsVisible) {
        
        float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
        float deviceWidth = [[UIScreen mainScreen] bounds].size.width;
        
        // On redimensionne la textView, dans le cas de l'iPhone la bannière n'a pas la même hauteur en portrait et paysage.
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            textView.frame = CGRectMake(0, [self getBannerHeight], deviceHeight, deviceWidth-([self getTopHeight]+[self getBannerHeight]));
        } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            textView.frame = CGRectMake(0, [self getBannerHeight], deviceWidth, deviceHeight-([self getTopHeight]+[self getBannerHeight]));
        }
    }
}
#endif

- (void)didReceiveMemoryWarning {
    
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    self.undoValue = nil;
}

#ifdef SIMPLE_ROT_13_FREE
- (void)dealloc {
    adView.delegate = nil;
}
#endif



#ifdef SIMPLE_ROT_13_FREE
#pragma mark - ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!self.bannerIsVisible) {
        self.bannerIsVisible = YES;
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, [self getBannerHeight]);
        CGRect rect = textView.frame;
        textView.frame = CGRectMake(rect.origin.x, rect.origin.y + [self getBannerHeight], rect.size.width, rect.size.height - [self getBannerHeight]);
        [UIView commitAnimations];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        self.bannerIsVisible = NO;
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -[self getBannerHeight]);
        CGRect rect = textView.frame;
        textView.frame = CGRectMake(rect.origin.x, rect.origin.y - [self getBannerHeight], rect.size.width, rect.size.height + [self getBannerHeight]);
        [UIView commitAnimations];
    }
}
#endif


#pragma mark - Keyboard management functions

- (void)keyboardWasShown:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
    float deviceWidth = [[UIScreen mainScreen] bounds].size.width;

    float bannerHeight = 0.0f;
#ifdef SIMPLE_ROT_13_FREE
    if (bannerIsVisible) {
        bannerHeight = [self getBannerHeight];
    } else {
        bannerHeight = 0.0f;
    }
#endif
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        textView.frame = CGRectMake(0, bannerHeight, deviceHeight, deviceWidth-([self getTopHeight]+bannerHeight+kbSize.width));
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        textView.frame = CGRectMake(0, bannerHeight, deviceWidth, deviceHeight-([self getTopHeight]+bannerHeight+kbSize.height));
    }
    
    [UIView commitAnimations];    
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
    float deviceWidth = [[UIScreen mainScreen] bounds].size.width;

    float bannerHeight = 0.0f;
#ifdef SIMPLE_ROT_13_FREE
    if (bannerIsVisible) {
        bannerHeight = [self getBannerHeight];
    } else {
        bannerHeight = 0.0f;
    }
#endif
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        textView.frame = CGRectMake(0, bannerHeight, deviceHeight, deviceWidth-([self getTopHeight]+bannerHeight));
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        textView.frame = CGRectMake(0, bannerHeight, deviceWidth, deviceHeight-([self getTopHeight]+bannerHeight));
    }
    
    [UIView commitAnimations];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - UI management functions

// On device shaking, undo previous encoding
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        if (self.undoValue != nil && ![self.undoValue isEqualToString:@""]) {
            textView.text = undoValue;
        }
    }
}



#pragma mark - Cipher functions
// This function calculate MD2 hash of input text
- (void)cipherMd2 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_MD2_DIGEST_LENGTH];
    
    // Create MD2 hash value, store in buffer
    CC_MD2(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD2_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate MD4 hash of input text
- (void)cipherMd4 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_MD4_DIGEST_LENGTH];
    
    // Create MD4 hash value, store in buffer
    CC_MD4(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD4_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate MD5 hash of input text
- (void)cipherMd5 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_MD5_DIGEST_LENGTH];
    
    // Create MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
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

// This function encode input text using rot47 algorithm
- (void)cipherRot47 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    NSString *source = @"!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    
    NSMutableDictionary *rot47Map = [NSMutableDictionary dictionaryWithCapacity:94];
    
    // Prepare map for rot47 lowercase char
    for (int i = 0; i < [source length]; i++) {
        NSString *rot47char = [NSString stringWithFormat:@"%C",[source characterAtIndex:(i+47)%94]];
        [rot47Map setValue:rot47char forKey:[NSString stringWithFormat:@"%C",[source characterAtIndex:i]]];
    }
    
    // Convert input text
    NSString *converted = @"";
    for (int i = 0; i < [textViewValue length]; i++) {
        NSString *c = [NSString stringWithFormat:@"%C",[textViewValue characterAtIndex:i]];
        NSString *rot47 = [rot47Map objectForKey:c];
        if (rot47 == nil) {
            converted = [converted stringByAppendingString:c];
        } else {
            converted = [converted stringByAppendingString:rot47];
        }
    }
    
    textView.text = converted;
    
}

// This function calculate SHA-1 hash of input text
- (void)cipherSha1 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_SHA1_DIGEST_LENGTH];
    
    // Create SHA-1 hash value, store in buffer
    CC_SHA1(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate SHA-224 hash of input text
- (void)cipherSha224 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_SHA224_DIGEST_LENGTH];
    
    // Create SHA-224 hash value, store in buffer
    CC_SHA224(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate SHA-256 hash of input text
- (void)cipherSha256 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_SHA256_DIGEST_LENGTH];
    
    // Create SHA-256 hash value, store in buffer
    CC_SHA256(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate SHA-384 hash of input text
- (void)cipherSha384 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_SHA384_DIGEST_LENGTH];
    
    // Create SHA-384 hash value, store in buffer
    CC_SHA384(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}

// This function calculate SHA-512 hash of input text
- (void)cipherSha512 {
    NSString *textViewValue = textView.text;
    self.undoValue = textView.text;
    
    // Create pointer to the string as UTF8
    const char *ptr = [textViewValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashBuffer[CC_SHA512_DIGEST_LENGTH];
    
    // Create SHA-512 hash value, store in buffer
    CC_SHA512(ptr, (CC_LONG)strlen(ptr), hashBuffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",hashBuffer[i]];
    
    textView.text = output;
}


#pragma mark - Actions
// This function encode input text using rot13 algorithm, then apply it l33t swaps
- (void)cipherButtonPressed:(id)sender {
	
    if ([self.chooseAlgoButton.title isEqualToString:ALGO_ROT13_LEET]) {
        [self cipherRot13Leet];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_ROT13]) {
        [self cipherRot13];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_ROT47]) {
        [self cipherRot47];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_MD2]) {
        [self cipherMd2];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_MD4]) {
        [self cipherMd4];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_MD5]) {
        [self cipherMd5];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_SHA1]) {
        [self cipherSha1];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_SHA224]) {
        [self cipherSha224];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_SHA256]) {
        [self cipherSha256];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_SHA384]) {
        [self cipherSha384];
        
    } else if ([self.chooseAlgoButton.title isEqualToString:ALGO_SHA512]) {
        [self cipherSha512];
        
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
            [popoverController setPopoverContentSize: CGSizeMake(320.0, selectorViewController.tableView.rowHeight * 6.5) animated:YES];
            [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            [popoverController dismissPopoverAnimated:YES];
            popoverController = nil;
        }
        
    } else {
        [self.navigationController presentViewController:selectorViewController animated:YES completion:NULL];
    }

}

#pragma mark - Misc
- (float) getTopHeight {
    float navigationBarHeight = self.navigationController.navigationBar.frame.size.height;

    float statusBasHeight = 0.0f;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        statusBasHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
    } else {
        statusBasHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }

    return navigationBarHeight + statusBasHeight;
}

#ifdef SIMPLE_ROT_13_FREE
- (float) getBannerHeight {
    return adView.frame.size.height;
}
#endif

@end
