//
//  CountDownLabel.h
//  AttributerString
//
//  Created by zhangao on 2019/8/18.
//  Copyright © 2019 张奥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountDownLabel : UILabel
@property (nonatomic, assign) NSInteger count;
-(void)startCountDown;
@end

NS_ASSUME_NONNULL_END
