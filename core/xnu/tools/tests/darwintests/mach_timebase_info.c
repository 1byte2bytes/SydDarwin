#include <mach/mach_time.h>

#include <darwintest.h>

extern kern_return_t mach_timebase_info_trap(mach_timebase_info_t info);

T_DECL(mach_timebase_info, "mach_timebase_info(_trap)",
		T_META_ALL_VALID_ARCHS(YES))
{
	mach_timebase_info_data_t a, b, c;

	T_ASSERT_EQ(KERN_SUCCESS, mach_timebase_info(&a), NULL);
	T_ASSERT_EQ(KERN_SUCCESS, mach_timebase_info(&b), NULL);
	T_ASSERT_EQ(KERN_SUCCESS, mach_timebase_info_trap(&c), NULL);

	T_EXPECT_EQ(a.numer, b.numer, NULL);
	T_EXPECT_EQ(a.denom, b.denom, NULL);
	T_EXPECT_EQ(a.numer, c.numer, NULL);
	T_EXPECT_EQ(a.denom, c.denom, NULL);
}
