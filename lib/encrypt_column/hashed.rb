require 'digest'

class Hashed
  def self.val(plaintext, salt = ENV.fetch('HASH_SALT', nil))
    return nil if plaintext.nil?
    return raise 'Missing Hash Salt Config' if salt.nil?
    Digest::SHA2.hexdigest(salt + plaintext.to_s)
  end
end
