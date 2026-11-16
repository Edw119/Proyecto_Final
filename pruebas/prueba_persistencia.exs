defmodule PruebaPersistencia do

  def ejecutar do
    IO.puts("\n===== PRUEBA DE PERSISTENCIA =====")

    usuario = %Usuario{
      id: 1,
      nombre: "Juan",
      correo: "juan@gmail.com",
      contrasena: "12345",
      rol: :ciudadano,
      zona_id: 1
    }

    resultado = ServiciosPersistentes.registrar_usuario(usuario)

    IO.inspect(resultado, label: "Registro")

    IO.inspect(
      ServiciosPersistentes.listar_usuarios(),
      label: "Usuarios guardados"
    )
  end

end

PruebaPersistencia.ejecutar()
