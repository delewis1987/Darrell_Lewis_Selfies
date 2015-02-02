//
//  SelfiesService.m
//  Selfies
//
//  Created by Unbounded Solutions on 1/27/15.
//
//

#import "SelfiesService.h"
#import "Constants.h"

@implementation SelfiesService


-(void) getImageUrls {
    
    NSString *url;
    
    if (self.minimumTagId) {
        url = [NSString stringWithFormat:@"%@&min_tag_id=%@", KInstagramEndpoint, self.minimumTagId];
    }
    else {
        
        url = KInstagramEndpoint;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    
                    typeof(self) strongSelf = weakSelf;
                
                NSError *jsonParseError = nil;
                
                NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
                
                if (!jsonParseError) {
                    
                    if ([responseDict objectForKey:@"pagination"]) {
                        NSDictionary *pagDict = [responseDict objectForKey:@"pagination"];
                        
                        if ([pagDict  objectForKey: @"min_tag_id"]) {
                            strongSelf.minimumTagId = [pagDict objectForKey:@"min_tag_id"];
                        }
                        
                        NSArray *imageDictArray;
                        
                        if ([responseDict objectForKey:@"data"]) {
                            imageDictArray = [responseDict objectForKey:@"data"];
                            
                            NSMutableArray *imageReturnArray = [[NSMutableArray alloc] init];
                            
                            for (NSDictionary *imageDict in imageDictArray) {
                                if ([imageDict objectForKey:@"images"]) {
                                    NSDictionary *images = [imageDict objectForKey:@"images"];
                                    if ([images objectForKey:@"standard_resolution"]) {
                                        [imageReturnArray addObject:[images objectForKey:@"standard_resolution"]];
                                    }
                                }
                            }  dispatch_sync(dispatch_get_main_queue(), ^{
                                
                                 typeof(self) strongSelf = weakSelf;
                            
                                if ([strongSelf.delegate respondsToSelector:@selector(returnedResults:)]) {
                                
                                [strongSelf.delegate returnedResults:imageReturnArray];
                                    
                            }
                                    });
                            
                        }
                    }

                    
                    
                }
                    
                }
               
            }] resume];

    
}


@end
