# encoding: utf-8
class MessageFormatter
  def initialize(message, options)
    @message = message
    @event = options[:event]
    @out = []
  end

  def to_s
    @out << "event:#{@event}" if @event
    @out << format(:data, @message)
    @out.join("\n")
  end

  private

  def format(key, value)
    "#{key}: #{value}\n\n"
  end
end

class Connections
  include Enumerable

  def initialize
    @connections = {}
  end

  def []=(id, connection)
    # Set on_close callback
    connection.callback { leave(id)}
    @connections[id] = connection
  end

  def [](id)
    @connections[id]
  end

  def each(&block)
    @connections.values.each &block
  end

  def leave(id)
    @connections.delete id
  end

  def join(connection)
    self[@connections.size] = connection
  end

  def broadcast(message, options = {})
    each {|connection| connection << MessageFormatter.new(message, options).to_s }
  end

end
