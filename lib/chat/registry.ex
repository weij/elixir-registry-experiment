defmodule Chat.Registry do
  use GenServer
  
  # API

  def start_link do
  	# We register our registry with a simple name,
  	# just so we can reference it in the other functions.
  	GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  def whereis_name(room_name) do
  	GenServer.call(:registry, {:whereis_name, room_name})
  end

  def register_name(room_name, pid) do
  	GenServer.call(:registry, {:register_name, room_name, pid})
  end

  def unregister_name(room_name) do
  	GenServer.cast(:registry, {:unregister_name, room_name})
  end

  def send(room_name, message) do
  	case whereis_name(room_name) do
  	  :undefined ->
  	  	{:badarg, {room_name, message}}
  	  pid ->
  	  	Kernel.send(pid, message)
  	  	pid
  	end
  end

  # SERVER

  def init(_) do
  	{:ok, Map.new}
  end

  def handle_call({:whereis_name, room_name}, _from, state) do
  	{:reply, Map.get(state, room_name, :undefined), state}
  end

  def handle_call({:register_name, room_name, pid}, _from, state) do
  	# registering a name is just a matter of putting it in our map.
  	case Map.get(state, room_name) do
  	  nil -> {:reply, :yes, Map.put(state, room_name, pid)}
  	  _ -> {:reply, :no, state}
  	end
  end

  def handle_cast({:unregister_name, room_name}, state) do
  	# and unregistering is as simple as deleting an entry from our map.
  	{:noreply, Map.delete(state, room_name)}
  end

end