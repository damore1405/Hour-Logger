//
//  main.m
//  Hour Logger
//
//  Created by Matthew D'Amore on 9/15/15.
//  Copyright (c) 2015 Matthew Damore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSURL * loginPageUrl = [[NSURL alloc] initWithString:@"https://login.drexel.edu/cas/login"];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:loginPageUrl];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse * response;

        
        NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSError * error = nil;
        NSString * lt_token_value = nil;
        NSString * execution_token_value = nil;
        HTMLParser * parser = [[HTMLParser alloc] initWithData:returnData error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return 1;
        }
        
        HTMLNode * body = [parser body];
        NSArray * inputNodes = [body findChildTags:@"input"];
        for(HTMLNode * node in inputNodes){
            //Need to find the hidden input values of "lt" and "execution"
            if ([[node getAttributeNamed:@"name"] isEqualToString:@"lt"]) {
                lt_token_value = [node getAttributeNamed:@"value"];
            }
            if ([[node getAttributeNamed:@"name"] isEqualToString:@"execution"]) {
                execution_token_value = [node getAttributeNamed:@"value"];
            }
        }
        if (lt_token_value == nil || execution_token_value == nil) {
            NSLog(@"couldn't find the values for lt or execution token!");
            return 1;
        }
        NSLog(@"lt token value: %@",lt_token_value);
        NSLog(@"execution token value: %@",execution_token_value);
        
        
        
        
        
//Code to submit the form once the login token has been loaded.
        
        returnData = [NSData new];
        response = nil;

        NSString * username = @"msd88";
        NSString * password = @"deam0n594";
        
        NSString * form_string = [NSString stringWithFormat:@"username=%@&password=%@&lt=%@&execution=%@&_eventId=submit&submit=Connect", username, password, lt_token_value, execution_token_value];

        // Okey lets set up the http request with the forum data to be sent to the server...
        [request setHTTPMethod:@"POST"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: [form_string dataUsingEncoding:NSUTF8StringEncoding]];
        
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
//        NSLog(@"REQUEST HEADERS: \n %@", [[request allHTTPHeaderFields] description]);
//        NSLog(@"REQUEST DATA: \n %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
        NSLog(@"RESPONSE HEADERS: \n %@", [[response allHeaderFields] description] );
//        NSLog(@"RESPONSE DATA: \n %@", [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
        
        
        
        NSURL * testUrl = [[NSURL alloc] initWithString:@"https://login.drexel.edu/cas/login?service=https%3A%2F%2Fbannersso.drexel.edu%3A443%2Fssomanager%2Fc%2FSSB%3Fpkg%3Dtwbkwbis.P_GenMenu%3Fname%3Dbmenu.P_MainMnu%26msg%3DWELCOME"];
        NSMutableURLRequest * testRequest = [[NSMutableURLRequest alloc] initWithURL:testUrl];
//        [request setURL:[[NSURL alloc] initWithString:@"https://bannersso.drexel.edu/ssomanager/c/SSB?pkg=twbkwbis.P_GenMenu?name=bmenu.P_MainMnu&msg=WELCOME"]];
        [testRequest setHTTPMethod:@"GET"];
        [testRequest setValue:@"https://login.drexel.edu/cas/login;jsessionid=EB411AB1714D6EA4CA64529AFD59EA76" forHTTPHeaderField:@"Referer"];
        [testRequest setValue:@"SESSID=RzY3NDBQMzkyNTYwOA==; IDMSESSID=msd88; CASTGC=TGT-3948-ZTmkecBs5vfrhD4MSaHG4kkZMx3whWtfCb9544tvcrtJChpIUA-pike.irt.drexel.edu" forHTTPHeaderField:@"Cookie"];
        [testRequest setValue:@"bannersso.drexel.edu" forHTTPHeaderField:@"Host"];
        returnData = nil;
        response = nil;
        returnData = [NSURLConnection sendSynchronousRequest:testRequest returningResponse:&response error:nil];
        
        NSLog(@"RESPONSE HEADERS: \n %@", [[response allHeaderFields] description] );
        NSLog(@"status code: %ld", (long)[response statusCode]);
        NSLog(@"Response DATA: \n %@", [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);

    }
    return 0;
}
//        Some old header setting that doesnt seem to be needed anymore...
//
//        [request setValue:@"JSESSIONID=DE8E2A1296DF5BD4F23486B6799EB23F" forHTTPHeaderField:@"Cookie"];
//        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[form_string length]] forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
//        [request setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
//        [request setValue:@"https://login.drexel.edu" forHTTPHeaderField:@"Origin"];
//        [request setValue:@"login.drexel.edu" forHTTPHeaderField:@"Host"];
//        [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
//        [request setValue:@"1" forHTTPHeaderField:@"DNT"];
//        [request setValue:@"https://login.drexel.edu/cas/login" forHTTPHeaderField:@"Referer"];
//        [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
//        [request setValue:@"en-US,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];


