defmodule Mascotas do

  def registrar(mascotas, mascota) do
    existe = Enum.any?(mascotas, fn m -> m.id == mascota.id end)

    if existe do
      {:error, "El reporte de mascota ya existe."}
    else
      {:ok, [mascota | mascotas]}
    end
  end

  def listar(mascotas) do
    mascotas
  end

  def buscar(mascotas, id) do
    Enum.find(mascotas, fn m -> m.id == id end)
  end

  def perdidas(mascotas) do
    Enum.filter(mascotas, fn m ->
      m.tipo_reporte == :perdida and m.estado == :abierta
    end)
  end

  def encontradas(mascotas) do
    Enum.filter(mascotas, fn m ->
      m.tipo_reporte == :encontrada and m.estado == :abierta
    end)
  end

  def calcular_coincidencia(perdida, encontrada) do
    puntos = 0

    puntos = if perdida.especie == encontrada.especie, do: puntos + 30, else: puntos
    puntos = if perdida.color == encontrada.color, do: puntos + 25, else: puntos
    puntos = if perdida.tamano == encontrada.tamano, do: puntos + 20, else: puntos
    puntos = if perdida.nombre == encontrada.nombre, do: puntos + 15, else: puntos
    puntos = if perdida.caracteristicas == encontrada.caracteristicas, do: puntos + 10, else: puntos

    puntos
  end

  def buscar_coincidencias(mascotas) do
    perdidas = perdidas(mascotas)
    encontradas = encontradas(mascotas)

    for perdida <- perdidas,
        encontrada <- encontradas,
        perdida.id != encontrada.id,
        puntuacion = calcular_coincidencia(perdida, encontrada),
        puntuacion >= 50 do
      %{
        mascota_perdida: perdida,
        mascota_encontrada: encontrada,
        puntuacion: puntuacion
      }
    end
  end

  def confirmar_coincidencia(mascotas, id_perdida, id_encontrada) do
    perdida = buscar(mascotas, id_perdida)
    encontrada = buscar(mascotas, id_encontrada)

    cond do
      perdida == nil or encontrada == nil ->
        {:error, "No se encontraron ambos reportes."}

      perdida.tipo_reporte != :perdida or encontrada.tipo_reporte != :encontrada ->
        {:error, "Los reportes no corresponden a una pérdida y un hallazgo."}

      perdida.estado != :abierta or encontrada.estado != :abierta ->
        {:error, "Uno de los reportes ya fue cerrado."}

      calcular_coincidencia(perdida, encontrada) < 50 ->
        {:error, "La coincidencia no es suficiente."}

      true ->
        nuevas = Enum.map(mascotas, fn m ->
          cond do
            m.id == id_perdida ->
              %{m | estado: :cerrada, coincidencia_id: id_encontrada}

            m.id == id_encontrada ->
              %{m | estado: :cerrada, coincidencia_id: id_perdida}

            true ->
              m
          end
        end)

        {:ok, nuevas}
    end
  end

end
