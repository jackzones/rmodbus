$:.unshift File.join(File.dirname(__FILE__),'../lib')

require 'rmodbus'
require 'benchmark'

include ModBus

BAUD = 9600 
TIMES = 100

srv = RTUServer.new 'com3', BAUD 
srv.coils = [0,1]  * 50
srv.discret_inputs = [1,0]  * 50
srv.holding_registers = [0,1,2,3,4,5,6,7,8,9]  * 10
srv.input_registers = [0,1,2,3,4,5,6,7,8,9]  * 10
srv.start


cl = RTUClient.new 'com4', BAUD


Benchmark.bmbm do |x|
  x.report('Read coils') do
    TIMES.times { cl.read_coils 0, 100 }
  end

  x.report('Read discrete inputs') do
    TIMES.times { cl.read_discrete_inputs 0, 100 }
  end

  x.report('Read holding registers') do
    TIMES.times { cl.read_holding_registers 0, 100 } 
  end

  x.report('Read input registers') do
    TIMES.times { cl.read_input_registers 0, 100 }
  end

  x.report('Write single coil') do
    TIMES.times { cl.write_single_coil 0, 1 }
  end

  x.report('Write single register') do
    TIMES.times { cl.write_single_register 100, 0xAAAA }
  end

  x.report('Write multiple coils') do
    TIMES.times { cl.write_multiple_coils 0, [1,0] * 50 }
  end


  x.report('Write multiple registers') do
    TIMES.times { cl.write_multiple_registers 0, [0,1,2,3,4,5,6,7,8,9] * 10  }
  end
end

srv.stop
cl.close
