    //
//  FBViewController.m
//  bishibashi
//
//  Created by Eric on 02/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "FBViewController.h"


@implementation FBViewController

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,480-44)];
	http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://touch.facebook.com/?w2m#/profile.php?id=104123529642835"]]];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835"]]];
	[self.view addSubview:webView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
