//#include "tiny_GetVaOfVectorInIDT.h"
#include "tiny_libvmi.h"
#include "tiny_private.h"


addr_t GetVaOfVectorInIDT(vmi_instance_t vmi,int IndexInIDT)
{
	status_t status = VMI_FAILURE;
	addr_t VirtualAddressOfHandleFunction = 0;

	uint64_t idt=0;
	uint64_t gdt=0;
	addr_t idt_phy, idt_pfn, idt_mem;
	addr_t gdt_phy, gdt_pfn, gdt_mem;

	status=tiny_get_vcpureg_hvm(vmi, &idt,IDTR_BASE,0);
	status=tiny_get_vcpureg_hvm(vmi, &gdt,GDTR_BASE,0);
	
	dbprint(VMI_DEBUG_TEST, "--LELE: %s, get IDTR_BASE:0x%.16"PRIx64"\n",__FUNCTION__,idt);
	dbprint(VMI_DEBUG_TEST, "--LELE: %s, get GDTR_BASE:0x%.16"PRIx64"\n",__FUNCTION__,gdt);

 	vmi_translate_kv2p (vmi, idt, &idt_phy);
 	vmi_translate_kv2p (vmi, gdt, &gdt_phy);

	if( 0 == idt_phy || 0 == gdt_phy)
	{
		dbprint(VMI_DEBUG_TEST, "translate kv2p failed!\n");
		return status;
	}
	else
	{
		dbprint(VMI_DEBUG_TEST, "virtaul address(idt):0x%.16"PRIx64",physical address:0x%.16"PRIx64"\n",idt,idt_phy);
		dbprint(VMI_DEBUG_TEST, "virtaul address(gdt):0x%.16"PRIx64",physical address:0x%.16"PRIx64"\n",gdt,gdt_phy);
	}
	
	idt_pfn=idt_phy >> vmi->page_shift;
	gdt_pfn=gdt_phy >> vmi->page_shift;

	dbprint(VMI_DEBUG_TEST, "--LELE: %s: idt_pfn:0x%.16"PRIx64" for domain : %d\n",__FUNCTION__,idt_pfn,vmi->domainid);
	dbprint(VMI_DEBUG_TEST, "--LELE: %s: gdt_pfn:0x%.16"PRIx64" for domain : %d\n",__FUNCTION__,gdt_pfn,vmi->domainid);

	sleep(2);

	idt_mem=xen_get_memory_pfn(vmi,idt_pfn,PROT_READ);

	gdt_mem=xen_get_memory_pfn(vmi,gdt_pfn,PROT_READ);

	
	PP2C_IDTENTRY idt_addr = (PP2C_IDTENTRY)idt_mem;

	PP2C_GDTENTRY gdt_addr=(PP2C_GDTENTRY)gdt_mem;

	dbprint(VMI_DEBUG_TEST, "--LELE: %s: idt_addr:0x%.16"PRIx64" for domain : %d\n",__FUNCTION__,idt_addr,vmi->domainid);
	dbprint(VMI_DEBUG_TEST, "--LELE: %s: gdt_addr:0x%.16"PRIx64" for domain : %d\n",__FUNCTION__,gdt_addr,vmi->domainid);

	idt_addr += IndexInIDT;

	DWORD  offset = P2C_MAKELONG(idt_addr->offset_low,idt_addr->offset_high);

	dbprint(VMI_DEBUG_TEST, "--LELE: %s: P2C_MAKELONG done\n",__FUNCTION__);

	WORD newcs;
	newcs=idt_addr->selector;
	newcs=newcs/8;


	dbprint(VMI_DEBUG_TEST, "--LELE: %s: newcs(=idt_addr->selector):0x%.16"PRIx64"\n",__FUNCTION__,newcs);

	gdt_addr+=newcs;

	DWORD base=gdt_addr->base1+gdt_addr->base2*0x100+gdt_addr->base3*0x10000+gdt_addr->base4*0x1000000;

	VirtualAddressOfHandleFunction=base+offset;

	dbprint(VMI_DEBUG_TEST, "Int %d interrupt Function Address=%X\n",IndexInIDT,VirtualAddressOfHandleFunction);

	//tiny_print_hex(idt_pfn,idt_mem,XC_PAGE_SIZE);

	return VirtualAddressOfHandleFunction;
/*
  PP2C_IDTENTRY idt_addr = (PP2C_IDTENTRY)p2cGetIdt();
  DWORD  offset = P2C_MAKELONG(idt_addr->offset_low,idt_addr->offset_high);
  newcs=idt_addr->selector;
  newcs=newcs/8;
  PP2C_GDTENTRY gdt_addr=(PP2C_GDTENTRY)p2cGetGdt();
  gdt_addr+=newcs;
  DWORD base=gdt_addr->base1+gdt_addr->base2*0x100+gdt_addr->base3*0x10000+gdt_addr->base4*0x1000000;
  DWORD realadr=base+offset;
  DbgPrint("Int 0 interrupt Function Address=%X",realadr);
  return STATUS_DEVICE_CONFIGURATION_ERROR;
*/
} 

void test_idt_vector(vmi_instance_t vmi,int IndexInIDT){
	
	addr_t vector_pfn, vector_phy, vector_mem;

	addr_t vector_vaddr=GetVaOfVectorInIDT(vmi,IndexInIDT);

	if( VMI_FAILURE == vector_vaddr )
	{
		dbprint(VMI_DEBUG_TEST, "GetVaOfVectorInIDT failed\n");
	}else{
		dbprint(VMI_DEBUG_TEST, "--LELE:%s:GetVaOfVectorInIDT succeed:0x%.16"PRIx64"\n",__FUNCTION__,vector_vaddr);
	}

	vmi_translate_kv2p (vmi, vector_vaddr, &vector_phy );

	if( 0 == vector_phy)
	{
		dbprint(VMI_DEBUG_TEST, "translate kv2p failed!\n");
		return ;
	}
	else
	{
		dbprint(VMI_DEBUG_TEST, "virtaul address(idt):0x%.16"PRIx64",physical address:0x%.16"PRIx64"\n",vector_vaddr,vector_phy);
	}
	
	vector_pfn=vector_phy >> vmi->page_shift;

	dbprint(VMI_DEBUG_TEST, "--LELE: %s: vector_pfn:0x%.16"PRIx64" for domain : %d\n",__FUNCTION__,vector_pfn,vmi->domainid);

	sleep(2);

	vector_mem=xen_get_memory_pfn(vmi,vector_pfn,PROT_READ);

	tiny_print_hex(vector_pfn,vector_mem,XC_PAGE_SIZE);

}
