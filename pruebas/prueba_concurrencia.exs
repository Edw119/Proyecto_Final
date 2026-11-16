defmodule PruebaConcurrencia do

  def ejecutar do
    IO.puts("\n===== PRUEBA DE CONCURRENCIA =====")

    recurso = %Recurso{
      codigo: "AG002",
      nombre: "Agua",
      categoria: :alimento,
      cantidad: 50,
      unidad: "litros",
      ubicacion: "Centro Norte",
      centro_id: 2
    }

    IO.inspect(Inventario.registrar(recurso), label: "Registro inicial")

    tarea1 = Task.async(fn ->
      Inventario.asignar("AG002", 30, 1, "Usuario A")
    end)

    tarea2 = Task.async(fn ->
      Inventario.asignar("AG002", 25, 2, "Usuario B")
    end)

    resultados = Task.await_many([tarea1, tarea2])

    IO.inspect(resultados, label: "Resultados de las solicitudes")

    IO.inspect(Inventario.listar(), label: "Inventario final")

    IO.puts("La cantidad asignada no debe superar los 50 litros.")
  end

end

PruebaConcurrencia.ejecutar()
