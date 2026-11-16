
defmodule Auditoria do
  use GenServer

  def start_link(_opciones) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_estado) do
    case Persistencia.cargar("auditoria.txt") do
      {:ok, registros} when is_list(registros) ->
        {:ok, registros}

      {:ok, _} ->
        {:ok, []}

      {:error, mensaje} ->
        {:stop, mensaje}
    end
  end

  # FUNCIONES PUBLICAS

  def registrar(usuario, accion, descripcion) do
    GenServer.call(__MODULE__, {:registrar, usuario, accion, descripcion})
  end

  def listar do
    GenServer.call(__MODULE__, :listar)
  end

  def buscar_usuario(usuario) do
    GenServer.call(__MODULE__, {:buscar_usuario, usuario})
  end

  # FUNCIONES DEL SERVIDOR

  def handle_call({:registrar, usuario, accion, descripcion}, _from, registros) do
    registro = %{
      id: System.unique_integer([:positive]),
      usuario: usuario,
      accion: accion,
      descripcion: descripcion,
      fecha: DateTime.utc_now()
    }

    nuevos = [registro | registros]

    case Persistencia.guardar("auditoria.txt", nuevos) do
      {:ok, _mensaje} ->
        {:reply, {:ok, registro}, nuevos}

      {:error, mensaje} ->
        {:reply, {:error, mensaje}, registros}
    end
  end

  def handle_call(:listar, _from, registros) do
    {:reply, registros, registros}
  end

  def handle_call({:buscar_usuario, usuario}, _from, registros) do
    encontrados =
      Enum.filter(registros, fn registro ->
        registro.usuario == usuario
      end)

    {:reply, encontrados, registros}
  end
end
