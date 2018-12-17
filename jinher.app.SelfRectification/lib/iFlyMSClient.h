//
//  iFlyMSClient.h
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iFlyMSClient : NSObject

+(id)shared;

- (void)startSynContent:(NSString *)content;

@end

