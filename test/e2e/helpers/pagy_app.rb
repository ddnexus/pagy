# frozen_string_literal: true

require 'concurrent'
require 'childprocess'
require 'socket'
require_relative '../../../gem/lib/pagy'

class E2eApp
  APPS    = { repro:   { port: 8080 },
              rails:   { port: 8081 },
              keynav:   { port: 8082 },
              demo:     { port: 8083 },
              calendar: { port: 8084 } }.freeze
  PROCESS = Concurrent::Hash.new
  IP      = '127.0.0.1'

  at_exit { stop_all }

  def self.stop_all = PROCESS.each_value { _1&.stop }

  def initialize(id)
    raise ArgumentError, 'Unknown test app id' unless APPS.key?(id)

    @id   = id
    @port = APPS[@id][:port]
    cmd   = %W[ruby -S #{Pagy::ROOT}/bin/pagy #{@id} -p #{@port} -t1:1 -q]

    @process = ChildProcess.build(*cmd)
    @process.environment['E2E_TEST'] = true
    @process.leader = true
  end

  attr_reader :id, :port, :process

  def base_url = "http://#{E2eApp::IP}:#{@port}"

  def start
    @process.start
    PROCESS[@id] = @process
    wait_for_port
  end

  def stop = PROCESS.delete(@id)&.stop

  def wait_for_port
    start = Time.now
    loop do
      TCPSocket.new(IP, @port).close
      break
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      raise "Timeout waiting for #{@id} to start on port #{@port}" if Time.now - start > 10

      sleep 0.2
    end
  end
end
