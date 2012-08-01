# encoding: utf-8
#
class Tweets < Gazouillis::Stream
  def on_message(message)
    $listeners.broadcast(message, event: :tweet)
    $redis.incr 'tweets_count'
    $redis.incr 'tweets_total'
  end
end
