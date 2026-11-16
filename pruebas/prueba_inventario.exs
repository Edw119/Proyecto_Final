defmodule PruebaInventario do

  def ejecutar do
    IO.puts("\n===== PRUEBAS DE INVENTARIO =====")

    recurso = %Recurso{
      codigo: "AG001",
      nombre: "Agua",
      categoria: :alimento,
      cantidad: 50,
      unidad: "litros",
      ubicacion: "Centro Norte",
      centro_id: 1
    }

    IO.inspect(Inventario.registrar(recurso), label: "Registro de recurso")

    IO.inspect(Inventario.listar(), label: "Inventario")

    IO.inspect(
      Inventario.asignar("AG001", 20, 1, "Juan"),
      label: "Asignación de 20 litros"
    )

    IO.inspect(Inventario.listar(), label: "Inventario actualizado")

    IO.inspect(Inventario.movimientos(), label: "Historial de movimientos")
  end

end

PruebaInventario.ejecutar()
