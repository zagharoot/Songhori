//
//  AccountManager.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountManager.h"
#import "GoogleMapList.h"
#import "GoogleMapAccount.h"

static AccountManager* theAccountManager;

@implementation AccountManager
@synthesize coreModel=model; 
@synthesize coreContext = context; 

@synthesize accounts = _accounts; 
@synthesize delegate=_delegate; 

//perform the singleton pattern
+(AccountManager*) standardAccountManager
{
    if (theAccountManager == nil)
    {
        theAccountManager = [[AccountManager alloc] init]; 
        [theAccountManager setupAccounts]; 
    }

    return theAccountManager;     
}



-(void) save
{
    for (Account* a in self.accounts) {
        if (a.active)
            [a save]; 
    }
}


-(BOOL) syncData
{
    BOOL result = NO; 
    for (Account* a in self.accounts) {
        [syncProgress setValue:@"NO" forKey:a.accountName]; 
        if (a.active)
            if ([a syncData])
            {
                result = YES; 
                [syncProgress setValue:@"YES" forKey:a.accountName]; 
            }
    }
    
    return result; 
}



-(int) NUMBER_OF_ACCOUNTS
{    
    return self.accounts.count; 
}

-(void) setupAccounts
{
    //load the fixed accounts 
    _accounts = [[NSMutableArray alloc] initWithCapacity:5]; 
    accountRequestProgress = [[NSMutableDictionary alloc] initWithCapacity:2]; 
    syncProgress = [[NSMutableDictionary alloc] initWithCapacity:2]; 
    
    //add food network account 
    FNAccount* fni = [[[FNAccount alloc] init] autorelease]; 
    fni.delegate = self; 
    [_accounts addObject:fni]; 
    [accountRequestProgress setValue:@"NO" forKey:fni.accountName]; 
    [syncProgress setValue:@"NO" forKey:fni.accountName]; 
    
    
    YelpAccount* yi = [[[YelpAccount alloc] init] autorelease]; 
    [accountRequestProgress setValue:@"NO" forKey:yi.accountName]; 
    [syncProgress setValue:@"NO" forKey:yi.accountName]; 
    yi.delegate = self; 
    [_accounts addObject:yi]; 
    //WEBSITE: 
    
    
    //load dynamic accounts 
    NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease]; 
    NSEntityDescription* e = [[model entitiesByName] objectForKey:@"GoogleMapList"]; 
    fetchRequest.entity = e; 
    
    NSArray* gl =  [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];
    
    for (GoogleMapList* ga in gl) {
        GoogleMapAccount* ac = [[GoogleMapAccount alloc] initWithGoogleMapList:ga]; 
        [_accounts addObject:ac]; 
        ac.delegate = self; 
        [accountRequestProgress setValue:@"NO" forKey:ga.url]; 
        [syncProgress setValue:@"NO"  forKey:ga.url]; 
        [ac release]; 
    }
    
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        //load the yelp user object from database
        model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];         
        NSPersistentStoreCoordinator* prs = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model]; 
        
        
        //get the path to the document folder 
        NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentRootPath = [documentPaths objectAtIndex:0];
        
        NSString* path = [NSString stringWithFormat:@"%@/yelp.data", documentRootPath]; 
        NSURL* curl = [NSURL fileURLWithPath:path]; 
        NSError* error = nil; 
        
        if (![prs addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:curl options:nil error:&error])
        {
            [prs release]; 
            return nil; 
        }
        
        context = [[NSManagedObjectContext alloc] init]; 
        context.persistentStoreCoordinator = prs; 
        [prs release]; 
        context.undoManager = nil; 
    }
    
    return self;
}

-(BOOL) hasAnyActiveAccount
{
    if (!_accounts)
        [self setupAccounts]; 

    for (Account* a in self.accounts) {
        if ( a.active)
            return YES; 
    }
    
    return NO; 
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    for (Account* a in self.accounts) {
        [accountRequestProgress setValue:@"NO" forKey:a.accountName]; 
        if (a.active)
            [accountRequestProgress setValue:@"YES" forKey:a.accountName]; 
    }
    
    for (Account* a in self.accounts) 
    {
        if (a.active)
        {
            [a sendRestaurantsInRegion:region zoomLevel:zoomLevel]; 
        }
    }    
}




-(void) dealloc
{
    [accountRequestProgress release]; 
    [syncProgress release]; 
    [_accounts release]; 
    
    [super dealloc]; 
}

-(Account*) getAccountAtIndex:(int)index
{
    //todo: error check! 
    return [self.accounts objectAtIndex:index]; 
}



#pragma mark - delegate methods 


-(void) syncFinished:(id) provider
{
    [syncProgress setValue:@"NO" forKey:[provider accountName]]; 
    
    for (Account* a in self.accounts) {
        NSString* str = @"YES"; 
        
        if ([str compare:[syncProgress valueForKey:a.accountName]]== NSOrderedSame)
            return; 
    }
    
    //all accounts are done. notify delegat if it reacts to it 
    if (self.delegate && [self.delegate respondsToSelector:@selector(syncFinished:)])
        [self.delegate syncFinished:self]; 
}


-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    [accountRequestProgress setValue:@"NO" forKey:[provider accountName]]; 
    [self.delegate restaudantDataDidBecomeAvailable:restaurants forRegion:region fromProvider:self]; 
    
    for (Account* a in self.accounts) {
        NSString* str = @"YES"; 
        
        if ([str compare:[accountRequestProgress valueForKey:a.accountName]]== NSOrderedSame)
            return; 
    }
    
    //all accounts are done. notify delegat if it reacts to it 
    if (self.delegate && [self.delegate respondsToSelector:@selector(allDataForRequestSent)])
        [self.delegate performSelector:@selector(allDataForRequestSent)]; 
}



@end
