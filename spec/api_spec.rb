require 'spec_helper'

describe RiotApi::API, :vcr do
  subject { ra = RiotApi::API.new :api_key => api_key, :region => 'euw' }
  let(:api_key)   { API_KEY }

  describe '.new' do
    it 'should return an instance when called with the essential parameters' do
      client = RiotApi::API.new :api_key => api_key, :region => 'euw'
      client.should be_instance_of(RiotApi::API)
    end
  end

  describe 'ssl settings' do
    it 'should by default enforce ssl' do
      subject.default_faraday.ssl.should == { :verify => true }
    end
  end

  describe '#summoner' do
    let(:summoner_name) { 'BestLuxEUW' }

    describe '#name' do
      let(:response) {
        subject.summoner.name summoner_name
      }

      it 'should return information from the summoner name' do
        response.id.should eql(44600324)
        response.name.should eql("Best Lux EUW")
        response.profile_icon_id.should eql(7)
        response.revision_date.should eql(1375116256000)
        response.revision_date_str.should eql('07/29/2013 04:44 PM UTC')
        response.summoner_level.should eql(6)
      end
    end

  end

  describe '#stats' do
    let(:summoner_id) { '19531813' }

    # Ranked command requires user has played ranked
    describe '#ranked' do
      let(:response) {
        subject.stats.ranked summoner_id
      }

      it 'should return ranked information from the summoner name' do
        response.summonerId.should eql(19531813)
        response.champions.first.first.should eql ["id", 111]
      end
    end

    describe '#summary' do
      let(:response) {
        subject.stats.summary summoner_id
      }

      it 'should return summary information from the summoner id' do
        response.summonerId.should eql(19531813)
        response.playerStatSummaries.first.should include 'aggregated_stats'
      end
    end

  end
end
