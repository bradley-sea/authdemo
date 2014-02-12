//
//  CFAppDelegate.h
//  gitauthentication
//
//  Created by Brad on 2/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFNetworkController.h"

@interface CFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) CFNetworkController *networkController;

@end
