//
//  MNNNV21ToBGRUnit.S
//  MNN
//
//  Created by MNN on 2019/02/01.
//  Copyright © 2018, Alibaba Group Holding Limited
//

#ifdef __arm__
#ifndef __aarch64__

#include "MNNAsmGlobal.h"

.text
.align 5
//void MNNNV21ToBGRUnit(const unsigned char* source, unsigned char* dest, size_t count, const unsigned char* uv);
//Auto: r0:source, r1:dest, r2:count, r3:uv
asm_function MNNNV21ToBGRUnit   // 函数名    
push {r4, lr}                   // 通用寄存器 r4 - r11 进栈保存 保护起来
vpush {q4}                      // 向量寄存器 q4 - q7
        //  Y    = Y << 6;
        // int R = (Y + 73 * (V-128)) >> 6;
        // int G = (Y - 25 * (U-128) - 37 * (V-128)) >> 6;
        // int B = (Y + 130 * (U-128)) >> 6;

mov r4, #73
vmov.i8 d31, #128
mov r12, #25
vmov.i16 d0[0], r4
vmov.i16 d0[1], r12
mov r4, #37
mov r12, #130
vmov.i16 d0[2], r4
vmov.i16 d0[3], r12
vmov.i16 q4, #0

// d0[0] === 73   d0[1] === 25    d0[2] === 37   d0[3] === 130  


LoopL1:
vld2.8 {d18, d19}, [r3]!   // NV21 数据 V在前 U在后交织排列  ld2，2表示间隔采样，d18存V，d19存U 
vsubl.u8 q11, d18, d31     // q11 存 v-128   
vld2.8 {d16, d17}, [r0]!   // y数据

vsubl.u8 q10, d19, d31    //  q10 存 u-128

//q1-q3: BGR offset
vmul.s16 q1, q10, d0[3]// + B Offset       //  q1  = 130 * (U-128)
vmul.s16 q2, q10, d0[1]                    //  q2  =  25 * (U-128)
vmla.s16 q2, q11, d0[2]// - G Offset       //  q2 +=  37 * (V-128)
vmul.s16 q3, q11, d0[0]// + R Offset       //  q3  =  73 * (V-128)

// Y    = Y << 6;
vshll.u8 q10, d16, #6  // q10 = y << 6 
vshll.u8 q11, d17, #6  // q11 = y << 6

// 合成 前 8 个
vadd.s16 q12, q10, q1  // r = q12 =  y + q1  = y +  130 * (U-128)
vsub.s16 q13, q10, q2  // g = q13 =  y - q2  = y -   25 * (U-128) - 37 * (V-128)
vadd.s16 q14, q10, q3  // b = q14 =  y + q3  = y +   73 * (V-128)

// x = max(x,0)
vmax.s16 q12, q12, q4
vmax.s16 q13, q13, q4
vmax.s16 q14, q14, q4

// x = x >> 6
vqshrn.u16 d16, q12, #6
vqshrn.u16 d17, q13, #6
vqshrn.u16 d18, q14, #6
// min(x,255) ?

vadd.s16 q12, q11, q1
vsub.s16 q13, q11, q2
vadd.s16 q14, q11, q3

vmax.s16 q12, q12, q4
vmax.s16 q13, q13, q4
vmax.s16 q14, q14, q4

vqshrn.u16 d19, q12, #6
vqshrn.u16 d20, q13, #6
vqshrn.u16 d21, q14, #6

vzip.8 d16, d19
vzip.8 d17, d20
vzip.8 d18, d21


vst3.u8 {d16, d17, d18}, [r1]!

vst3.u8 {d19, d20, d21}, [r1]!


subs r2, r2, #1
bne LoopL1

vpop {q4}
pop {r4, pc}

#endif
#endif
