
defmodule SGESupervisor do
  use Supervisor

  def start_link(_opciones) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    procesos = [
      {Inventario, []},
      {Albergues, []},
      {Auditoria, []}
    ]

    Supervisor.init(procesos, strategy: :one_for_one)
  end

end
