package rocket_soc

import chisel3._
import chisellib.Plusargs

import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy.LazyModule
/*
import freechips.rocketchip._
import freechips.rocketchip.coreplex.WithNBigCores
import freechips.rocketchip.coreplex.WithBootROMFile
import freechips.rocketchip.diplomacy.LazyMultiIOModuleImp
import freechips.rocketchip.uncore.devices.TLROM
 */

/** Example system with periphery devices (w/o coreplex) */
/*
class MyExampleSystem(implicit p: Parameters) extends BaseSystem
    with HasPeripheryAsyncExtInterrupts
    with HasPeripheryMasterAXI4MemPort
    with HasPeripheryMasterAXI4MMIOPort
//    with HasPeripherySlaveAXI4Port
    with HasPeripheryErrorSlave
    with HasPeripheryZeroSlave {
  override lazy val module = new MyExampleSystemModule(this)
}
 */

/** Example Top with periphery and a Rocket coreplex */
/*
class MyExampleRocketTop(implicit p: Parameters) extends MyExampleSystem
    with HasPeripheryBootROM
    with HasPeripheryDebug
    with HasPeripheryRTCCounter
    with HasRocketPlexMaster {
  override lazy val module = new MyExampleRocketTopModule(this)
}

object RocketCoreGen extends App {
//  val c = new DefaultConfig(new WithBootROMFile("foo"))
  val plusargs = new Plusargs(args)
 
  val romfile = plusargs.plusarg("BOOTROM_DIR", ".") + "/bootrom/bootrom.img"
  val c = new MyConfig(romfile)
  implicit val p = Parameters.root(c.toInstance)
  val t = LazyModule(new ExampleRocketTop())
  
  chisel3.Driver.execute(plusargs.nonplusargs, () => t.module)
}
 */



