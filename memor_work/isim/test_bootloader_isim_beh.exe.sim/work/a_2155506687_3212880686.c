/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xcb73ee62 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Documents and Settings/lester/Escritorio/OOOOOOO/memor_work/bootloader.vhd";



static void work_a_2155506687_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    unsigned char t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(203, ng0);
    t1 = (t0 + 684U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 2960U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB7;

LAB8:    t3 = (unsigned char)0;

LAB9:    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 4444);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(204, ng0);
    t1 = (t0 + 4496);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(206, ng0);
    t2 = (t0 + 1144U);
    t6 = *((char **)t2);
    t11 = *((unsigned char *)t6);
    t2 = (t0 + 4496);
    t7 = (t2 + 32U);
    t8 = *((char **)t7);
    t12 = (t8 + 40U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t11;
    xsi_driver_first_trans_fast(t2);
    goto LAB3;

LAB7:    t2 = (t0 + 2984U);
    t5 = *((char **)t2);
    t9 = *((unsigned char *)t5);
    t10 = (t9 == (unsigned char)3);
    t3 = t10;
    goto LAB9;

}

static void work_a_2155506687_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    static char *nl0[] = {&&LAB3, &&LAB4, &&LAB5, &&LAB6};

LAB0:    xsi_set_current_line(216, ng0);
    t1 = (t0 + 1052U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (char *)((nl0) + t3);
    goto **((char **)t1);

LAB2:    t1 = (t0 + 4452);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(219, ng0);
    t4 = (t0 + 776U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    if (t7 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(222, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB9:    goto LAB2;

LAB4:    xsi_set_current_line(226, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 10201);
    t3 = 1;
    if (2U == 2U)
        goto LAB14;

LAB15:    t3 = 0;

LAB16:    if (t3 != 0)
        goto LAB11;

LAB13:    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 10221);
    t3 = 1;
    if (2U == 2U)
        goto LAB22;

LAB23:    t3 = 0;

LAB24:    if (t3 != 0)
        goto LAB20;

LAB21:    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 10233);
    t3 = 1;
    if (2U == 2U)
        goto LAB30;

LAB31:    t3 = 0;

LAB32:    if (t3 != 0)
        goto LAB28;

LAB29:    xsi_set_current_line(240, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB12:    goto LAB2;

LAB5:    xsi_set_current_line(244, ng0);
    t1 = (t0 + 4712);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(245, ng0);
    t1 = (t0 + 10235);
    t4 = (t0 + 4748);
    t5 = (t4 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 6U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(246, ng0);
    t1 = (t0 + 4784);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(247, ng0);
    t1 = (t0 + 4820);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(248, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB6:    xsi_set_current_line(251, ng0);
    t1 = (t0 + 776U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t6 = (t3 == (unsigned char)3);
    if (t6 != 0)
        goto LAB36;

LAB38:    xsi_set_current_line(254, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB37:    goto LAB2;

LAB7:    xsi_set_current_line(258, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB8:    xsi_set_current_line(220, ng0);
    t4 = (t0 + 4532);
    t8 = (t4 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)1;
    xsi_driver_first_trans_fast(t4);
    goto LAB9;

LAB11:    xsi_set_current_line(227, ng0);
    t9 = (t0 + 10203);
    t11 = (t0 + 4568);
    t13 = (t11 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t9, 8U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(228, ng0);
    t1 = (t0 + 10211);
    t4 = (t0 + 4604);
    t5 = (t4 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(229, ng0);
    t1 = (t0 + 4640);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(230, ng0);
    t1 = (t0 + 10213);
    t4 = (t0 + 4676);
    t5 = (t4 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 8U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(231, ng0);
    t1 = (t0 + 4532);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)1;
    xsi_driver_first_trans_fast(t1);
    goto LAB12;

LAB14:    t12 = 0;

LAB17:    if (t12 < 2U)
        goto LAB18;
    else
        goto LAB16;

LAB18:    t5 = (t2 + t12);
    t8 = (t1 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t8))
        goto LAB15;

LAB19:    t12 = (t12 + 1);
    goto LAB17;

LAB20:    xsi_set_current_line(233, ng0);
    t9 = (t0 + 10223);
    t11 = (t0 + 4604);
    t13 = (t11 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t9, 2U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(234, ng0);
    t1 = (t0 + 4640);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t8 = *((char **)t5);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(235, ng0);
    t1 = (t0 + 10225);
    t4 = (t0 + 4676);
    t5 = (t4 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 8U);
    xsi_driver_first_trans_fast(t4);
    goto LAB12;

LAB22:    t12 = 0;

LAB25:    if (t12 < 2U)
        goto LAB26;
    else
        goto LAB24;

LAB26:    t5 = (t2 + t12);
    t8 = (t1 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t8))
        goto LAB23;

LAB27:    t12 = (t12 + 1);
    goto LAB25;

LAB28:    xsi_set_current_line(238, ng0);
    t9 = (t0 + 4532);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t13 = (t11 + 40U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)2;
    xsi_driver_first_trans_fast(t9);
    goto LAB12;

LAB30:    t12 = 0;

LAB33:    if (t12 < 2U)
        goto LAB34;
    else
        goto LAB32;

LAB34:    t5 = (t2 + t12);
    t8 = (t1 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t8))
        goto LAB31;

LAB35:    t12 = (t12 + 1);
    goto LAB33;

LAB36:    xsi_set_current_line(252, ng0);
    t1 = (t0 + 4532);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB37;

}


extern void work_a_2155506687_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2155506687_3212880686_p_0,(void *)work_a_2155506687_3212880686_p_1};
	xsi_register_didat("work_a_2155506687_3212880686", "isim/test_bootloader_isim_beh.exe.sim/work/a_2155506687_3212880686.didat");
	xsi_register_executes(pe);
}
