defmodule Necesidades do

  def registrar(necesidades, necesidad) do
    existe = Enum.any?(necesidades, fn n -> n.id == necesidad.id end)

    if existe do
      {:error, "La necesidad ya existe."}
    else
      {:ok, [necesidad | necesidades]}
    end
  end

  def listar(necesidades) do
    necesidades
  end

  def buscar(necesidades, id) do
    Enum.find(necesidades, fn n -> n.id == id end)
  end

  def filtrar(necesidades, filtros) do
    Enum.filter(necesidades, fn n ->
      Enum.all?(filtros, fn {campo, valor} ->
        Map.get(n, campo) == valor
      end)
    end)
  end

  def cambiar_estado(necesidades, id, nuevo_estado) do
    necesidad = buscar(necesidades, id)

    if necesidad == nil do
      {:error, "Necesidad no encontrada."}
    else
      estados_validos = %{
        pendiente: [:asignada, :cancelada],
        asignada: [:en_progreso, :cancelada],
        en_progreso: [:atendida, :cancelada],
        atendida: [],
        cancelada: []
      }

      permitidos = Map.get(estados_validos, necesidad.estado, [])

      if nuevo_estado in permitidos do
        nuevos = Enum.map(necesidades, fn n ->
          if n.id == id, do: %{n | estado: nuevo_estado}, else: n
        end)

        {:ok, nuevos}
      else
        {:error, "El cambio de estado no está permitido."}
      end
    end
  end

  def asignar_responsable(necesidades, id, responsable) do
    necesidad = buscar(necesidades, id)

    if necesidad == nil do
      {:error, "Necesidad no encontrada."}
    else
      if necesidad.estado != :pendiente do
        {:error, "La necesidad no está pendiente."}
      else
        nuevos = Enum.map(necesidades, fn n ->
          if n.id == id do
            %{n | responsable: responsable, estado: :asignada}
          else
            n
          end
        end)

        {:ok, nuevos}
      end
    end
  end

  def ordenar_por_prioridad(necesidades) do
    prioridades = %{critica: 1, alta: 2, media: 3, baja: 4}

    Enum.sort_by(necesidades, fn n ->
      Map.get(prioridades, n.prioridad, 5)
    end)
  end

  def pendientes(necesidades) do
    Enum.filter(necesidades, fn n -> n.estado == :pendiente end)
  end

end
