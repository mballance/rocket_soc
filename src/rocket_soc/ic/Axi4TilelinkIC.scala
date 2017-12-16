package rocket_soc.ic

import chisel3._
import freechips.rocketchip.tilelink.TLXbar
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.system.BaseConfig
import freechips.rocketchip.config.Config
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.tilelink._
import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.devices.tilelink._

class Axi4TilelinkIC_lm(override implicit val p : Parameters) extends LazyModule {

  val node = AXI4IdentityNode()
  val master = LazyModule(new AXI4FuzzMaster(1))
  val slave = LazyModule(new AXI4FuzzSlave)
//  val xbar_lm = LazyModule(new TLXbar)
//  xbar_lm.node :=
//    TLFIFOFixer()(
//        TLDelayer(0.1)(
//            TLBuffer(BufferParams.flow)(
//                TLDelayer(0.1)(
//                    AXI4ToTL()(
//                        AXI4UserYanker(Some(4))(
//                            AXI4Fragmenter()(
//                                AXI4IdIndexer(2)(node)
//                            )
//                        )
//                    )
//                )
//            )
//        )
//    )
//    
//  val error= LazyModule(new TLError(ErrorParams(Seq(AddressSet(0x1800, 0xff)), maxTransfer = 256)))
//  error.node := xbar_lm.node
  
  slave.node := master.node
    
  lazy val module = new LazyModuleImp(this) {
    val io = IO(new Bundle {
    })
  }
}

class Axi4TilelinkIC extends Module {
  
  val io = IO(new Bundle {
    
  });
  
  val core_cfg = new Config(new BaseConfig);
  implicit val p = Parameters.root(core_cfg.toInstance)  
 

  val ic_lm = LazyModule(new Axi4TilelinkIC_lm)
  val xbar = Module(ic_lm.module)
  
}