//
//  GAConstants.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 23/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAConstants.h"

@implementation GAConstants

const uint32_t kGACategoryPlane         = 0x1 << 0;
const uint32_t kGACategoryGround        = 0x1 << 1;
const uint32_t kGACategoryCollectable   = 0x1 << 2;

NSString *const kGATilesetGrass = @"Grass";
NSString *const kGATilesetDirt = @"Dirt";
NSString *const kGATilesetIce = @"Ice";
NSString *const kGATilesetSnow = @"Snow";

@end
