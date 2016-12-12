defmodule Chat.Supervisor do
  use Supervisor

  def start_link do
  	# We are now registering our supervisor process with a name 
  	# so we can reference it in the `start_romm/1` function
  	Supervisor.start_link(__MODULE__, [], name: :chat_supervisor)
  end

  def start_room(name) do
  	# And we use `start_child/2` to start a new Chat.Server process
  	Supervisor.start_child(:chat_supervisor, [name])
  end

  def init(_) do
  	children = [
      worker(Chat.Server, [])
  	]

    # We also changed the `strategy` to `simple_one_for_one`.
    # With this strategy, we define a "template" fro a child,
    # no process is started during the Supervisor initialization,
    # just when we call `start_child/2`
  	supervise(children, strategy: :simple_one_for_one)
  end
end