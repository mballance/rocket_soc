package rocket_soc

import chisel3._
import std_protocol_if.AXI4
import freechips.rocketchip.amba.axi4.AXI4BundleParameters
import freechips.rocketchip.system._
import freechips.rocketchip.diplomacy.LazyModule
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.subsystem.WithNBigCores
import freechips.rocketchip.subsystem.WithBootROMFile
import freechips.rocketchip.config.Config
import freechips.rocketchip.groundtest.HasPeripheryTestRAMSlave
import freechips.rocketchip.subsystem.WithNBanksPerMemChannel
import freechips.rocketchip.config.View

class RocketSocCore(
    val N_BIG_CORES : Int = 1,
    val romfile : String = "bootrom/bootrom.img") extends Module {
  
  val mmio_p = new AXI4.Parameters(
      ADDR_WIDTH = 31,
      DATA_WIDTH = 64,
      ID_WIDTH = 4)
  
  val mem_p = new AXI4.Parameters(
      ADDR_WIDTH = 32,
      DATA_WIDTH = 64,
      ID_WIDTH = 4)
  
  val l2_frontend_p = new AXI4.Parameters(
      ADDR_WIDTH = 32,
      DATA_WIDTH = 64,
      ID_WIDTH = 8)
  
  
  val core_cfg = new Config(
      new WithNBigCores(N_BIG_CORES) ++
      new WithBootROMFile(romfile) ++
      new WithNBanksPerMemChannel(2) ++
      new BaseConfig);
  implicit val p = core_cfg.toInstance
 
  // TODO: route interrupts out
  val io = IO(new Bundle {
    val mmio = new AXI4(mmio_p)
    val mem = new AXI4(mem_p)
    val l2_frontend_bus = Flipped(new AXI4(l2_frontend_p))
    val debug = new DebugIOIf()
  })
  
  val rocket_core_lm = LazyModule(new ExampleRocketSystem with HasPeripheryTestRAMSlave)
//  val rocket_core_lm = LazyModule(new ExampleRocketSystem)
  val rocket_core = Module(rocket_core_lm.module)
 
  rocket_core.interrupts := 0.asUInt();
 
  val mmio_axi4_p = new AXI4BundleParameters(
    addrBits = 31,
    dataBits = 64,
    idBits = 4,
    userBits = 0
  )
  
  val mem_axi4_p = new AXI4BundleParameters(
    addrBits = 32,
    dataBits = 64,
    idBits = 4,
    userBits = 0
  )
  
  val l2_frontend_axi4_p = new AXI4BundleParameters(
    addrBits = 32,
    dataBits = 64,
    idBits = 8,
    userBits = 0
  )
  
  val mmio_axi4_converter = Module(new RocketAxi4Master2Axi4Master(mmio_axi4_p, mmio_p))
  mmio_axi4_converter.io.rocket_axi4 <> rocket_core.mmio_axi4.getElements(0)
  mmio_axi4_converter.io.axi4 <> io.mmio
  
  val mem_axi4_converter = Module(new RocketAxi4Master2Axi4Master(mem_axi4_p, mem_p))
  mem_axi4_converter.io.rocket_axi4 <> rocket_core.mem_axi4.getElements(0)
  mem_axi4_converter.io.axi4 <> io.mem
  
  val l2_frontend_axi4_converter = Module(new Axi4Target2RocketAxi4Target(
      l2_frontend_axi4_p, l2_frontend_p))
  rocket_core.l2_frontend_bus_axi4.getElements(0) <> l2_frontend_axi4_converter.io.rocket_axi4
  io.l2_frontend_bus <> l2_frontend_axi4_converter.io.axi4

  // Route the debug interface out
  io.debug <> rocket_core.debug
  
}
