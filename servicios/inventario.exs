
defmodule Inventario do
  use GenServer

  # INICIAR SERVIDOR

  def start_link(_opciones) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_estado) do
    {:ok, recursos} = cargar_datos("recursos.txt")
    {:ok, movimientos} = cargar_datos("movimientos.txt")

    {:ok, %{recursos: recursos, movimientos: movimientos}}
  end

  # FUNCIONES PUBLICAS

  def registrar(recurso) do
    GenServer.call(__MODULE__, {:registrar, recurso})
  end

  def listar do
    GenServer.call(__MODULE__, :listar)
  end

  def buscar(codigo) do
    GenServer.call(__MODULE__, {:buscar, codigo})
  end

  def asignar(codigo, cantidad, necesidad_id, responsable) do
    GenServer.call(__MODULE__, {:asignar, codigo, cantidad, necesidad_id, responsable})
  end

  def transferir(codigo, cantidad, destino, responsable) do
    GenServer.call(__MODULE__, {:transferir, codigo, cantidad, destino, responsable})
  end

  def movimientos do
    GenServer.call(__MODULE__, :movimientos)
  end

  # FUNCIONES DEL SERVIDOR

  def handle_call({:registrar, recurso}, _from, estado) do
    existe = Enum.any?(estado.recursos, fn r -> r.codigo == recurso.codigo end)

    cond do
      existe ->
        {:reply, {:error, "El recurso ya existe."}, estado}

      not is_number(recurso.cantidad) or recurso.cantidad < 0 ->
        {:reply, {:error, "Cantidad invalida."}, estado}

      true ->
        nuevos = [recurso | estado.recursos]

        case guardar_recursos(nuevos) do
          :ok ->
            {:reply, :ok, %{estado | recursos: nuevos}}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, estado}
        end
    end
  end

  def handle_call(:listar, _from, estado) do
    {:reply, estado.recursos, estado}
  end

  def handle_call({:buscar, codigo}, _from, estado) do
    recurso = Enum.find(estado.recursos, fn r -> r.codigo == codigo end)
    {:reply, recurso, estado}
  end

  def handle_call({:asignar, codigo, cantidad, necesidad_id, responsable}, _from, estado) do
    recurso = Enum.find(estado.recursos, fn r -> r.codigo == codigo end)

    cond do
      recurso == nil ->
        {:reply, {:error, "Recurso no encontrado."}, estado}

      not is_number(cantidad) or cantidad <= 0 ->
        {:reply, {:error, "La cantidad debe ser mayor que cero."}, estado}

      recurso.cantidad < cantidad ->
        {:reply, {:error, "No hay suficientes unidades disponibles."}, estado}

      true ->
        nuevo_recurso = %{recurso | cantidad: recurso.cantidad - cantidad}

        recursos = Enum.map(estado.recursos, fn r ->
          if r.codigo == codigo, do: nuevo_recurso, else: r
        end)

        movimiento = %Movimiento{
          id: System.unique_integer([:positive]),
          recurso_codigo: codigo,
          tipo: :salida,
          cantidad: cantidad,
          origen: recurso.ubicacion,
          destino: "Necesidad #{necesidad_id}",
          fecha: DateTime.utc_now(),
          responsable: responsable
        }

        movimientos = [movimiento | estado.movimientos]

        case guardar_todo(recursos, movimientos) do
          :ok ->
            nuevo_estado = %{
              estado |
              recursos: recursos,
              movimientos: movimientos
            }

            {:reply, {:ok, movimiento}, nuevo_estado}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, estado}
        end
    end
  end

  def handle_call({:transferir, codigo, cantidad, destino, responsable}, _from, estado) do
    recurso = Enum.find(estado.recursos, fn r -> r.codigo == codigo end)

    cond do
      recurso == nil ->
        {:reply, {:error, "Recurso no encontrado."}, estado}

      not is_number(cantidad) or cantidad <= 0 ->
        {:reply, {:error, "Cantidad invalida."}, estado}

      recurso.cantidad < cantidad ->
        {:reply, {:error, "No hay suficientes unidades para transferir."}, estado}

      recurso.ubicacion == destino ->
        {:reply, {:error, "El destino es igual a la ubicacion actual."}, estado}

      true ->
        id = System.unique_integer([:positive])

        recurso_origen = %{
          recurso |
          cantidad: recurso.cantidad - cantidad
        }

        # Se crea un registro para las unidades que llegan al destino.
        recurso_destino = %{
          recurso |
          codigo: "#{codigo}-T#{id}",
          cantidad: cantidad,
          ubicacion: destino
        }

        recursos =
          Enum.map(estado.recursos, fn r ->
            if r.codigo == codigo, do: recurso_origen, else: r
          end)
          |> List.insert_at(0, recurso_destino)

        movimiento = %Movimiento{
          id: id,
          recurso_codigo: codigo,
          tipo: :transferencia,
          cantidad: cantidad,
          origen: recurso.ubicacion,
          destino: destino,
          fecha: DateTime.utc_now(),
          responsable: responsable
        }

        movimientos = [movimiento | estado.movimientos]

        case guardar_todo(recursos, movimientos) do
          :ok ->
            nuevo_estado = %{
              estado |
              recursos: recursos,
              movimientos: movimientos
            }

            {:reply, {:ok, movimiento}, nuevo_estado}

          {:error, mensaje} ->
            {:reply, {:error, mensaje}, estado}
        end
    end
  end

  def handle_call(:movimientos, _from, estado) do
    {:reply, estado.movimientos, estado}
  end

  # PERSISTENCIA

  defp cargar_datos(archivo) do
    case Persistencia.cargar(archivo) do
      {:ok, datos} when is_list(datos) -> {:ok, datos}
      {:ok, _} -> {:ok, []}
      {:error, mensaje} -> {:stop, mensaje}
    end
  end

  defp guardar_recursos(recursos) do
    case Persistencia.guardar("recursos.txt", recursos) do
      {:ok, _} -> :ok
      {:error, mensaje} -> {:error, mensaje}
    end
  end

  defp guardar_todo(recursos, movimientos) do
    with {:ok, _} <- Persistencia.guardar("recursos.txt", recursos),
         {:ok, _} <- Persistencia.guardar("movimientos.txt", movimientos) do
      :ok
    else
      {:error, mensaje} -> {:error, mensaje}
    end
  end
end
