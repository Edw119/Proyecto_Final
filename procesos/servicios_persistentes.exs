
defmodule ServiciosPersistentes do

  # ==============================
  # USUARIOS
  # ==============================

  def listar_usuarios do
    Persistencia.cargar("usuarios.txt")
  end

  def registrar_usuario(usuario) do
    with {:ok, usuarios} <- listar_usuarios(),
         {:ok, nuevos} <- Usuarios.registrar(usuarios, usuario),
         {:ok, _} <- Persistencia.guardar("usuarios.txt", nuevos) do
      {:ok, nuevos}
    end
  end

  # ==============================
  # ZONAS
  # ==============================

  def listar_zonas do
    Persistencia.cargar("zonas.txt")
  end

  def registrar_zona(zona) do
    with {:ok, zonas} <- listar_zonas(),
         {:ok, nuevas} <- Zonas.registrar(zonas, zona),
         {:ok, _} <- Persistencia.guardar("zonas.txt", nuevas) do
      {:ok, nuevas}
    end
  end

  # ==============================
  # NECESIDADES
  # ==============================

  def listar_necesidades do
    Persistencia.cargar("necesidades.txt")
  end

  def registrar_necesidad(necesidad) do
    with {:ok, necesidades} <- listar_necesidades(),
         {:ok, nuevas} <- Necesidades.registrar(necesidades, necesidad),
         {:ok, _} <- Persistencia.guardar("necesidades.txt", nuevas) do
      {:ok, nuevas}
    end
  end

  # ==============================
  # PERSONAS
  # ==============================

  def listar_personas do
    Persistencia.cargar("personas.txt")
  end

  def guardar_personas(personas) do
    Persistencia.guardar("personas.txt", personas)
  end

  # ==============================
  # MENSAJES
  # ==============================

  def listar_mensajes do
    Persistencia.cargar("mensajes.txt")
  end

  def guardar_mensajes(mensajes) do
    Persistencia.guardar("mensajes.txt", mensajes)
  end

  # ==============================
  # MASCOTAS
  # ==============================

  def listar_mascotas do
    Persistencia.cargar("mascotas.txt")
  end

  def guardar_mascotas(mascotas) do
    Persistencia.guardar("mascotas.txt", mascotas)
  end

end
