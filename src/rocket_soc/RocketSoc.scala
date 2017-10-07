package rocket_soc

import chisel3._
import std_protocol_if._
import wb_sys_ip._
import oc_wb_ip.wb_uart.WishboneUART
import rocketchip.ExampleRocketTop
import config._
import diplomacy.LazyModule
import rocketchip._
import rocketchip.ExampleRocketTop
import coreplex.WithNBigCores
import coreplex.WithBootROMFile
import chisellib.Plusargs
import diplomacy.LazyMultiIOModuleImp
import uncore.devices.TLROM
import uncore.axi4.AXI4BundleParameters
import uncore.axi4.AXI4Bundle
import amba_sys_ip.axi4.Axi4WishboneBridge
import amba_sys_ip.axi4.Axi4Sram

class RocketSoc(val soc_p : RocketSoc.Parameters) extends Module {
  
  val io = IO(new Bundle {
    val uart0 = new UartIf
  });
 
  val u_core = Module(new RocketSocCore(2, soc_p.romfile))
 
  // We're not using the debug interface
  u_core.io.debug.tieoff_flipped(u_core.clock, u_core.reset)
  
  // We're not using the frontend bus either
  u_core.io.l2_frontend_bus.tieoff_flipped()

  val sram = Module(new Axi4Sram(new Axi4Sram.Parameters(
      MEM_ADDR_BITS = 12,
      u_core.mem_p,
      INIT_FILE = "ram.hex")))
  sram.io.s <> u_core.io.mem

  val mmio_sram = Module(new Axi4Sram(new Axi4Sram.Parameters(
      MEM_ADDR_BITS = 12,
      u_core.mmio_p)))
  mmio_sram.io.s <> u_core.io.mmio
      
//  val mmio_axi4_wb_bridge = Module(new Axi4WishboneBridge(
//      u_core.mmio_p, 
//      new Wishbone.Parameters(31, 64)))
//  mmio_axi4_wb_bridge.io.t <> u_core.io.mmio
//      
//  val mmio_width_converter = Module(new WishboneWide2Narrow(
//      new Wishbone.Parameters(31, 64),
//      new Wishbone.Parameters(31, 32)))
//
//  val periph_ic = Module(new WishboneInterconnect(
//      new WishboneInterconnectParameters(
//          N_MASTERS = 1,
//          N_SLAVES = 1,
//          wb_p = new Wishbone.Parameters(32, 32))
//      ))
//  mmio_axi4_wb_bridge.io.i <> mmio_width_converter.io.i
//  mmio_width_converter.io.o <> periph_ic.io.m(0)
// 
//
//  // UART
//  val u_uart =  Module(new WishboneUART())
//  periph_ic.io.addr_base(0)  := 0x60000000.asUInt()
//  periph_ic.io.addr_limit(0) := 0x60000fff.asUInt()
//  u_uart.io.t <> periph_ic.io.s(0)
//  io.uart0 <> u_uart.io.s
  
//  u_core.io.mmio.tieoff()
  
}

object RocketSoc {
  class Parameters(
      val romfile : String = "/bootrom/bootrom.img"
      ) { }
}

