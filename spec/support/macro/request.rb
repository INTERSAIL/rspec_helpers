module RequestMacros
  def parseResponse
    @json ||= JSON(response.body, symbolize_names: true)
  end
end