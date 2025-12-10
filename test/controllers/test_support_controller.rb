class TestSupportController < ApplicationController
  skip_before_action :verify_authenticity_token

  def cleanup
    Entry.delete_all
    head :ok
  end
end
