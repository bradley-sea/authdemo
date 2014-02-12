//
//  CFViewController.m
//  gitauthentication
//
//  Created by Brad on 2/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "CFViewController.h"
#import "CFAppDelegate.h"

@interface CFViewController ()
@property (weak,nonatomic) CFAppDelegate *appDelegate;

@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (CFAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.networkController = self.appDelegate.networkController;
    
    [self.networkController performSelector:@selector(requestOAuthAccess) withObject:Nil afterDelay:.1];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
