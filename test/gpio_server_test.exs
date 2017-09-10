defmodule GpioServerTest do
  use ExUnit.Case
  doctest GpioServer

  test "it can set and read state" do
    {:ok, pid} = GpioServer.start_link
    Process.register(pid, :gps)

    GpioServer.set(:gps, 17, true)
    assert GpioServer.get(:gps, 17) == {:ok, true}

    GpioServer.set(:gps, 17, false)
    assert GpioServer.get(:gps, 17) == {:ok, false}

    GpioServer.set(:gps, 17, true)
    assert GpioServer.get(:gps, 17) == {:ok, true}
  end

  test "it can fetch the map of all pins" do
    {:ok, pid} = GpioServer.start_link
    Process.register(pid, :gps)

    GpioServer.set(:gps, 17, true)
    assert GpioServer.get(:gps, 17) == {:ok, true}

    assert GpioServer.all(:gps) == %{17 => true}
  end
end
