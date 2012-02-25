//
//  ViewController.m
//  MomoPlayer
//
//  Created by Mikito Yoshiya on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController
//@synthesize playlist;
@synthesize playlists;

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
    socket = [[SocketIO alloc] initWithDelegate:self];
    [socket connectToHost:HOST onPort:PORT];
    
    playlistViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    playlistViewController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(playlists)[playlists release];
    [socket release];
    
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
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    
    [mediaPicker release];
    
    //PlayListViewController *playlistViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (MPMediaItem *item in mediaItemCollection.items) {
        NSDictionary *song = [[NSDictionary alloc] initWithObjectsAndKeys:
                [item valueForProperty:MPMediaItemPropertyArtist], @"artist",
                [item valueForProperty:MPMediaItemPropertyTitle], @"title",
                nil
        ];
        [list addObject:song];
        [song release];
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          list, @"playlist", nil];
    
    [socket sendEvent:@"makePlayList" withData:data];
    [data release];
    
    [playlistViewController setPlaylist:list];
    [self.navigationController pushViewController:playlistViewController animated:YES];
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    if(!playlists) return 0;
    return [playlists count];
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
    NSNumber *join = [[playlists objectAtIndex:indexPath.row] objectForKey:@"join"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",[[playlists objectAtIndex:indexPath.row] objectForKey:@"name"], [join intValue]];
    cell.detailTextLabel.text = @"";//[[playlist.items objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //playlistViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    [playlistViewController setPlaylist:[[playlists objectAtIndex:indexPath.row] objectForKey:@"items"]];
    [self.navigationController pushViewController:playlistViewController animated:YES];
    [self join:indexPath.row];
}


#pragma mark - WebSocket

- (void) socketIODidConnect:(SocketIO *)_socket
{
    NSLog(@"-- socketIODidConnect()");
    
    // objcイベント発火。(node.js側でon('objc', function() {...})でキャッチ)
    //[_socket sendEvent:@"objc" withData:[NSDictionary dictionaryWithObject:@"hoge" forKey:@"Key"]];
    //NSLog(@"-- sendEvent()");
}

// node.jsからWebSocketでメッセージが送られてきた場合
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    // NSLog(@"-- didReceiveMessage() >>> data: %@", [[packet.args objectAtIndex:0] objectForKey:@"echo"]);
    if([packet.name isEqualToString:@"playlists"]){
        NSLog(@"Receive PlayLists");
        self.playlists = [packet.args objectAtIndex:0];
        [playlistView reloadData];
    }
    
    if([packet.name isEqualToString:@"play"]){
        NSLog(@"Play!!");
        
        NSNumber *index = [[packet.args objectAtIndex:0] objectForKey:@"index"];
        [playlistViewController playMusic:[index intValue]];
    }
}

- (void)join:(int)playlistId{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:playlistId], @"playlistid", nil];
    [socket sendEvent:@"join" withData:data];   
}

- (void)leave{
    //NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:playlistId], @"playlistid", nil];
    [socket sendEvent:@"leave" withData:nil];   
}

# pragma mark - PlayListView
-(void) play:(int)index{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:index], @"index", nil];
    [socket sendEvent:@"play" withData:data]; 
}
-(void) exitPlay{
    [self leave];
}

@end
