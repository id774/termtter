# -*- coding: utf-8 -*-
require 'digest/md5'
require 'base64'

config.plugins.md5pass.set_default(:salt, 'salt')
config.plugins.md5pass.set_default(:len, 12)
config.plugins.md5pass.set_default(:times, 10)

module Termtter::Client

  def self.gen_pass(master_pass)
      salt = config.plugins.md5pass.salt
      len = config.plugins.md5pass.len
      times = config.plugins.md5pass.times
      url = "http://#{config.host}/"
      user = config.user_name
      str = (url + salt + user + master_pass) * (2 ** times);
      Base64.encode64(Digest::MD5.digest(str))[0, len]
  end

  hl = create_highline
  mp = hl.ask('your master password for md5pass: ') { |q| q.echo = false }
  config.password = gen_pass(mp)

  register_command(
    :name => :show_md5pass,
    :exec_proc => lambda {|arg| puts "=> #{gen_pass(arg)}" },
    :help => ["show_md5pass MASTER_PASSWORD", "Show your md5 password."]
  )

end

# config example:
#   config.system.load_plugins = 'md5pass'
#   config.plugins.md5pass.salt = 'set_random_string'
#
# 1. Decide your master password and salt.
# 2. Configure. (see above setting)
# 3. Start termtter.
# 4. Check your generated password using 'show_md5pass MASTER_PASSWORD'
# 5. Change your Twitter password to it.
# 6. Restart termtter.
