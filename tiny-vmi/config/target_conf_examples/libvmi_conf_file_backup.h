#ifndef LIBVMI_CONF_FILE_COMMON_H
#define LIBVMI_CONF_FILE_COMMON_H

#include "tiny_private.h"

/*
* the following char array is auto generated by unix command 
*       $ xxd -i libvmi.conf
*/


extern unsigned char libvmi_conf[] ;

extern unsigned int libvmi_conf_len ;


#if ENABLE_LINUX == 1

/*
* define system_map_string for Linux
* change this if use another system map
* all the System_map_* variables are declared here, and
* defined at file /tiny-vmi/config/libvmi_conf_file_sysmap_*.c
* the definition is generated by xxd command which coverts a file
* to ASCII string codes: xxd -i System_map_*

*/

#define linux_system_map_string_SRC_FILE "/tiny-vmi/config/libvmi_conf_file_sysmap_4_4_0_32.c"
#define linux_system_map_string System_map_4_4_0_31_generic_32
#define linux_system_map_string_len System_map_4_4_0_31_generic_32_len

//extern unsigned char System_map_4_4_0_31_generic_32[];
//extern unsigned int System_map_4_4_0_31_generic_32_len;
extern unsigned char System_map_3_19_0_25_generic[];
extern unsigned int System_map_3_19_0_25_generic_len;

#endif // ENABLE_LINUX == 1

/*
* in: char* vm_name
*
* in: char[] libvmi_conf: defined in libvmi_conf_file.h, act as 
*		string version of config file in ~/etc/libvmi.conf in the
*		original LibVMI.
* out/return: char * config: configure string for vm_name
*
*/

char * get_config_from_file_string(char *vm_name);

/*
* in: char* config: configure string
* out: config_ht: configure in hashtable
*/
GHashTable * get_config_hashtable_from_string(char *config);

#endif //LIBVMI_CONF_FILE_COMMON_H
