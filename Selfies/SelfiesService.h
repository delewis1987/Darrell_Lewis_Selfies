//
//  SelfiesService.h
//  Selfies
//
//  Created by Unbounded Solutions on 1/27/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SelfiesServiceDelegate <NSObject>

@required

-(void) returnedResults:(NSMutableArray*) results;

@end


@interface SelfiesService : NSObject

@property (weak) id <SelfiesServiceDelegate> delegate;

@property (strong) NSString *minimumTagId;

-(void) getImageUrls;

@end
