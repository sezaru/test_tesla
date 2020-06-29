defmodule Server do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, :no_args)

  @impl GenServer
  def init(:no_args), do: {:ok, :no_state, {:continue, :sleep}}

  @impl GenServer
  def handle_continue(:sleep, state) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.google.com"}
    ]

    adapter = {Tesla.Adapter.Mint, timeout: :timer.seconds(10)}

    client = Tesla.client(middleware, adapter)

    Tesla.get(client, "/") |> IO.inspect()

    IO.puts("Finished waiting")

    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:some_call, _, state) do
    IO.puts("Called")

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_info({_, :ok}, state), do: {:noreply, state}
  def handle_info({:DOWN, _, :process, _, :normal}, state), do: {:noreply, state}
  def handle_info({:ssl, {:sslsocket, {:gen_tcp, _, :tls_connection, :undefined}, _}, _}, state) do
    {:noreply, state}
  end
end

defmodule TestTesla do
  def run do
    {:ok, pid} = Server.start_link()
    GenServer.call(pid, :some_call, :infinity)
  end
end
