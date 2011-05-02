//
//  RSSFeedTableViewController.m
//  CWCoreData
//  Created by Fredrik Olsson 
//
//  Copyright (c) 2011, Jayway AB All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Jayway AB nor the names of its contributors may 
//       be used to endorse or promote products derived from this software 
//       without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL JAYWAY AB BE LIABLE FOR ANY DIRECT, INDIRECT, 
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "RSSFeedTableViewController.h"
#import "RSSItem.h"

@implementation RSSFeedTableViewController

#pragma mark --- Instance life cycle

-(void)awakeFromNib;
{
	[super awakeFromNib];
    
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                       ascending:NO]];
    _fetchedResultsController = [[NSFetchedResultsController fetchedResultsControllerForEntityName:@"RSSItem"
                                                                                   sortDescriptors:sortDescriptors] retain];
    [_fetchedResultsController setDelegate:self];
    [_fetchedResultsController performFetch:NULL];
    
    NSURL* url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
	[RSSItem fetchRSSItemsInBackgroundFromURL:url];
}

- (void)dealloc;
{
	[_fetchedResultsController release];
    [super dealloc];
}


#pragma mark --- UITableViewDataSource conformance

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [[_fetchedResultsController.sections objectAtIndex:0] numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines = 3;
    }
    
	RSSItem* item = [_fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = item.title;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"\t%@\n%@", [item localizedDate], item.preamble];
    
    return cell;
}

#pragma mark --- UITableViewDelegate conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
	RSSItem* item = [_fetchedResultsController objectAtIndexPath:indexPath];
    [[UIApplication sharedApplication] openURL:item.URL];
}


#pragma mark --- NSFetchedResultsControllerDelegate conformance

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
	[self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    NSAssert(type == NSFetchedResultsChangeInsert, @"Only handle inserts of items");
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
	[self.tableView endUpdates];
}

@end

