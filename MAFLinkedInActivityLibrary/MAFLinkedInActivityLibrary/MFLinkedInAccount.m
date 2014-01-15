//
//  MFLinkedInAccount.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAccount.h"
#import "UICKeyChainStore.h"


@implementation MFLinkedInAccount


- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize self.
        
        // Uncomment to see all items in keychain
        //NSLog(@"_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
        
        // Uncomment to remove all items from keychain
        //[self removeAllItemsFromKeyChain];
        //NSLog(@"AFTER--_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
    }
    return self;
}


#pragma mark - Custom Getters, To abstract the keychain operation

-(NSString*)username {
    
    return [UICKeyChainStore stringForKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)accessToken {
    
    return [UICKeyChainStore stringForKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)expiresIn {
    
    return [UICKeyChainStore stringForKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)tokenIssueDateString {
    
    return [UICKeyChainStore stringForKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}




#pragma mark - Custom Setters

-(void)setUsername:(NSString *)username {
    
    [UICKeyChainStore setString:username forKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setAccessToken:(NSString *)accessToken {
    
    [UICKeyChainStore setString:accessToken forKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setExpiresIn:(NSString *)expiresIn {
    
    [UICKeyChainStore setString:expiresIn forKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setTokenIssueDateString:(NSString *)tokenIssueDateString {
    
    [UICKeyChainStore setString:tokenIssueDateString forKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}





#pragma mark - Access Token Refresh Mechanism

-(BOOL)tokenNeedsToBeRefreshed {
    
    // 1. Convert "token_issue_date_string" NSString to NSDate using the tokenIssueDateString property
    
    NSDate *tokenIssueDate = [self dateFromString:[self tokenIssueDateString]];
    
    
    // 2. Convert expires_in NSString to NSDate using tokenIssueDate and the expiresIn property
    
    NSTimeInterval expires_in = [[NSNumber numberWithInt:[[self expiresIn] doubleValue]] doubleValue];
    
    NSDate *tokenExpirationDate = [NSDate dateWithTimeInterval:expires_in sinceDate:tokenIssueDate];
    //NSLog(@"Access Token Expiration Date: %@",tokenExpirationDate);
    
    
    // 3. Create an NSDate representing 'n' days before the access_token expiration date.
    //    NOTE: the value you pass to the dateWithDays:FromDate: method's 'days' parameter will be the number of days.
    
    NSDate *daysBeforeExpiration = [self dateWithDays:-10 FromDate:tokenExpirationDate];
    //NSLog(@"daysBeforeExpiration:         %@",daysBeforeExpiration);
    
    
    // 4. If daysBeforeExpiration is earlier in time than (the current Date) return YES to indicate the access_token needs to be refreshed.
    //    Otherwise return NO to indicate the access_token doesn't yet need to be refreshed.
    
    return ([daysBeforeExpiration compare:[NSDate date]] == NSOrderedAscending);
    
    
    
    // Date math tests
    /*
    NSDate *testDate = [self dateWithDays:-1 FromDate:tokenExpirationDate];
    NSLog(@"testDate:                     %@",testDate);
    return ([testDate compare:tokenExpirationDate] == NSOrderedAscending);
     */
}



#pragma mark - Helper Methods

-(NSString*)stringFromDate:(NSDate *)date {
          
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(NSDate*)dateFromString:(NSString*)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter dateFromString:string];
}

-(NSDate*)dateWithDays:(NSInteger)days FromDate:(NSDate*)date {
    
    NSDateComponents *daysBeforeComponents = [[NSDateComponents alloc]init];
    
    daysBeforeComponents.day = days;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:daysBeforeComponents toDate:date options:0];
}



#pragma mark - Delete Account From Keychain

-(void)removeAllItemsFromKeyChain {
    
    [UICKeyChainStore removeAllItemsForService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}


@end
