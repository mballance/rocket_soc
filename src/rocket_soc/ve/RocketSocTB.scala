package rocket_soc.ve

import chisel3._
import rocket_soc.RocketSoc
import std_protocol_if.AXI4
import sv_bfms.UartSerialBFM

class RocketSocTB(val soc_p : RocketSoc.Parameters) extends Module {
 
  // No true I/O, just clock/reset
  val io = IO(new Bundle {
  })
  
  val u_dut = Module(new RocketSoc(soc_p))
  
//  val top_mon = Wire(new AXI4(new AXI4.Parameters()))
//  top_mon <> u_dut.mmio_axi4_wb_bridge.io.t
 
  // Instantiate and connect a UART agent
  val u_uart_bfm = Module(new UartSerialBFM())
  u_uart_bfm.io.s <> u_dut.io.uart0
 
}