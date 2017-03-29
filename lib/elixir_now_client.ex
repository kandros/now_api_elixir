defmodule Now do
  use Tesla

  @moduledoc """
  Documentation for Now.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Now.hello
      :world

  """

  plug Tesla.Middleware.BaseUrl, "https://api.zeit.co"
  plug Tesla.Middleware.Headers, %{"Authorization" => "Bearer #{get_token}", "Accept" => "application/json"}

  def get_deployments do
    get("/now/deployments")
      |> parse_response
      |> Map.get("deployments")
  end

  def get_deployment(id)do
    get("/now/deployments/" <> id)
      |> parse_response
  end

  def delete_deployment(id) do
    delete("/now/deployments/" <> id)
      |> parse_response
  end

  #  POST /now/deployments

  def get_files(id) do
    get("/now/deployments/" <> id <> "/files")
      |> parse_response
  end

  def get_file(id, file_id) do
    get("/now/deployments/#{id}/files/#{file_id}")
      |> parse_response
  end

  def get_domains() do
    get("/domains/")
      |> parse_response
      |> Map.get("domains")
  end

  #  POST /domains

  def delete_domain(name) do
    delete("/domains/" <> name)
      |> parse_response
  end

  def get_domain_records(name) do
    get("/domains/#{name}/records")
      |> parse_response
  end

  # POST /domains/:domain/records

  def delete_domain_record(name, recordId) do
    delete("/domains/#{name}/records/#{recordId}")
      |> parse_response
  end

  def get_certificates(name) do
    get("/now/certs/#{name}")
      |> parse_response
  end

  # POST /now/certs

  # PUT /now/certs

  def delete_certificate(name) do
    delete("/now/certs/#{name}")
      |> parse_response
  end

  def get_aliases() do
    get("/now/aliases")
      |> parse_response
  end

  def get_aliases(id) do
    get("/now/deployments/#{id}/aliases")
      |> parse_response
  end

  def delete_alias(id) do
    delete("/now/aliases/#{id}")
      |> parse_response
  end

  # POST /now/deployments/:id/aliases

  def get_secrets do
    get("/now/secrets")
      |> parse_response
  end

  # POST /now/secrets

  # PATCH /now/secrets/:uidOrName

  def delete_secret(secret) do
    delete("/now/secrets/#{secret}")
      |> parse_response
  end

  # https://zeit.co/api#faq

  ####

  defp parse_response(res) do
      res.body
      |> Poison.decode
      |> elem(1)
  end

  defp get_token do
    System.get_env "NOW_TOKEN"

    # handle unhappy path
  end

end
