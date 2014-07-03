//
//  NSDictionary+ConverttoString.m
//  RotaryWheelProject
//
//  Created by Bharat Aghera on 26/11/13.
//  Copyright (c) 2013 Tristate. All rights reserved.
//

#import "NSDictionary+ConverttoString.h"

@implementation NSDictionary (ConverttoString)

+(NSDictionary *) getStringBasedDictionary:(NSDictionary *) dict
{
    NSMutableDictionary *dictOutput=[NSMutableDictionary dictionary];

    for (NSObject *obj in dict) {
        
        if([[dict objectForKey:obj] isKindOfClass:[NSArray class]])
        {
            
      [dictOutput setObject:[self getArray:[dict objectForKey:obj]] forKey:[NSString stringWithFormat:@"%@",obj]];
        }
        else if([[dict objectForKey:obj] isKindOfClass:[NSDictionary class]])
        {
        [dictOutput setObject:[NSDictionary getStringBasedDictionary:[dict objectForKey:obj]] forKey:[NSString stringWithFormat:@"%@",obj]];
        }
        
        else
        {
            [dictOutput setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:obj]] forKey:[NSString stringWithFormat:@"%@",obj]];
        }
    }
    return dictOutput;
}

+(NSMutableArray *) getArray:(NSArray *)arrTemp
{
    NSMutableArray *arrLocal=[NSMutableArray array];
    for (NSObject *obj in arrTemp) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arrLocal addObject:[NSDictionary getStringBasedDictionary:[NSDictionary dictionaryWithDictionary:obj]]];
        }
    }
    
    return arrLocal;
}


@end
