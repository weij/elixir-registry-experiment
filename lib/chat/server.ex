defmodule Chat.Server do
  use GenServer

  # API
  def start_link(name) do
  	# Instead of passing an atom to the `name` option, we send 
    # a tuple. Here we extract this tuple to a private method
    # called `via_tuple` that can be reused in every function
  	GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end
  
  # And our function doesn't need to receive the pid anymore,
  # as we can reference the proces with its unique name.
  def add_message(room_name, message) do
  	GenServer.cast(via_tuple(room_name), {:add_message, message})
  end

  def get_message(room_name) do
  	GenServer.call(via_tuple(room_name), :get_message)
  end

  defp via_tuple(room_name) do
    # the tuple always follow the same format:
    # {:via, module_name, term}
    {:via, Chat.Registry, {:chat_room, room_name}}
  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
  	{:noreply, [new_message | messages]}
  end

  def handle_call(:get_message, _from, messages) do
  	{:reply, messages, messages}
  end
end
