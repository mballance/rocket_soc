package rocket_soc.ve

import chisel3._
import rocket_soc.RocketSoc
import std_protocol_if.AXI4
import sv_bfms.uart.UartSerialBFM

class RocketSocTB(val soc_p : RocketSoc.Parameters) extends Module {
 
  val io = IO(new Bundle {
    // No true I/O, just clock/reset
  })
  
  val u_dut = Module(new RocketSoc(soc_p))
  
  // Instantiate and connect a UART agent
  val u_uart_bfm = Module(new UartSerialBFM())
// TODO: bridge UART to RxTx
	u_uart_bfm.io.s.TxD := u_dut.io.uart0.TxD
	u_dut.io.uart0.RxD := u_uart_bfm.io.s.RxD
	u_uart_bfm.io.s.RTS := Bool(false)
	u_uart_bfm.io.s.DTR := Bool(false)
//  u_uart_bfm.io.s <> u_dut.io.uart0
  
}