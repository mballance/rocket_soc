package rocket_soc

import chisel3._
import config._
import diplomacy.LazyModule
import rocketchip._
import rocketchip.ExampleRocketTop
import coreplex.WithNBigCores
import coreplex.WithBootROMFile
import chisellib.Plusargs
import diplomacy.LazyMultiIOModuleImp
import uncore.devices.TLROM

// class MyConfig extends Config(new WithNBigCores(4) ++ new BaseConfig ++ new WithBootROMFile("foo"))
class MyConfig(val romfile : String) extends Config(
//    new WithNBigCores(4) ++ 
    new WithNBigCores(1) ++ 
    new WithBootROMFile(romfile) ++ 
//    new WithoutExtIn ++
//    new FPGAConfig ++
    new BaseConfig)
// class MyConfig extends Config(new WithNBigCores(4) ++ new BaseConfig)

/** Example system with periphery devices (w/o coreplex) */
class MyExampleSystem(implicit p: Parameters) extends BaseSystem
    with HasPeripheryAsyncExtInterrupts
    with HasPeripheryMasterAXI4MemPort
    with HasPeripheryMasterAXI4MMIOPort
//    with HasPeripherySlaveAXI4Port
    with HasPeripheryErrorSlave
    with HasPeripheryZeroSlave {
  override lazy val module = new MyExampleSystemModule(this)
}

class MyExampleSystemModule[+L <: MyExampleSystem](_outer: L) extends BaseSystemModule(_outer)
    with HasPeripheryExtInterruptsModuleImp
    with HasPeripheryMasterAXI4MemPortModuleImp
    with HasPeripheryMasterAXI4MMIOPortModuleImp
//    with HasPeripherySlaveAXI4PortModuleImp

///** Adds a boot ROM that contains the DTB describing the system's coreplex. */
//trait MyHasPeripheryBootROM extends HasSystemNetworks with HasCoreplexRISCVPlatform {
//  val bootrom_address = 0x10000
//  val bootrom_size    = 0x10000
//  val bootrom_hang    = 0x10040
//  private lazy val bootrom_contents = GenerateBootROM(coreplex.dtb)
//  val bootrom = LazyModule(new TLROM(bootrom_address, bootrom_size, bootrom_contents, true, peripheryBusConfig.beatBytes))
//
//  bootrom.node := TLFragmenter(peripheryBusConfig.beatBytes, cacheBlockBytes)(peripheryBus.node)
//}

/** Example Top with periphery and a Rocket coreplex */
class MyExampleRocketTop(implicit p: Parameters) extends MyExampleSystem
    with HasPeripheryBootROM
    with HasPeripheryDebug
    with HasPeripheryRTCCounter
    with HasRocketPlexMaster {
  override lazy val module = new MyExampleRocketTopModule(this)
}

/** Coreplex will power-on running at 0x10040 (BootROM) */
trait MyHasPeripheryBootROMModuleImp extends LazyMultiIOModuleImp {
  val outer: HasPeripheryBootROM
  outer.coreplex.module.io.resetVector := UInt(outer.bootrom_address)
}


class MyExampleRocketTopModule[+L <: MyExampleRocketTop](_outer: L) extends MyExampleSystemModule(_outer)
    with MyHasPeripheryBootROMModuleImp
    with HasPeripheryDebugModuleImp
    with HasPeripheryRTCCounterModuleImp
    with HasRocketPlexMasterModuleImp
    
object RocketCoreGen extends App {
//  val c = new DefaultConfig(new WithBootROMFile("foo"))
  val plusargs = new Plusargs(args)
 
  val romfile = plusargs.plusarg("BOOTROM_DIR", ".") + "/bootrom/bootrom.img"
  val c = new MyConfig(romfile)
  implicit val p = Parameters.root(c.toInstance)
  val t = LazyModule(new ExampleRocketTop())
  
  chisel3.Driver.execute(plusargs.nonplusargs, () => t.module)
}



