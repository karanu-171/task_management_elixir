defmodule TaskManagement.Response do
  @derive Jason.Encoder
  defstruct message: "", entity: nil, statusCode: 200

  def ok(entity, message \\ "Success") do
    %__MODULE__{message: message, entity: entity, statusCode: 200}
  end

  def created(entity, message \\ "Created") do
    %__MODULE__{message: message, entity: entity, statusCode: 201}
  end

  def error(message, status_code \\ 400) do
    %__MODULE__{message: message, entity: nil, statusCode: status_code}
  end
end
