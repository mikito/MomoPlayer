//
//  ViewController.m
//  MomoPlayer
//
//  Created by Mikito Yoshiya on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // WebSocket接続
    SocketIO *socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:3000];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"-- socketIODidConnect()");
    
    // objcイベント発火。(node.js側でon('objc', function() {...})でキャッチ)
    [socket sendEvent:@"objc" withData:[NSDictionary dictionaryWithObject:@"hoge" forKey:@"Key"]];
    NSLog(@"-- sendEvent()");
}

// node.jsからWebSocketでメッセージが送られてきた場合
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"-- didReceiveMessage() >>> data: %@", packet.data);
}


@end
