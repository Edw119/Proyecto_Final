
defmodule Albergues do
  use GenServer

  def start_link(_opciones) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_albergues) do
    case Persistencia.cargar("albergues.txt") do
      {:ok, datos} when is_list(datos) ->
        {:ok, datos}

      {:ok, _} ->
        {:ok, []}

      {:error, mensaje} ->
        {:stop, mensaje}
    end
  end

  # FUNCIONES PUBLICAS

  def registrar(albergue) do
    GenServer.call(__MODULE__, {:registrar, albergue})
  end

  def listar do
    GenServer.call(__MODULE__, :listar)
  end

  def consultar(id) do
    GenServer.call(__MODULE__, {:consultar, id})
  end

  def registrar_entrada(id, persona_id) do
    GenServer.call(__MODULE__, {:entrada, id, persona_id})
  end

  def registrar_salida(id, persona_id) do
    GenServer.call(__MODULE__, {:salida, id, persona_id})
  end

  # FUNCIONES DEL SERVIDOR

  def handle_call({:registrar, albergue}, _from, albergues) do
    existe = Enum.any?(albergues, fn a -> a.id == albergue.id end)

    cond do
      existe ->
        {:reply, {:error, "El albergue ya existe."}, albergues}

      not is_integer(albergue.capacidad) or albergue.capacidad <= 0 ->
        {:reply, {:error, "La capacidad debe ser mayor que cero."}, albergues}

      albergue.ocupacion < 0 or albergue.ocupacion > albergue.capacidad ->
        {:reply, {:error, "Ocupacion inicial invalida."}, albergues}

      true ->
        nuevos = [albergue | albergues]

        case guardar_albergues(nuevos) do
          :ok ->
            {:reply, :ok, nuevos}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, albergues}
        end
    end
  end

  def handle_call(:listar, _from, albergues) do
    {:reply, albergues, albergues}
  end

  def handle_call({:consultar, id}, _from, albergues) do
    albergue = Enum.find(albergues, fn a -> a.id == id end)

    if albergue == nil do
      {:reply, {:error, "Albergue no encontrado."}, albergues}
    else
      disponibles = albergue.capacidad - albergue.ocupacion

      resultado = %{
        id: albergue.id,
        nombre: albergue.nombre,
        capacidad: albergue.capacidad,
        ocupacion: albergue.ocupacion,
        disponibles: disponibles
      }

      {:reply, resultado, albergues}
    end
  end

  def handle_call({:entrada, id, persona_id}, _from, albergues) do
    albergue = Enum.find(albergues, fn a -> a.id == id end)

    cond do
      albergue == nil ->
        {:reply, {:error, "Albergue no encontrado."}, albergues}

      persona_id in albergue.personas ->
        {:reply, {:error, "La persona ya esta registrada en este albergue."}, albergues}

      albergue.ocupacion >= albergue.capacidad ->
        {:reply, {:error, "El albergue no tiene cupos disponibles."}, albergues}

      true ->
        actualizado = %{
          albergue |
          ocupacion: albergue.ocupacion + 1,
          personas: [persona_id | albergue.personas]
        }

        nuevos = actualizar_albergue(albergues, actualizado)

        case guardar_albergues(nuevos) do
          :ok ->
            {:reply, :ok, nuevos}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, albergues}
        end
    end
  end

  def handle_call({:salida, id, persona_id}, _from, albergues) do
    albergue = Enum.find(albergues, fn a -> a.id == id end)

    cond do
      albergue == nil ->
        {:reply, {:error, "Albergue no encontrado."}, albergues}

      persona_id not in albergue.personas ->
        {:reply, {:error, "La persona no esta registrada en este albergue."}, albergues}

      albergue.ocupacion <= 0 ->
        {:reply, {:error, "La ocupacion del albergue no es valida."}, albergues}

      true ->
        actualizado = %{
          albergue |
          ocupacion: albergue.ocupacion - 1,
          personas: List.delete(albergue.personas, persona_id)
        }

        nuevos = actualizar_albergue(albergues, actualizado)

        case guardar_albergues(nuevos) do
          :ok ->
            {:reply, :ok, nuevos}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, albergues}
        end
    end
  end

  # FUNCIONES AUXILIARES

  defp actualizar_albergue(albergues, actualizado) do
    Enum.map(albergues, fn a ->
      if a.id == actualizado.id, do: actualizado, else: a
    end)
  end

  defp guardar_albergues(albergues) do
    case Persistencia.guardar("albergues.txt", albergues) do
      {:ok, _} -> :ok
      {:error, mensaje} -> {:error, mensaje}
    end
  end
end
