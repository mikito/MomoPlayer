//
//  ViewController.m
//  MomoPlayer
//
//  Created by Mikito Yoshiya on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "PlayListViewController.h"

@implementation ViewController
@synthesize playlist;

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
    [socketIO connectToHost:HOST onPort:PORT];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(playlist)[playlist release];
    
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

-(IBAction)showPicker{
    MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] init];
    mediaPickerController.delegate = self;
    mediaPickerController.allowsPickingMultipleItems = YES;
    [self presentModalViewController:mediaPickerController animated: YES];
}

#pragma mark - MediaPicker
-(void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    /*
     MPMusicPlayerController *iPodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [iPodMusicPlayer setQueueWithItemCollection:mediaItemCollection];
    [iPodMusicPlayer play];
     */
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    
    [mediaPicker release];
    
    PlayListViewController *playlistViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    playlistViewController.playlist = mediaItemCollection;
    [self.navigationController pushViewController:playlistViewController animated:YES];
    
    
    
    //self.playlist = mediaItemCollection;
    [playlistView reloadData];
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    if(!playlist) return 0;
    return [playlist.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
		
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier] 
                autorelease];
    }
		
    // Configure the cell...
    cell.textLabel.text = [[playlist.items objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist];
    cell.detailTextLabel.text = [[playlist.items objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle];
    return cell;
}

#pragma mark - WebSocket

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
    NSLog(@"-- didReceiveMessage() >>> data: %@", [[packet.args objectAtIndex:0] objectForKey:@"echo"]);
}


@end
