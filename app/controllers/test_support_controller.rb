class TestSupportController < ActionController::Base
  protect_from_forgery with: :null_session

  def cleanup
    # wipe whatever tables your tests touch
    Entry.delete_all
    # User.delete_all  etc, if needed

    head :ok
  end
end
