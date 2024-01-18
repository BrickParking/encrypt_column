require 'spec_helper'
require 'encrypt_column/encrypt'
require 'active_support'

describe Decrypt do
  let(:plaintext) { 'plain text' }
  let(:notext) { '' }
  let(:niltext) { nil }
  let(:good_key) { '94382908324590340958403985098090' }
  let(:wrong_key) { 'xxx9438290832459034095840398509809sdsfkl;' }
  let(:ciphertext) { Encrypt.text(plaintext) }
  let(:ciphernotext) { Encrypt.text(notext) }
  let(:cipherniltext) { Encrypt.text(niltext) }

  context 'correct encryption key config specified' do

    subject { Decrypt.cipher(ciphertext) }

    before do
      ENV['ENCRYPTION_KEY'] = good_key
    end

    it 'returns the correct plaintext value' do
      expect(subject).to eq(plaintext)
    end

    it 'decrypts an empty string' do
      subject = Decrypt.cipher(ciphernotext)
      expect(subject).to eq(notext)
    end

    it 'decrypts a nil string' do
      subject = Decrypt.cipher(cipherniltext)
      expect(subject).to eq(niltext)
    end

    it 'has a blank ciphertext supplied' do
      subject = Decrypt.cipher('')
      expect(subject).to eq(nil)
    end
  end

  context 'wrong encryption key specified' do

    subject { Decrypt.cipher(ciphertext, wrong_key) }

    it 'return a wrong encryption key error' do
      expect(subject).to eq('ERROR: Wrong encryption key specified')
    end

  end
end

