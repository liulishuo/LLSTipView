//
//  LLSTipView.h
//  LLSTipView
//
//  Created by liulishuo on 2017/10/27.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TipViewTapBlock)(NSUInteger index);
typedef void(^TipViewDismissBlock)(void);
typedef NSArray<NSString *> * __nonnull (^TipViewMessagesBlock)(void);

typedef NS_ENUM(NSInteger, LLSTipViewRollDirection) {
    LLSTipViewRollDirectionDown,
    LLSTipViewRollDirectionUp,
};

@interface LLSTipView : UIView

/**
 滚动信息的文字颜色 default：black
 */
@property (nonnull, nonatomic, strong) UIColor *textColor;

/**
 滚动信息的字体 default：15
 */
@property (nonnull, nonatomic, strong) UIFont *textFont;

/**
 右侧按钮
 */
@property (nullable, nonatomic, strong) UIButton *closeButton;


/**
 全能初始化方法

 @param frame frame
 @param timeInterval 滚动时间间隔
 @param direction 滚动方向
 @param image 左侧图片
 @param messageBlock 数据源block
 @param tapBlock 点击回调block
 @param dismissBlock 点击 close button 回调block
 @return tipView实例，如果数据源为空，则返回nil
 */
- (nullable instancetype)initWithFrame:(CGRect)frame
                 timeInterval:(NSTimeInterval)timeInterval
                    direction:(LLSTipViewRollDirection)direction
                    leftImage:(nullable UIImage *)image
                     messages:(nonnull TipViewMessagesBlock)messageBlock
                     tapBlock:(nullable TipViewTapBlock)tapBlock
                 dismissBlock:(nullable TipViewDismissBlock)dismissBlock NS_DESIGNATED_INITIALIZER;

/**
 刷新数据
 */
- (void)reloadData;

@end
