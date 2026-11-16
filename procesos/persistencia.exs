defmodule Persistencia do

  # Guarda información en un archivo de texto
  def guardar(nombre_archivo, datos) do
    ruta = ruta_archivo(nombre_archivo)

    File.mkdir_p!(Path.dirname(ruta))

    contenido = inspect(datos, limit: :infinity, printable_limit: :infinity)

    case File.write(ruta, contenido) do
      :ok ->
        {:ok, "Información guardada correctamente."}

      {:error, razon} ->
        {:error, "No se pudo guardar la información: #{inspect(razon)}"}
    end
  end

  # Carga información de un archivo
  def cargar(nombre_archivo) do
    ruta = ruta_archivo(nombre_archivo)

    case File.read(ruta) do
      {:ok, ""} ->
        {:ok, []}

      {:ok, contenido} ->
        try do
          {datos, _} = Code.eval_string(contenido)
          {:ok, datos}
        rescue
          _ -> {:error, "No se pudo interpretar el archivo."}
        end

      {:error, :enoent} ->
        {:ok, []}

      {:error, razon} ->
        {:error, "No se pudo leer el archivo: #{inspect(razon)}"}
    end
  end

  # Construye la ruta de la carpeta datos
  defp ruta_archivo(nombre_archivo) do
    Path.join([__DIR__, "..", "datos", nombre_archivo])
    |> Path.expand()
  end

end
