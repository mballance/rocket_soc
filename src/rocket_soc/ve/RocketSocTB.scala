package rocket_soc.ve

import chisel3._
import rocket_soc.RocketSoc
import std_protocol_if.AXI4
import sv_bfms.UartSerialBFM

class RocketSocTB(val soc_p : RocketSoc.Parameters) extends Module {
 
  val io = IO(new Bundle {
    // No true I/O, just clock/reset
  })
  
  val u_dut = Module(new RocketSoc(soc_p))
  
  // Instantiate and connect a UART agent
  val u_uart_bfm = Module(new UartSerialBFM())
  u_uart_bfm.io.s <> u_dut.io.uart0
  
}