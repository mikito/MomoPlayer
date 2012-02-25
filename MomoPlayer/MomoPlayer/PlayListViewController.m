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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        cell.textLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        cell.detailTextLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
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
