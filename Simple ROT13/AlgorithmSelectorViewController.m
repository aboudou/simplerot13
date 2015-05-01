//
//  AlgorithmSelectorViewController.m
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/04/11.
//  Copyright 2011 aboudou. All rights reserved.
//

#import "AlgorithmSelectorViewController.h"
#import "Algo.h"

static NSString *const kAlgoKey =  @"algorithms";
static NSString *const kTitleKey = @"title";

@implementation AlgorithmSelectorViewController

@synthesize parentView;
@synthesize algoList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

    self.title = NSLocalizedString(@"Algorithm", @"");

#ifdef SIMPLE_ROT_13_FREE
    algoList = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  ALGO_ROT13, ALGO_ROT13_LEET,
                  nil], kAlgoKey,
                 @"Rotate", kTitleKey,
                 nil],
                
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Get Simple ROT13", @""),
                  nil], kAlgoKey,
                 NSLocalizedString(@"Tired of ads ?", @""), kTitleKey,
                 nil],
                
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Get Simple ROT13 Premium", @""),
                  nil], kAlgoKey,
                 NSLocalizedString(@"Need more ?", @""), kTitleKey,
                 nil],
                
                nil];
#endif

#ifdef SIMPLE_ROT_13
    algoList = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  ALGO_ROT13, ALGO_ROT13_LEET,
                  nil], kAlgoKey,
                 @"Rotate", kTitleKey,
                 nil],
                
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Get Simple ROT13 Premium", @""),
                  nil], kAlgoKey,
                 NSLocalizedString(@"Need more ?", @""), kTitleKey,
                 nil],
                
                nil];
#endif
    
#ifdef SIMPLE_ROT_13_PREMIUM
    algoList = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  ALGO_MD2, ALGO_MD4, ALGO_MD5,
                  nil], kAlgoKey,
                 @"Message Digest", kTitleKey,
                 nil],
                
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  ALGO_ROT13, ALGO_ROT13_LEET, ALGO_ROT47,
                  nil], kAlgoKey,
                 @"Rotate", kTitleKey,
                 nil],
                
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:
                  ALGO_SHA1, ALGO_SHA224, ALGO_SHA256, ALGO_SHA384, ALGO_SHA512,
                  nil], kAlgoKey,
                 @"Secure Hash Algorithm", kTitleKey,
                 nil],
                nil];
#endif

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [algoList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[algoList objectAtIndex:section] objectForKey:kAlgoKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *name = [[[algoList objectAtIndex:indexPath.section] objectForKey:kAlgoKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:ALGO_ROT13_LEET]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_ROT13]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_ROT47]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_MD2]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_MD4]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_MD5]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_SHA1]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_SHA224]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_SHA256]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_SHA384]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:ALGO_SHA512]) {
        cell.textLabel.text = name;

    } else if ([name isEqualToString:NSLocalizedString(@"Get Simple ROT13 Premium", @"")]) {
        cell.textLabel.text = name;
        
    } else if ([name isEqualToString:NSLocalizedString(@"Get Simple ROT13", @"")]) {
        cell.textLabel.text = name;
        
    }
    
    if ([self.parentView.chooseAlgoButton.title isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = 0;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[algoList objectAtIndex:section] objectForKey:kTitleKey];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[[algoList objectAtIndex:indexPath.section] objectForKey:kAlgoKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:NSLocalizedString(@"Get Simple ROT13", @"")]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app//simple-rot13/id429616214"]];
    } else if ([name isEqualToString:NSLocalizedString(@"Get Simple ROT13 Premium", @"")]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/simple-rot13-premium/id433594344"]];
    } else {
        self.parentView.chooseAlgoButton.title = name;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.parentView.popoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
