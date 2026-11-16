defmodule PruebaNecesidades do

  def ejecutar do
    IO.puts("\n===== PRUEBAS DE NECESIDADES =====")

    necesidades = []

    necesidad = %Necesidad{
      id: 1,
      tipo: :agua,
      descripcion: "Se necesitan botellas de agua",
      cantidad: 50,
      zona_id: 1,
      prioridad: :alta,
      estado: :pendiente,
      reportado_por: 1,
      responsable: nil
    }

    resultado = Necesidades.registrar(necesidades, necesidad)

    IO.inspect(resultado, label: "Registro de necesidad")

    case resultado do
      {:ok, lista} ->
        IO.inspect(Necesidades.listar(lista), label: "Lista de necesidades")
        IO.inspect(Necesidades.pendientes(lista), label: "Necesidades pendientes")
        IO.inspect(Necesidades.ordenar_por_prioridad(lista),
          label: "Ordenadas por prioridad")

      {:error, mensaje} ->
        IO.puts(mensaje)
    end
  end

end

PruebaNecesidades.ejecutar()
