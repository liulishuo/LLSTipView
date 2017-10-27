//
//  LLSTipView.m
//  LLSTipView
//
//  Created by liulishuo on 2017/10/27.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import "LLSTipView.h"

static const CGFloat kGap = 15;

@interface LLSTipView ()

@property (nonatomic, strong) NSArray<NSString *> *messageArray;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) LLSTipViewRollDirection direction;
@property (nonatomic, copy) TipViewTapBlock tapBlock;
@property (nonatomic, copy) TipViewDismissBlock dismissBlock;
@property (nonatomic, copy) TipViewMessagesBlock messageBlock;
@property (nonatomic, assign) BOOL animationFinished;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation LLSTipView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame
                 timeInterval:(NSTimeInterval)timeInterval
                    direction:(LLSTipViewRollDirection)direction
                    leftImage:(UIImage *)image
                     messages:(TipViewMessagesBlock)messageBlock
                     tapBlock:(TipViewTapBlock)tapBlock
                 dismissBlock:(TipViewDismissBlock)dismissBlock {
    NSArray *tempArray = messageBlock();
    if (tempArray.count == 0) {
        return nil;
    }
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _textFont = [UIFont systemFontOfSize:15];
        _textColor = [UIColor blackColor];
        _animationFinished = YES;
        _index = 0;
        
        _timeInterval = timeInterval;
        _messageArray = tempArray;
        _direction = direction;
        _messageBlock = messageBlock;
        _tapBlock = tapBlock;
        _dismissBlock = dismissBlock;
        
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _closeButton.frame = CGRectMake(self.bounds.size.width - height, 0, height, height);
        [_closeButton addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        CGFloat leftImageWidth = 0;
        CGFloat imageGap = 0;
        if (image) {
            leftImageWidth = 15;
            imageGap = 5;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap, (self.bounds.size.height - leftImageWidth) / 2, leftImageWidth, leftImageWidth)];
            imageView.image = image;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageView];
        }
        
        for (int i = 0; i < 2; i ++) {
            
            CGFloat positionY = 0;
            
            switch (_direction) {
                case LLSTipViewRollDirectionDown:
                    positionY = i * (- height);
                    break;
                case LLSTipViewRollDirectionUp:
                    positionY = i * height;
                    break;
                default:
                    break;
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kGap + leftImageWidth + imageGap, positionY, width - (kGap + leftImageWidth + imageGap) - _closeButton.bounds.size.width, height)];
            label.textColor = _textColor;
            label.font = _textFont;
            [self addSubview:label];
            label.tag = i + 100;
        }
        
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToSelect)];
        [self addGestureRecognizer:tap];
        
        if (_messageArray.count != 1) {
            [_timer invalidate];
            _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(refresh) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        
        NSString *title = _messageArray[_index];
        
        UILabel *label = [self viewWithTag:100];
        label.text = title;
    }
    
    return self;
}

- (void)reloadData {
    NSArray *tempArray = _messageBlock();
    if (tempArray.count == 0) {
        return;
    } else if (tempArray.count == 1) {
        [_timer invalidate];
        _messageArray = tempArray;
        [self reset];
    } else {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _messageArray = tempArray;
    }
}
#pragma mark - Private Methods
- (void)reset {
    _index = 0;
    
    UILabel *label1 = [self viewWithTag:100];
    UILabel *label2 = [self viewWithTag:101];
    
    NSString *title1 = _messageArray[_index];
    
    label1.text = nil;
    label2.text = nil;
    
    [self.layer removeAllAnimations];
    _animationFinished = YES;
    
    if (label1.center.y > 0 && label1.center.y < self.bounds.size.height) {
        label1.text = title1;
    } else {
        label2.text = title1;
    }
}

- (void)refresh {
    _index = [self nextIndex];
    
    UILabel *label1 = [self viewWithTag:100];
    UILabel *label2 = [self viewWithTag:101];
    
    NSString *title1 = _messageArray[[self preIndex]];
    NSString *title2 = _messageArray[_index];
    
    label1.text = title1;
    label2.text = title2;
    
    if (_animationFinished) {
        _animationFinished = NO;
        
        CGFloat upperPointY = - self.center.y / 2;
        CGFloat lowerPointY = self.bounds.size.height + self.center.y / 2;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            label2.center = label1.center;
            
            CGFloat centerY = 0;
            
            switch (_direction) {
                case LLSTipViewRollDirectionDown:
                    centerY = lowerPointY;
                    break;
                case LLSTipViewRollDirectionUp:
                    centerY = upperPointY;
                    break;
                default:
                    break;
            }
            
            label1.center = CGPointMake(label1.center.x, centerY);
            
        } completion:^(BOOL finished) {
            
            if (!finished) {
                return;
            }
            
            label2.tag = 100;
            label1.tag = 101;
            
            CGFloat centerY = 0;
            
            switch (_direction) {
                case LLSTipViewRollDirectionDown:
                    centerY = upperPointY;
                    break;
                case LLSTipViewRollDirectionUp:
                    centerY = lowerPointY;
                    break;
                default:
                    break;
            }
            
            label1.center = CGPointMake(label1.center.x, centerY);
            
            _animationFinished = YES;
        }];
    }
}

- (NSUInteger)preIndex {
    NSUInteger tempIndex = _index - 1;
    
    if (tempIndex == -1) {
        tempIndex = _messageArray.count - 1;
    }
    
    return tempIndex;
}

- (NSUInteger)nextIndex {
    NSUInteger tempIndex = _index + 1;
    
    if (tempIndex == _messageArray.count) {
        tempIndex = 0;
    }
    
    return tempIndex;
}

- (void)clickToRemove:(id)sender {
    [self removeFromSuperview];
    
    if (_dismissBlock) {
        _dismissBlock();
    }
}

- (void)tapToSelect {
    if (_tapBlock) {
        _tapBlock(_index);
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [_timer invalidate];
    
    _timer = nil;
}

- (NSArray<UILabel *> *)fetchTextLabels {
    NSMutableArray *tempArray = [NSMutableArray new];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 100 ||
            obj.tag == 101) {
            UILabel *label = obj;
            [tempArray addObject:label];
        }
    }];
    
    return tempArray.copy;
}
#pragma mark - Setter and Getter
- (void)setTextFont:(UIFont *)textFont {
    NSArray *labels = [self fetchTextLabels];
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.font = textFont;
    }];
}

- (void)setTextColor:(UIColor *)textColor {
    NSArray *labels = [self fetchTextLabels];
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.textColor = textColor;
    }];
}

- (void)setCloseButton:(UIButton *)closeButton {
    if (closeButton) {
        closeButton.frame = _closeButton.frame;
        [_closeButton removeFromSuperview];
        _closeButton = closeButton;
        [_closeButton addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    } else {
        [_closeButton removeFromSuperview];
    }
    
    NSArray *labels = [self fetchTextLabels];
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!closeButton) {
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width + self.bounds.size.height, label.frame.size.height);
        }
        
    }];
}
@end
