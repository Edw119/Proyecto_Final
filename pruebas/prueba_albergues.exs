defmodule PruebaAlbergues do

  def ejecutar do
    IO.puts("\n===== PRUEBAS DE ALBERGUES =====")

    albergue = %Albergue{
      id: 1,
      nombre: "Albergue Central",
      direccion: "Carrera 15",
      zona_id: 1,
      capacidad: 5
    }

    IO.inspect(Albergues.registrar(albergue), label: "Registro de albergue")

    IO.inspect(Albergues.listar(), label: "Lista de albergues")

    IO.inspect(
      Albergues.registrar_entrada(1, 101),
      label: "Ingreso de persona"
    )

    IO.inspect(
      Albergues.consultar(1),
      label: "Estado del albergue"
    )

    IO.inspect(
      Albergues.registrar_salida(1, 101),
      label: "Salida de persona"
    )

    IO.inspect(
      Albergues.consultar(1),
      label: "Estado final del albergue"
    )
  end

end

PruebaAlbergues.ejecutar()
