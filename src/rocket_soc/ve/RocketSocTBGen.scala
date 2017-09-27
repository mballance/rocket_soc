package rocket_soc.ve

import rocket_soc._
import chisellib.Plusargs
import firrtl.ir.Circuit
import firrtl._
import chisel3.internal.firrtl.Emitter
import chisel3.internal.firrtl.Emitter
import rocket_soc.RocketSoc

object RocketSocTBGen extends App {
  val plusargs = new Plusargs(args)
  val romfile = plusargs.plusarg("BOOTROM_DIR", ".") + "/bootrom/bootrom.img"

//  val c = chisel3.Driver.elaborate(() => new RocketSoc(
//      new RocketSoc.Parameters(
//          romfile = romfile
//          )
//      )
//  )
 
//  for (m <- c.components) {
//    println("m: " + m.name + " class=" + m.getClass.getName)
////    val str = Emitter.emit(m)
//  }
//  chisel3.Driver.dumpFirrtl(c, None)
  
  chisel3.Driver.execute(plusargs.nonplusargs, () => new RocketSocTB(
      new RocketSoc.Parameters(
          romfile = romfile
          )
      )
  )
}