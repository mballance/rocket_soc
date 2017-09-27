package rocket_soc

import chisel3._
import config.Config
import config.Parameters
import coreplex.WithBootROMFile
import coreplex.WithNBigCores
import diplomacy.LazyModule
import rocketchip.BaseConfig
import rocketchip.ExampleRocketTop
import std_protocol_if.AXI4
import uncore.axi4.AXI4BundleParameters

class RocketSocCore(
    val N_BIG_CORES : Int = 1,
    val romfile : String = "bootrom/bootrom.img") extends Module {
  
  val mmio_p = new AXI4.Parameters(
      ADDR_WIDTH = 31,
      DATA_WIDTH = 64,
      ID_WIDTH = 5)
  
  val mem_p = new AXI4.Parameters(
      ADDR_WIDTH = 32,
      DATA_WIDTH = 64,
      ID_WIDTH = 5)
  
  val io = IO(new Bundle {
    val mmio = new AXI4(mmio_p)
    val mem = new AXI4(mem_p)
    
  })
 
  val core_cfg = new Config(
      new WithNBigCores(N_BIG_CORES) ++
      new WithBootROMFile(romfile) ++
      new BaseConfig);
  implicit val p = Parameters.root(core_cfg.toInstance)
  
  val rocket_core_lm = LazyModule(new ExampleRocketTop())
  val rocket_core = Module(rocket_core_lm.module)
 
  val mmio_axi4_p = new AXI4BundleParameters(
    addrBits = 31,
    dataBits = 64,
    idBits = 5,
    userBits = 0
  )
  
  val mem_axi4_p = new AXI4BundleParameters(
    addrBits = 32,
    dataBits = 64,
    idBits = 5,
    userBits = 0
  )
  
  val mmio_axi4_converter = Module(new RocketAxi4Master2Axi4Master(mmio_axi4_p, mmio_p))
  mmio_axi4_converter.io.rocket_axi4 <> rocket_core.mmio_axi4.getElements(0)
  mmio_axi4_converter.io.axi4 <> io.mmio
  
  val mem_axi4_converter = Module(new RocketAxi4Master2Axi4Master(mem_axi4_p, mem_p))
  mem_axi4_converter.io.rocket_axi4 <> rocket_core.mem_axi4.getElements(0)
  mem_axi4_converter.io.axi4 <> io.mem

  // Tie off the debug interface
  rocket_core.debug.clockeddmi.get.dmiClock := clock
  rocket_core.debug.clockeddmi.get.dmiReset := reset
  rocket_core.debug.clockeddmi.get.dmi.req.valid := Bool(false)
  rocket_core.debug.clockeddmi.get.dmi.req.bits.addr := 0.asUInt()
  rocket_core.debug.clockeddmi.get.dmi.req.bits.data := 0.asUInt()
  rocket_core.debug.clockeddmi.get.dmi.req.bits.op := 0.asUInt()
  rocket_core.debug.clockeddmi.get.dmi.resp.ready := Bool(false)
  
}
