require 'spec_helper'

describe CarrierWave::Uploader::Base do
  let(:uploader) { CarrierWave::Uploader::Base }

  it 'inserts aws as a known storage engine' do
    uploader.configure do |config|
      expect(config.storage_engines).to have_key(:aws)
    end
  end

  it 'defines aws specific storage options' do
    expect(uploader).to respond_to(:aws_attributes)
  end

  describe '#aws_acl' do
    it 'allows known acess control values' do
      expect {
        uploader.aws_acl = 'private'
        uploader.aws_acl = 'public-read'
        uploader.aws_acl = 'authenticated-read'
      }.not_to raise_exception
    end

    it 'does not allow unknown control values' do
      expect {
        uploader.aws_acl = 'everybody'
      }.to raise_exception CarrierWave::Uploader::Base::ConfigurationError
    end

    it 'normalizes the set value' do
      uploader.aws_acl = :'public-read'
      expect(uploader.aws_acl).to eq('public-read')

      uploader.aws_acl = 'PUBLIC_READ'
      expect(uploader.aws_acl).to eq('public-read')
    end

    it 'can be overridden on an instance level' do
      instance = uploader.new

      uploader.aws_acl = 'private'
      instance.aws_acl = 'public-read'

      expect(uploader.aws_acl).to eq('private')
      expect(instance.aws_acl).to eq('public-read')
    end
  end

  describe '#aws_signer' do
    it 'allows proper signer object' do
      signer_proc = -> (unsigned_url, options) { }

      expect { uploader.aws_signer = signer_proc }.not_to raise_exception
    end

    it 'does not allow signer with unknown api' do
      signer_proc = -> (unsigned_url) { }

      expect { uploader.aws_signer = signer_proc }.to raise_exception CarrierWave::Uploader::Base::ConfigurationError
    end
  end
end
