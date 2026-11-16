defmodule Usuarios do

  def registrar(usuarios, usuario) do
    existe = Enum.any?(usuarios, fn u -> u.id == usuario.id or u.correo == usuario.correo end)

    if existe do
      {:error, "El usuario o correo ya existe."}
    else
      {:ok, [usuario | usuarios]}
    end
  end

  def autenticar(usuarios, correo, contrasena) do
    usuario = Enum.find(usuarios, fn u ->
      u.correo == correo and u.contrasena == contrasena
    end)

    if usuario == nil do
      {:error, "Correo o contraseña incorrectos."}
    else
      usuario_actualizado = %{usuario | conectado: true}
      nuevos = Enum.map(usuarios, fn u ->
        if u.id == usuario.id, do: usuario_actualizado, else: u
      end)

      {:ok, usuario_actualizado, nuevos}
    end
  end

  def desconectar(usuarios, id) do
    existe = Enum.any?(usuarios, fn u -> u.id == id end)

    if existe do
      nuevos = Enum.map(usuarios, fn u ->
        if u.id == id, do: %{u | conectado: false}, else: u
      end)

      {:ok, nuevos}
    else
      {:error, "Usuario no encontrado."}
    end
  end

  def buscar(usuarios, id) do
    Enum.find(usuarios, fn u -> u.id == id end)
  end

  def listar(usuarios) do
    usuarios
  end

end
