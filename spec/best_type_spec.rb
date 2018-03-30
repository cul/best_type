require 'spec_helper'

describe BestType do

  it "should be a module" do
    expect(BestType).to be_a Module
  end

  describe "::version" do
    it "should return the version" do
      expect(BestType::version).to eq(subject::VERSION)
    end
  end

end
