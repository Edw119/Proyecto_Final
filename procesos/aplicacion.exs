
defmodule Aplicacion do

  def iniciar do
    case SGESupervisor.start_link([]) do
      {:ok, supervisor} ->
        Util.mostrar_mensaje("Procesos del sistema iniciados correctamente.")
        {:ok, supervisor}

      {:error, razon} ->
        Util.mostrar_mensaje("Error al iniciar el sistema: #{inspect(razon)}")
        {:error, razon}
    end
  end

end
