require 'openssl'
class Decrypt
  def self.cipher(ciphertext, key = ENV.fetch('ENCRYPTION_KEY', nil))
    raise 'Encryption Key Config Missing' unless key.present?
    ActiveSupport::MessageEncryptor.new(key).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return if ciphertext.blank?
    return 'ERROR: Wrong encryption key specified'
  end

  def self.ciphertext(ciphertext, key = ENV.fetch('ENCRYPT_KEY', nil))
    raise 'Encryption Key Config Missing' unless key.present?
    return if ciphertext.blank?
    enciphered, iv = ciphertext.split('--', 2).map { |part| part.unpack('m')[0] }
    decipher = OpenSSL::Cipher::AES256.new(:CBC)

    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    deciphered = decipher.update(enciphered)
    deciphered << decipher.final
  end
end
