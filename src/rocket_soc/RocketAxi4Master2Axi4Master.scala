package rocket_soc

import chisel3._
import freechips.rocketchip.amba.axi4._
import std_protocol_if._

class RocketAxi4Master2Axi4Master(
    val rocket_axi4_p : AXI4BundleParameters,
    val axi4_p : AXI4.Parameters
    ) extends Module {
  
  require(rocket_axi4_p.addrBits == axi4_p.ADDR_WIDTH)
  require(rocket_axi4_p.dataBits == axi4_p.DATA_WIDTH)
  require(rocket_axi4_p.idBits == axi4_p.ID_WIDTH)
  
  val io = IO(new Bundle {
    val rocket_axi4 = Flipped(new AXI4Bundle(rocket_axi4_p))
    val axi4 = new AXI4(axi4_p)
  })
 
  io.axi4.awreq.AWADDR := io.rocket_axi4.aw.bits.addr
  io.axi4.awreq.AWID := io.rocket_axi4.aw.bits.id
  io.axi4.awreq.AWLEN := io.rocket_axi4.aw.bits.len
  io.axi4.awreq.AWSIZE := io.rocket_axi4.aw.bits.size
  io.axi4.awreq.AWBURST := io.rocket_axi4.aw.bits.burst
  io.axi4.awreq.AWLOCK := io.rocket_axi4.aw.bits.lock
  io.axi4.awreq.AWCACHE := io.rocket_axi4.aw.bits.cache
  io.axi4.awreq.AWPROT := io.rocket_axi4.aw.bits.prot
  io.axi4.awreq.AWQOS := io.rocket_axi4.aw.bits.qos
  io.axi4.awreq.AWREGION := 0.asUInt() // io.rocket_axi4.aw.bits.region
  io.axi4.awreq.AWVALID := io.rocket_axi4.aw.valid
  io.rocket_axi4.aw.ready := io.axi4.awready
 
  io.axi4.arreq.ARADDR := io.rocket_axi4.ar.bits.addr
  io.axi4.arreq.ARID := io.rocket_axi4.ar.bits.id
  io.axi4.arreq.ARLEN := io.rocket_axi4.ar.bits.len
  io.axi4.arreq.ARSIZE := io.rocket_axi4.ar.bits.size
  io.axi4.arreq.ARBURST := io.rocket_axi4.ar.bits.burst
  io.axi4.arreq.ARLOCK := io.rocket_axi4.ar.bits.lock
  io.axi4.arreq.ARCACHE := io.rocket_axi4.ar.bits.cache
  io.axi4.arreq.ARPROT := io.rocket_axi4.ar.bits.prot
  io.axi4.arreq.ARQOS := io.rocket_axi4.ar.bits.qos
  io.axi4.arreq.ARREGION := 0.asUInt() // io.rocket_axi4.ar.bits.region
  io.axi4.arreq.ARVALID := io.rocket_axi4.ar.valid
  io.rocket_axi4.ar.ready := io.axi4.arready
  
  io.axi4.wreq.WDATA := io.rocket_axi4.w.bits.data
  io.axi4.wreq.WSTRB := io.rocket_axi4.w.bits.strb
  io.axi4.wreq.WLAST := io.rocket_axi4.w.bits.last
  io.axi4.wreq.WVALID := io.rocket_axi4.w.valid
  io.rocket_axi4.w.ready := io.axi4.wready
 
  io.rocket_axi4.b.bits.id := io.axi4.brsp.BID
  io.rocket_axi4.b.bits.resp := io.axi4.brsp.BRESP
  io.rocket_axi4.b.valid := io.axi4.brsp.BVALID
  io.axi4.bready := io.rocket_axi4.b.ready
  
  io.rocket_axi4.r.bits.id := io.axi4.rresp.RID
  io.rocket_axi4.r.bits.resp := io.axi4.rresp.RRESP
  io.rocket_axi4.r.bits.data := io.axi4.rresp.RDATA
  io.rocket_axi4.r.valid := io.axi4.rresp.RVALID
  io.axi4.rready := io.rocket_axi4.r.ready
}
