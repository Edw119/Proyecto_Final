defmodule Personas do

  def registrar(personas, persona) do
    existe = Enum.any?(personas, fn p ->
      p.id == persona.id or p.documento == persona.documento
    end)

    if existe do
      {:error, "La persona ya está registrada."}
    else
      {:ok, [persona | personas]}
    end
  end

  def buscar(personas, identificador) do
    Enum.find(personas, fn p ->
      p.id == identificador or p.documento == identificador
    end)
  end

  def listar(personas) do
    personas
  end

  def cambiar_estado(personas, id, nuevo_estado) do
    persona = buscar(personas, id)

    if persona == nil do
      {:error, "Persona no encontrada."}
    else
      estados_validos = [:desaparecida, :localizada, :atendida, :albergada]

      if nuevo_estado in estados_validos do
        nuevos = Enum.map(personas, fn p ->
          if p.id == id, do: %{p | estado: nuevo_estado}, else: p
        end)

        {:ok, nuevos}
      else
        {:error, "Estado no válido."}
      end
    end
  end

  def filtrar_por_zona(personas, zona_id) do
    Enum.filter(personas, fn p -> p.zona_id == zona_id end)
  end

  def contar(personas) do
    length(personas)
  end

end
