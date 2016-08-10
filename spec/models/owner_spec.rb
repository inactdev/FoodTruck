require 'rails_helper'

describe ::Owner do
  context "#new_token" do
    it "creates a new random token" do
      expect(::SecureRandom).to receive(:urlsafe_base64)
      described_class.new_token
    end
  end
end
