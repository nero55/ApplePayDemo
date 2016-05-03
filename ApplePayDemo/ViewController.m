//
//  ViewController.m
//  ApplePayDemo
//
//  Created by Alvechen on 16/2/20.
//  Copyright © 2016年 alvechen. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    PKPaymentButton *btn = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleBlack];
    
    [btn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)buyAction{
    
    //1.判断是否支持
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"商品 1" amount:[NSDecimalNumber decimalNumberWithMantissa:12 exponent:-2 isNegative:NO]];
        
        PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"商品 2" amount:[NSDecimalNumber decimalNumberWithMantissa:13 exponent:-2 isNegative:NO] ];
        
        PKPaymentSummaryItem *itemTotal = [PKPaymentSummaryItem summaryItemWithLabel:@"传智博客" amount:[NSDecimalNumber decimalNumberWithMantissa:25 exponent:-2 isNegative:NO] type:PKPaymentSummaryItemTypeFinal];
        
        
        //项目
        request.paymentSummaryItems = @[item1,item2,itemTotal];
        //国家代码 和 货币代码
        request.countryCode = @"CN";
        request.currencyCode = @"CNY";
        
        //网络
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa];
        
        //付款给哪个商户
        request.merchantIdentifier = @"merchant.cn.itcast.ApplePayDemo1";
        //卡类型
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        
        //弹出付款界面
        PKPaymentAuthorizationViewController *payVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        
        payVC.delegate = self;
        
        if (payVC) {
            [self presentViewController:payVC animated:YES completion:nil];
        }
        
 
        
        
    }

    
}


#warning mark - PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{

    
    if (payment.token) {
        
        completion(PKPaymentAuthorizationStatusSuccess);
        
        NSLog(@"付款成功!");
        
    }else{
    
        completion(PKPaymentAuthorizationStatusFailure);
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    
    NSLog(@"付款完成");
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}


@end
