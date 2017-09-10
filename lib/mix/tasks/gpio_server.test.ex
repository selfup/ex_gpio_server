defmodule Mix.Tasks.GpioServer.Test do
  def run(_) do
    {:ok, id} = GpioServer.start_link

    GpioServer.set(id, 17, 1)

    IO.puts "ATTEMPTING"
    :timer.sleep(1000)
    IO.puts "DONE SLEEPING"

    GpioServer.unexport(GpioServer.all(id))
  end
end