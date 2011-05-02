//
//  NSFetchRequest+CWAdditions.m
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

#import "CWCoreData.h"


@implementation NSFetchRequest (CWCoreData)

+(NSFetchRequest*)requestForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName];
    [fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	return [fetchRequest autorelease];	
}

@end


@implementation NSFetchedResultsController (CWCoreData)

+(NSFetchedResultsController*)fetchedResultsControllerForEntityName:(NSString*)entityName sortDescriptors:(NSArray*)sortDescriptors sectionNameKeyPath:(NSString*)keyPath predicate:(NSPredicate*)predicate;
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [NSFetchRequest requestForEntityName:entityName
                                                          withPredicate:predicate
                                                        sortDescriptors:sortDescriptors];
    // Edit the entity name as appropriate.
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                managedObjectContext:[NSManagedObjectContext threadLocalContext] 
                                                                                                  sectionNameKeyPath:keyPath 
                                                                                                           cacheName:nil];
    
	return [aFetchedResultsController autorelease];	
}

+(NSFetchedResultsController*)fetchedResultsControllerForEntityName:(NSString*)name sortDescriptors:(NSArray*)sortDescriptors sectionNameKeyPath:(NSString*)keyPath;
{
	return [self fetchedResultsControllerForEntityName:name 
                                       sortDescriptors:sortDescriptors 
                                    sectionNameKeyPath:keyPath 
                                             predicate:nil];
}

+(NSFetchedResultsController*)fetchedResultsControllerForEntityName:(NSString*)name sortDescriptors:(NSArray*)sortDescriptors;
{  
	return [self fetchedResultsControllerForEntityName:name 
                                       sortDescriptors:sortDescriptors 
                                    sectionNameKeyPath:nil];
}

@end
