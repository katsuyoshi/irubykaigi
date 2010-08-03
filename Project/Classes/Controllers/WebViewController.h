//
//  WebViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/03.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>  {

    UIWebView *webView;
    NSURL *url;
    NSURL *domainUrl;
    NSURL *requestedUrl;
    NSURL *blankUrl;
    
    UIActivityIndicatorView *activityIndicatorView;
    
    int retryCount;
    UIAlertView *alertView;
}

+ (WebViewController *)webViewController;

@property (assign) NSString *fileName;
@property (retain) NSURL *url;
@property (retain) NSURL *domainUrl;
@property (retain) NSURL *requestedUrl;
@property (retain, readonly) NSURL *blankUrl;


@end
