# We use the 99_ in the name of this initializer to make sure it goes AFTER
# the users initializer for Strikeiron where we get credentials


HTTPI.log       = true
HTTPI.logger    = Rails.logger  # change the logger
HTTPI.log_level = :debug     # change the log level
