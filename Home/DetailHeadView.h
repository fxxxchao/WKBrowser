//
//  DetailHeadView.h
//  QKParkTime
//
//  Created by 李加建 on 2017/9/11.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"

@interface DetailHeadView : UIView

@property (nonatomic ,copy)ActionBlock commentBlock;

- (void)dataWithModel:(MessageModel*)model;

@end
