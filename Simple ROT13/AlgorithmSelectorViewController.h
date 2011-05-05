//
//  AlgorithmSelectorViewController.h
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/04/11.
//  Copyright 2011 aboudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Simple_ROT13ViewController.h"

@interface AlgorithmSelectorViewController : UITableViewController {
    NSArray *_algoList;
    Simple_ROT13ViewController *parentView;
}

@property (nonatomic, retain) Simple_ROT13ViewController *parentView;

@end
