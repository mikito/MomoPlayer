//
//  PlayListViewController.m
//  MomoPlayer
//
//  Created by 吉谷 幹人 on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayListViewController.h"


@implementation PlayListViewController
//@synthesize playlist;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [delegate play:playIndex];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    iPodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    NSNotificationCenter *notificationCenter =[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playerNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:iPodMusicPlayer];
                                                            
    [iPodMusicPlayer beginGeneratingPlaybackNotifications];
    
    playIndex = 0;
    
    //[self playMusic:playIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if(playlist)[playlist release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pushBackButton{
    [self.navigationController popViewControllerAnimated:YES];
    [iPodMusicPlayer stop];
    [delegate exitPlay];
}

#pragma mark - Player
-(void) playerNotification:(id)notification{
    if(iPodMusicPlayer.playbackState == MPMusicPlaybackStateStopped){
        playIndex ++;
        if([playlist count] <= playIndex){
            // send end;
        }
        NSLog(@"Music Stopped");
    }
}

-(void)playMusic:(int)index{
    if([playlist count] <= index) return;
    
    id item = [playlist objectAtIndex:index];
    if ([item isKindOfClass:[MPMediaItem class]]) {
        NSArray *items = [[NSArray alloc] initWithObjects:(MPMediaItem *)item, nil];
        MPMediaItemCollection *mediaItemCollection = [[MPMediaItemCollection alloc] initWithItems:items];
        [iPodMusicPlayer setQueueWithItemCollection:mediaItemCollection];
        [iPodMusicPlayer play];
    }
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    if(!playlist) return 0;
    return [playlist count];
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
    id item = [playlist objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[MPMediaItem class]]) {
        MPMediaItem *mediaItem = (MPMediaItem *)item;
        cell.textLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        cell.detailTextLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
    }else{
        NSDictionary *mediaItem = (NSDictionary *)item;
        cell.textLabel.text = @"You Don't have this song";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@", [mediaItem valueForKey:@"artist"], [mediaItem valueForKey:@"title"]];
    }
    
    return cell;
}

-(void) setPlaylist:(NSArray *)items{
    if(playlist)[playlist release];
    
    playlist = [[NSMutableArray alloc] init];

    for (NSDictionary *item in items) {
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate *predicate;
        
        NSString *artist = [item objectForKey:@"artist"];
        NSString *title = [item objectForKey:@"title"];
        //NSLog(@"%@ - %@", artist, title);
        
        predicate = [MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist];
        [query addFilterPredicate:predicate];
        predicate = [MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle];
        [query addFilterPredicate:predicate];
        
        if([query.items count] != 0){
            NSLog(@"Item:%@",[[query.items objectAtIndex:0] valueForProperty:MPMediaItemPropertyTitle]);
            [playlist addObject:[query.items objectAtIndex:0]];
        }else{
            [playlist addObject:item];
            //NSStringFromClass([obj class]);
        }
        [query release];
        
        [playlistView reloadData];
    }
    
}
                                     
                            
@end
