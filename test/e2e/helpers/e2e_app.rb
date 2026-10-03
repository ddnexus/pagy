# frozen_string_literal: true

require 'childprocess'
require 'socket'
require_relative '../../../gem/lib/pagy'

# Each app is started once per test process, on first use, and stopped at exit.
# The tests run in parallel (parallelize_me!), so the app cannot be managed in
# before(:all)/after(:all) hooks: minitest just enqueues the parallel tests, and
# the hooks would run once per test, starting concurrent servers on the same port.
class E2eApp
  APPS    = { repro:    { port: 8080 },
              rails:    { port: 8081 },
              keynav:   { port: 8082 },
              demo:     { port: 8083 },
              calendar: { port: 8084 } }.freeze
  IP      = '127.0.0.1'
  TIMEOUT = 30
  RUNNING = {} # rubocop:disable Style/MutableConstant
  MUTEX   = Mutex.new

  at_exit { stop_all }

  class << self
    # Return the running app, starting it on the first call
    def fetch(id) = MUTEX.synchronize { RUNNING[id] ||= new(id).tap(&:start) }

    def stop_all = RUNNING.each_value(&:stop).clear
  end

  def initialize(id)
    raise ArgumentError, 'Unknown test app id' unless APPS.key?(id)

    @id   = id
    @port = APPS[@id][:port]
    cmd   = %W[ruby -S #{Pagy::ROOT}/bin/pagy #{@id} --host #{IP} --port #{@port} -q]

    @process = ChildProcess.build(*cmd)
    @process.environment['E2E_TEST'] = true
    @process.leader = true
  end

  attr_reader :id, :port, :process

  def base_url = "http://#{IP}:#{@port}"

  def start
    # A server left running by an interrupted run would be silently tested in place of the current code
    raise "Port #{@port} already in use: kill the stale server before running the #{@id.inspect} E2E tests" if port_open?

    @process.start
    wait_for_port
  rescue StandardError
    stop
    raise
  end

  def stop = @process.alive? && @process.stop

  private

  def port_open?
    TCPSocket.new(IP, @port).close
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
    false
  end

  def wait_for_port
    start = Time.now
    until port_open?
      raise "The #{@id.inspect} app exited with code #{@process.exit_code}" if @process.exited?
      raise "Timeout waiting for #{@id.inspect} to start on port #{@port}" if Time.now - start > TIMEOUT

      sleep 0.2
    end
  end
end
