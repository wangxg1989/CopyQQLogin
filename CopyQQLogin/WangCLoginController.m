//
//  WangCLoginController.m
//  WangCai
//
//  Created by 风往北吹_ on 16/3/10.
//  Copyright © 2016年 wangxg. All rights reserved.
//

#import "WangCLoginController.h"
#import "Masonry.h"

@interface WangCLoginController ()<UITextFieldDelegate> {
    int userIDCount;
}

@property (nonatomic, weak) IBOutlet UIView *accountAndPassedView;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *dropButton;

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIView *mask;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveUpConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHeaderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddenHeaderConstraint;

@end

@implementation WangCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userIDCount = 5;
    _mask.hidden = YES;

    [self p_generateContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_moveUpConstraint setPriority:UILayoutPriorityDefaultHigh];
    [_removeConstraint setPriority:UILayoutPriorityDefaultLow];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self p_animationWithSelectedHeaderImage:NO];
    return YES;
}


#pragma mark - event response

- (IBAction)onAnimateClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self p_animationWithSelectedHeaderImage:!button.selected];
}

- (void)onSelectedHeaderImage:(UIGestureRecognizer *)sender {
    UIView *view = sender.view;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%li", view.tag]];
    _headerImageView.image = image;
    
    // 缩回
    [self p_animationWithSelectedHeaderImage:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


#pragma mark -

- (void)p_generateContent {
    UIView* contentView = UIView.new;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    UIView *lastView;
    for (int index = 0; index < userIDCount; index++) {
        UIView *view = UIView.new;
        [contentView addSubview:view];
        view.tag = index;
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i", index]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(72));
            make.height.equalTo(@(72));
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
            
            imageView.layer.cornerRadius = 36;
            imageView.layer.masksToBounds = YES;
        }];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectedHeaderImage:)];
        [view addGestureRecognizer:singleTap];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lastView ? lastView.mas_trailing : @0).with.mas_offset(30);
            make.top.equalTo(@0);
            make.height.equalTo(contentView.mas_height);
            make.width.equalTo(@(72));
        }];

        lastView = view;
    }
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}

- (void)p_animationWithSelectedHeaderImage:(BOOL)state {
    if (state) {
        [_dropButton setSelected:YES];
        [_showHeaderConstraint setPriority:UILayoutPriorityDefaultLow];
        [_hiddenHeaderConstraint setPriority:UILayoutPriorityDefaultHigh];
        [UIView animateWithDuration:0.35 animations:^{
            [self.accountAndPassedView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _mask.hidden = NO;
            [_accountTextField resignFirstResponder];
            [_passwordTextField resignFirstResponder];
        }];
    } else {
        [_dropButton setSelected:NO];
        [_showHeaderConstraint setPriority:UILayoutPriorityDefaultHigh];
        [_hiddenHeaderConstraint setPriority:UILayoutPriorityDefaultLow];
        [UIView animateWithDuration:0.35 animations:^{
            [self.accountAndPassedView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _mask.hidden = YES;
        }];
    }

}
@end
