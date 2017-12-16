package rocket_soc.ic.ve

import chisel3._
import rocket_soc.ic.Axi4TilelinkIC

class Axi4TilelinkICTB extends Module {
  
  val io = IO(new Bundle {
    
  });
  
  val dut = Module(new Axi4TilelinkIC())
  
}

