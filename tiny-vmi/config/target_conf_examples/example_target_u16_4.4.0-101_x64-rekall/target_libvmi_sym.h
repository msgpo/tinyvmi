#ifndef TARGET_LIBVMI_COMMON_H
#define TARGET_LIBVMI_COMMON_H

// /**
// * If sysmap is used: 

// * define system_map_string for Linux
// * change this if use another system map
// * all the System_map_* variables are declared here, and
// * defined at file /tiny-vmi/config/target_libvmi_sysmap.c
// * the definition is generated by xxd command which coverts a file
// * to ASCII string codes: xxd -i System_map_*

// */

// #ifndef SYM_FILE_FROM_STRING
// #define SYM_FILE_FROM_STRING
// #endif

// #ifdef REKALL_FILE_FROM_STRING
// #undef REKALL_FILE_FROM_STRING
// #endif

// #define linux_system_map_string System_map_4_4_0_101_generic
// #define linux_system_map_string_len System_map_4_4_0_101_generic_len

// extern unsigned char System_map_4_4_0_101_generic[];
// extern unsigned int System_map_4_4_0_101_generic_len;

// #define linux_system_map_string_SRC_FILE "/tiny-vmi/config/target_libvmi_sysmap.c"


/**
* If rekall file is used:
*
* - following https://github.com/google/rekall/tree/master/tools/linux to generate rekall files for linux
* - convert .json rekall file to C string using xxd -i
* 
*/

#ifdef SYM_FILE_FROM_STRING
#undef SYM_FILE_FROM_STRING
#endif

#ifndef REKALL_FILE_FROM_STRING
#define REKALL_FILE_FROM_STRING
#endif

#define guest_rekall_string ubuntu16_4_4_0_101_generic_json
#define guest_rekall_string_len ubuntu16_4_4_0_101_generic_json_len

extern unsigned char ubuntu16_4_4_0_101_generic_json[];
extern unsigned int ubuntu16_4_4_0_101_generic_json_len;

#define guest_rekall_string_SRC_FILE "string"

#endif // TARGET_LIBVMI_COMMON_H

