//
//  HHSystemTools.m
//  iosDev
//
//  Created by kingdee on 2024/2/22.
//

#import "HHSystemTools.h"
#include <unistd.h>
#include <sys/syscall.h>
#include <dlfcn.h>
#include <string.h>

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

int anti_debug(void) {
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    if (handle) {
        int (*ptrace_ptr)(int, pid_t, caddr_t, int) = dlsym(handle, "ptrace");
        if (ptrace_ptr) {
            if (ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0) == -1) {
                dlclose(handle);
                return 1;
            }
        }
        dlclose(handle);
    }
    return 0;
}


@implementation HHSystemTools

+ (void)forbiddenReleaseDebug {
    
#ifndef DEBUG
    anti_debug();
#endif
}

@end
