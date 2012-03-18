//
//  Simple_ROT13AppDelegate.h
//  Simple ROT13
//
//  Created by Arnaud Boudou on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Simple_ROT13ViewController;

@interface Simple_ROT13AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet Simple_ROT13ViewController *viewController;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end

