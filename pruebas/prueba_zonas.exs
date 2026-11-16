defmodule PruebaZonas do

  def ejecutar do
    IO.puts("\n===== PRUEBAS DE ZONAS =====")

    zonas = []

    zona = %Zona{
      id: 1,
      nombre: "Zona Norte",
      nivel_afectacion: :alto,
      personas_afectadas: 100
    }

    resultado = Zonas.registrar(zonas, zona)

    IO.inspect(resultado, label: "Registro de zona")

    case resultado do
      {:ok, lista} ->
        IO.inspect(Zonas.listar(lista), label: "Lista de zonas")
        IO.inspect(Zonas.recorrer(lista), label: "Recorrido de zonas")

      {:error, mensaje} ->
        IO.puts(mensaje)
    end
  end

end

PruebaZonas.ejecutar()
