//
//  CFNetworkController.m
//  gitauthentication
//
//  Created by Brad on 2/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//
#define GITHUB_CALLBACK_URI @"gitauth://git_callback"
#define GITHUB_CLIENT_ID @"c7ad97a698663e523718"
#define GITHUB_OAUTH_URL  @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_CODE_EXCHANGE_URL @"POST https://github.com/login/oauth/access_token/?client_id=%@&client_secret=%@&code=%@&redirect_uri=%@"
#define GITHUB_CLIENT_SECRET @"7a8cf82f69f64d963e28ea77260a1cbba80172df"

#import "CFNetworkController.h"

@interface CFNetworkController ()

@property (strong,nonatomic) NSString *accessToken;

@end

@implementation CFNetworkController


- (void)handleOAuthCallbackWithURL:(NSURL *)url {
    
    NSString *code = [self convertURLintoCode:url];
    
    NSString *post =[NSString stringWithFormat: @"client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,code,GITHUB_CALLBACK_URI];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error)
        {
            NSLog(@"error: %@",error.description);
        }
        
        self.accessToken = [self convertResponseIntoToken:data];
        
        NSString *repoString = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", self.accessToken];
        
        NSURL *repoURL = [NSURL URLWithString:repoString];
        NSData *repoData = [NSData dataWithContentsOfURL:repoURL];
        NSError *repoerror;
        NSMutableDictionary *repoDict = [NSJSONSerialization JSONObjectWithData:repoData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&repoerror];
        NSLog(@"%@",repoDict);
        
    }];
    
    [postDataTask resume];
    
//    
//    NSURLResponse *response;
//    NSError *error;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
//    NSString *repoString = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", self.accessToken];
//    
//    NSURL *repoURL = [NSURL URLWithString:repoString];
//    NSData *repoData = [NSData dataWithContentsOfURL:repoURL];
//    NSError *repoerror;
//    NSMutableDictionary *repoDict = [NSJSONSerialization JSONObjectWithData:repoData
//                                                                      options:NSJSONReadingMutableContainers
//                                                                        error:&repoerror];
//    NSLog(@"%@",repoDict);
    

}

-(NSString *)convertURLintoCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSLog(@"%@",components);
    NSArray *params = [components[0] componentsSeparatedByString:@"="];
    NSLog(@"%@",params);
    return params[1];
}

-(NSString *)convertResponseIntoToken:(NSData *)data
{
     NSString *tokenResponse = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *tokencomponents = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *accesstokenwithcode = [tokencomponents objectAtIndex:0];
    NSArray *access_token_array = [accesstokenwithcode componentsSeparatedByString:@"="];
    return access_token_array[1];
}

-(void)requestOAuthAccess
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    NSLog(@" %@", urlString);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
