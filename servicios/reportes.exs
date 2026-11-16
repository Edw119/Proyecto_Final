defmodule Reportes do

  def resumen(usuarios, zonas, necesidades, personas) do
    %{
      total_usuarios: length(usuarios),
      total_zonas: length(zonas),
      total_necesidades: length(necesidades),
      total_personas: length(personas)
    }
  end

  def recursos_criticos(recursos, limite) do
    Enum.filter(recursos, fn recurso ->
      recurso.cantidad <= limite
    end)
  end

  def necesidades_pendientes(necesidades) do
    Enum.filter(necesidades, fn necesidad ->
      necesidad.estado == :pendiente
    end)
  end

  def albergues_mas_ocupados(albergues) do
    Enum.sort_by(albergues, fn albergue ->
      albergue.ocupacion
    end, :desc)
  end

  def personas_por_zona(personas) do
    Enum.group_by(personas, fn persona ->
      persona.zona_id
    end)
  end

  def necesidades_por_estado(necesidades) do
    Enum.group_by(necesidades, fn necesidad ->
      necesidad.estado
    end)
  end

end
