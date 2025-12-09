require "ostruct"
require "net/http"   
require "uri"
require "openssl"        

class ExercisesController < ApplicationController
  def index
    @query = params[:query]
    @results = []

    # If the user clicked "Search" but didn't type anything
    if params[:commit].present? && @query.blank?
      flash.now[:alert] = "Please enter a search term (e.g. bench, squat, row)."
      return
    end

    if @query.present?
      client      = ExerciseDbClient.new
      raw_results = client.search_by_name(@query, limit: 12)

      @results = raw_results.map do |ex|
        OpenStruct.new(
          external_id: ex["id"],
          name:        ex["name"],
          body_part:   ex["bodyPart"],
          target:      ex["target"],
          equipment:   ex["equipment"],
          # For now, rely on the gifUrl field if present
          image_url:   build_image_url(ex)
        )
      end
    else
      @results = []
    end
  end

  def image
    exercise_id = params[:id]
    api_key     = Rails.application.credentials.dig(:exercisedb, :api_key)

    uri = URI("https://exercisedb.p.rapidapi.com/image?exerciseId=#{exercise_id}&resolution=360")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # IMPORTANT: dev-only workaround for SSL issues on macOS
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

    req = Net::HTTP::Get.new(uri)
    req["X-RapidAPI-Key"]  = api_key
    req["X-RapidAPI-Host"] = "exercisedb.p.rapidapi.com"

    res = http.request(req)

    Rails.logger.info "EXERCISE IMAGE STATUS: #{res.code}"
    Rails.logger.info "EXERCISE IMAGE CONTENT-TYPE: #{res['Content-Type']}"

    if res.is_a?(Net::HTTPSuccess) && res["Content-Type"]&.start_with?("image")
      # Stream the image bytes back to the browser
      send_data res.body,
                type:        res["Content-Type"],
                disposition: "inline"
    else
      # Show a helpful message if RapidAPI returns an error / JSON
      render plain: "status=#{res.code}, content_type=#{res['Content-Type']}, body_start=#{res.body[0,200]}",
            status: :bad_gateway
    end
  end



  private

  def build_image_url(ex)
   exercise_image_path(ex["id"])

  end
end

