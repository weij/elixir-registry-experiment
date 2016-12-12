defmodule Chat.Server do
  use GenServer

  # API
  def start_link do
  	GenServer.start_link(__MODULE__, [])
  end

  def add_message(pid, message) do
  	GenServer.cast(pid, {:add_message, message})
  end

  def get_message(pid) do
  	GenServer.call(pid, :get_message)
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
