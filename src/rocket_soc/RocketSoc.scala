package rocket_soc

import chisel3._
import std_protocol_if._
import chisellib._
import wb_sys_ip._
import oc_wb_ip.wb_uart.WishboneUART

import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.amba.axi4._

import amba_sys_ip.axi4.Axi4WishboneBridge
import amba_sys_ip.axi4.Axi4Sram
import oc_wb_ip.wb_periph_subsys.WishbonePeriphSubsys
import amba_sys_ip.axi4.AXI4_IC
import oc_wb_ip.wb_dma.WishboneDMA
import chisel3.util.Cat

class RocketSoc(val soc_p : RocketSoc.Parameters) extends Module {
  
  val io = IO(new Bundle {
    val uart0 = new TxRxIf
  });
  
  val u_core = Module(new RocketSocCore(soc_p.ncores, soc_p.romfile))
  
  // We're not using the debug interface
  u_core.io.debug.tieoff_flipped(u_core.clock, reset.toBool())
  
  // We're not using the frontend bus either
  u_core.io.l2_frontend_bus.tieoff_flipped()
  
  val u_wb_ic = Module(new WishboneInterconnect(
      new WishboneInterconnectParameters(
            N_MASTERS=5, 
            N_SLAVES=4,
          new Wishbone.Parameters(32, 64))));
  u_wb_ic.io.addr_base(RocketSoc.S_SRAM_PORT) := 0x00000000.asUInt()
  u_wb_ic.io.addr_limit(RocketSoc.S_SRAM_PORT) := 0x00FFFFFF.asUInt()
  
  u_wb_ic.io.addr_base(RocketSoc.S_PERIPH_SS_PORT) := 0x01000000.asUInt()
  u_wb_ic.io.addr_limit(RocketSoc.S_PERIPH_SS_PORT) := 0x01000FFF.asUInt()
  
  u_wb_ic.io.addr_base(RocketSoc.S_STUB_PORT) := 0x01001000.asUInt()
  u_wb_ic.io.addr_limit(RocketSoc.S_STUB_PORT) := 0x01001FFF.asUInt()
  
  u_wb_ic.io.addr_base(RocketSoc.S_SYS_DMA) := 0x01002000.asUInt()
  u_wb_ic.io.addr_limit(RocketSoc.S_SYS_DMA) := 0x01002FFF.asUInt()
  
  val u_mmio_axi2wb = Module(new Axi4WishboneBridge(
      new Axi4WishboneBridge.Parameters(
          new AXI4.Parameters(28, 64),
          new Wishbone.Parameters(32, 64),
          Bool(true)
          )));
  
  val u_mem_axi2wb = Module(new Axi4WishboneBridge(
      new Axi4WishboneBridge.Parameters(
          new AXI4.Parameters(28, 64),
          new Wishbone.Parameters(32, 64),
          Bool(true)
          )));
 
  u_mem_axi2wb.io.t <> u_core.io.mem
  u_wb_ic.io.m(RocketSoc.M_MEM_PORT) <> u_mem_axi2wb.io.i
  
  u_mmio_axi2wb.io.t <> u_core.io.mmio
  u_wb_ic.io.m(RocketSoc.M_MMIO_PORT) <> u_mmio_axi2wb.io.i
  
  val sram = Module(new WishboneSram(new WishboneSram.Parameters(
      MEM_ADDR_BITS = 22,
      new Wishbone.Parameters(32,64),
      INIT_FILE = "ram.hex")))
  sram.io.s <> u_wb_ic.io.s(RocketSoc.S_SRAM_PORT)

  // The peripheral subsystem is connected via a width converter
  val mmio_width_converter = Module(new WishboneWide2Narrow(
      new Wishbone.Parameters(32, 64),
      new Wishbone.Parameters(32, 32)))

  // Connect the IC to Periph Subsys width converter
  u_wb_ic.io.s(RocketSoc.S_PERIPH_SS_PORT) <> mmio_width_converter.io.i

  // Peripheral Subsystem
  val u_periph_subsys = Module(new WishbonePeriphSubsys(new Wishbone.Parameters(32,32)))
  mmio_width_converter.io.o <> u_periph_subsys.io.s
  io.uart0 <> u_periph_subsys.io.uart0
  
  // System DMA
  val u_sys_dma = Module(new WishboneDMA())
  val u_sys_wc_s = Module(new WishboneWide2Narrow(
      new Wishbone.Parameters(32, 64),
      new Wishbone.Parameters(32, 32)))
  val u_sys_wc_m0 = Module(new Wishbone32To64())
  val u_sys_wc_m1 = Module(new Wishbone32To64())
  
  u_sys_wc_s.io.i <> u_wb_ic.io.s(RocketSoc.S_SYS_DMA)
  u_sys_dma.io.s <> u_sys_wc_s.io.o
  u_sys_wc_m0.io.i <> u_sys_dma.io.m0
  u_sys_wc_m0.io.o <> u_wb_ic.io.m(RocketSoc.M_SYS_DMA_M0)
  u_sys_wc_m1.io.i <> u_sys_dma.io.m1
  u_sys_wc_m1.io.o <> u_wb_ic.io.m(RocketSoc.M_SYS_DMA_M1)
//  u_sys_dma.io.m0.rsp.ACK := Bool(false)
//  u_sys_dma.io.m0.rsp.ERR := Bool(false)
//  u_sys_dma.io.m0.rsp.DAT_R := 0.asUInt()
//  u_sys_dma.io.m0.rsp.TGD_R := 0.asUInt()
//  
//  u_sys_dma.io.m1.rsp.ACK := Bool(false)
//  u_sys_dma.io.m1.rsp.ERR := Bool(false)
//  u_sys_dma.io.m1.rsp.DAT_R := 0.asUInt()
//  u_sys_dma.io.m1.rsp.TGD_R := 0.asUInt()
  
  // Tie off the handshake signals
  u_sys_dma.io.dma_req_i := 0.asUInt()
  u_sys_dma.io.dma_nd_i := 0.asUInt()
  u_sys_dma.io.dma_rest_i := 0.asUInt()
      
 
  // Up-size the 32-bit peripheral interconnect interface to 64
  val periph2ic_width_converter = Module(new Wishbone32To64())
  periph2ic_width_converter.io.i <> u_periph_subsys.io.m
  u_wb_ic.io.m(RocketSoc.M_PERIPH_SS_PORT) <> periph2ic_width_converter.io.o
  
  u_core.io.irq := Cat(
      u_sys_dma.io.inta_o,
      u_periph_subsys.io.irq
      )
 
  // Dummy target for use by the trickbox
  val u_sp = Module(new WishboneDummySlave())
  u_sp.io.s <> u_wb_ic.io.s(RocketSoc.S_STUB_PORT)
  
}

object RocketSoc {
  val M_MEM_PORT = 0
  val M_MMIO_PORT = 1
  val M_PERIPH_SS_PORT = 2
  val M_SYS_DMA_M0 = 3
  val M_SYS_DMA_M1 = 4
  
  val S_PERIPH_SS_PORT = 0
  val S_STUB_PORT = 1
  val S_SRAM_PORT = 2
  val S_SYS_DMA = 3
  
  class Parameters(
      val romfile : String = "/bootrom/bootrom.img",
      val ncores : Int = 4
      ) { }
}

