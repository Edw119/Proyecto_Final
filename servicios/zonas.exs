defmodule Zonas do

  def registrar(zonas, zona) do
    existe = Enum.any?(zonas, fn z -> z.id == zona.id end)

    if existe do
      {:error, "La zona ya existe."}
    else
      {:ok, [zona | zonas]}
    end
  end

  def buscar(zonas, id) do
    Enum.find(zonas, fn z -> z.id == id end)
  end

  def agregar_sector(zonas, zona_id, sector) do
    zona = buscar(zonas, zona_id)

    if zona == nil do
      {:error, "Zona no encontrada."}
    else
      existe = Enum.any?(zona.sectores, fn s -> s.id == sector.id end)

      if existe do
        {:error, "El sector ya existe en esta zona."}
      else
        nueva_zona = %{zona | sectores: [sector | zona.sectores]}

        nuevas_zonas = Enum.map(zonas, fn z ->
          if z.id == zona_id, do: nueva_zona, else: z
        end)

        {:ok, nuevas_zonas}
      end
    end
  end

  def agregar_punto(zonas, zona_id, sector_id, punto) do
    zona = buscar(zonas, zona_id)

    if zona == nil do
      {:error, "Zona no encontrada."}
    else
      sector = Enum.find(zona.sectores, fn s -> s.id == sector_id end)

      if sector == nil do
        {:error, "Sector no encontrado."}
      else
        existe = Enum.any?(sector.puntos_atencion, fn p -> p.id == punto.id end)

        if existe do
          {:error, "El punto de atención ya existe."}
        else
          nuevo_sector = %{
            sector |
            puntos_atencion: [punto | sector.puntos_atencion]
          }

          nuevos_sectores = Enum.map(zona.sectores, fn s ->
            if s.id == sector_id, do: nuevo_sector, else: s
          end)

          nueva_zona = %{zona | sectores: nuevos_sectores}

          nuevas_zonas = Enum.map(zonas, fn z ->
            if z.id == zona_id, do: nueva_zona, else: z
          end)

          {:ok, nuevas_zonas}
        end
      end
    end
  end

  def listar(zonas) do
    zonas
  end

  def recorrer(zonas) do
    recorrer_zonas(zonas)
  end

  defp recorrer_zonas([]), do: []

  defp recorrer_zonas([zona | resto]) do
    puntos = recorrer_sectores(zona.sectores)

    [{zona.nombre, puntos} | recorrer_zonas(resto)]
  end

  defp recorrer_sectores([]), do: []

  defp recorrer_sectores([sector | resto]) do
    puntos = Enum.map(sector.puntos_atencion, fn p -> p.nombre end)

    [{sector.nombre, puntos} | recorrer_sectores(resto)]
  end

end
