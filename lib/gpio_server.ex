defmodule GpioServer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def get(server, pin) do
    GenServer.call(server, {:get, pin})
  end

  def all(server) do
    GenServer.call(server, {:all})
  end

  def set(server, pin, value) do
    GenServer.call(server, {:set, pin, value})
  end

  def unexport(pins) do
    Map.keys(pins)
    |> Enum.each(fn pin ->
      command("echo #{pin} > /sys/class/gpio/unexport")
    end)
  end

  def export_direction(pins) do
    Map.keys(pins)
    |> Enum.each(fn pin ->
      command("echo #{pin} > /sys/class/gpio/export")
      command("echo 'out' > /sys/class/gpio/gpio#{pin}/direction")
    end)
  end

  ## Server Callbacks

  def init(:ok) do
    pins = %{17 => false}

    unexport(pins)
    export_direction(pins)

    {:ok, pins}
  end

  def terminate(_reason, pins) do
    unexport(pins)
  end

  def handle_call({:get, pin}, _from, pins) do
    {:reply, Map.fetch(pins, pin), pins}
  end

  def handle_call({:all}, _from, pins) do
    {:reply, pins, pins}
  end

  def handle_call({:set, pin, value}, _from, pins) do
    if value == "1" || value == true || value == 1 do
      command("echo 1 > /sys/class/gpio/gpio#{pin}/value")
    else
      command("echo 0 > /sys/class/gpio/gpio#{pin}/value")
    end

    {:reply, Map.put(pins, pin, value), Map.put(pins, pin, value)}
  end

  ## Private methods

  # sudo oh no :(
  defp command(cmd) do
    chars = to_charlist cmd
    :os.cmd(chars)
  end
end
