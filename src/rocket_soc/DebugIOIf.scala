package rocket_soc

import rocketchip.DebugIO
import config.Config
import config.Parameters
import chisel3._

class DebugIOIf(implicit p : Parameters) extends DebugIO {

  def tieoff_flipped(clk : Clock, reset : Bool) {
    clockeddmi.get.dmiClock := clk
    clockeddmi.get.dmiReset := reset
    clockeddmi.get.dmi.req.valid := Bool(false)
    clockeddmi.get.dmi.req.bits.addr := 0.asUInt()
    clockeddmi.get.dmi.req.bits.data := 0.asUInt()
    clockeddmi.get.dmi.req.bits.op := 0.asUInt()
    clockeddmi.get.dmi.resp.ready := Bool(false)
  }
  
}