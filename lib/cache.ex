defmodule Cache do
  use GenServer

  @name __MODULE__

  ## CLIENT

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def write(key, value) do
    GenServer.cast(@name, {:write, key, value})
  end
  
  def read(key) do
    GenServer.call(@name, {:read, key})
  end
  
  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end
  
  def clear do
    GenServer.cast(@name, :stop)
  end
  
  ## SERVER

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:write, key, value}, state) do
    update_state = state |> Map.put(key, value)
    {:noreply, update_state}
  end
  
  def handle_cast({:delete, key}, state) do
    updated_state = state |> Map.delete(key)
    {:noreply, updated_state}
  end
  
  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end
  
  def handle_call({:read, key}, _from, state) do
    value = state[key]
    {:reply, value, state}
  end
  
  def terminate(:normal, _state) do
    :ok
  end

end
