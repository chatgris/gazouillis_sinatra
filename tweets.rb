# encoding: utf-8
#
class Tweets < Gazouillis::Stream
  def on_message(message)
    $listeners.broadcast(message, event: :tweet)
  end
end
