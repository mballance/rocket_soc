package rocket_soc.ic.ve

object AXI4TilelinkICTBGen extends App {
  
  chisel3.Driver.execute(args, () => new Axi4TilelinkICTB())
  
}