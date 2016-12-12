defmodule Chat.Server do
  use GenServer

  # API
  def start_link(name) do
  	# We now start the GenServer with a `name` option.
  	GenServer.start_link(__MODULE__, [], name: :chat_room)
  end
  
  # And our function doesn't need to receive the pid anymore,
  # as we can reference the proces with its unique name.
  def add_message(message) do
  	GenServer.cast(:chat_room, {:add_message, message})
  end

  def get_message() do
  	GenServer.call(:chat_room, :get_message)
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
