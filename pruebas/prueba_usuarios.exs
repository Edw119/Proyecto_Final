defmodule PruebaUsuarios do

  def ejecutar do
    IO.puts("\n===== PRUEBAS DE USUARIOS =====")

    usuarios = []

    usuario = %Usuario{
      id: 1,
      nombre: "Juan",
      correo: "juan@gmail.com",
      contrasena: "12345",
      rol: :ciudadano,
      zona_id: 1
    }

    resultado = Usuarios.registrar(usuarios, usuario)

    IO.inspect(resultado, label: "Registro de usuario")

    case resultado do
      {:ok, lista} ->
        IO.inspect(Usuarios.listar(lista), label: "Lista de usuarios")
        IO.inspect(Usuarios.autenticar(lista, "juan@gmail.com", "12345"),
          label: "Autenticación")

      {:error, mensaje} ->
        IO.puts(mensaje)
    end
  end

end

PruebaUsuarios.ejecutar()
