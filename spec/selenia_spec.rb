require 'spec_helper'

RSpec.describe Selenia do
  it "has a version number" do
    expect(Selenia::VERSION).not_to be nil
  end

  describe '.clean_link' do
  	context 'with a lonely URL fragment' do
  		it 'removes the URL fragment' do
  			expect(Selenia.clean_link('https://csusm.edu#')).to eq 'https://csusm.edu'
  		end

  		it 'removes the trailing slash' do
  			expect(Selenia.clean_link('https://csusm.edu/#')).to eq 'https://csusm.edu'
  		end
  	end

  	context 'with a longer URL fragment' do 
  		it 'removes the entire URL fragment' do
  			expect(Selenia.clean_link('https://csusm.edu#url_fragment')).to eq 'https://csusm.edu'
  		end

  		it 'removes the trailing slash' do
  			expect(Selenia.clean_link('https://csusm.edu/#url_fragment')).to eq 'https://csusm.edu'
  		end
  	end

  	context 'without a URL fragment' do
  		it 'leaves the link alone' do
  			expect(Selenia.clean_link('https://csusm.edu')).to eq 'https://csusm.edu'
  		end

  		it 'removes the trailing slash' do
  			expect(Selenia.clean_link('https://csusm.edu/')).to eq 'https://csusm.edu'
  		end
  	end
  end
end
