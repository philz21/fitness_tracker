# app/services/exercise_db_client.rb
require "net/http"
require "uri"
require "json"
require "openssl"

class ExerciseDbClient
  BASE_URL = "https://exercisedb.p.rapidapi.com".freeze
  HOST     = "exercisedb.p.rapidapi.com".freeze

  def initialize
    @api_key = Rails.application.credentials.dig(:exercisedb, :api_key)
  end

  def search_by_name(name, limit: 12)
    return [] if name.blank?

    path = "/exercises/name/#{URI.encode_www_form_component(name)}"
    uri  = URI("#{BASE_URL}#{path}")
    uri.query = URI.encode_www_form(limit: limit)

    request = Net::HTTP::Get.new(uri)
    request["X-RapidAPI-Key"]  = @api_key
    request["X-RapidAPI-Host"] = HOST

    response = Net::HTTP.start(
      uri.hostname,
      uri.port,
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE # dev only
    ) do |http|
      http.request(request)
    end

    return [] unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("ExerciseDbClient error: #{e.class} - #{e.message}")
    []
  end
end
