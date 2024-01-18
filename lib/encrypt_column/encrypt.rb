require 'openssl'

class Encrypt
  def self.text(plaintext, key = ENV.fetch('ENCRYPTION_KEY', nil))
    return raise 'Missing Encryption Key Config' if key.nil?
    ActiveSupport::MessageEncryptor.new(key).encrypt_and_sign(plaintext)
  end

  def self.plaintext(plaintext, key = ENV.fetch('ENCRYPT_KEY', nil))
    return raise 'Missing Encryption Key Config' if key.nil?
    return if plaintext.blank?
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    iv = cipher.random_iv

    cipher.encrypt
    cipher.key = key
    cipher.iv = iv

    enciphered = cipher.update(plaintext)
    enciphered << cipher.final
    [enciphered, iv].map { |part| [part].pack('m').gsub("\n", '') }.join('--')
  end
end
