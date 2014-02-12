//
//  CFNetworkController.h
//  gitauthentication
//
//  Created by Brad on 2/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFNetworkController : NSObject
- (void)handleOAuthCallbackWithURL:(NSURL *)url;

-(void)requestOAuthAccess;



@end
