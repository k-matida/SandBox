#!/usr/bin/env jruby
require 'logtablemapper'

describe 'LogTableMapper' do
  context 'when any state' do
    before do
      @exist_file_name = 'database.yml'
      @not_exist_file_name = 'aaa.iii'
    end

    describe 'LogTableMapper#connect' do
      context 'with existing configfilename,' do
        subject { lambda{LogTableMapper.new.connect(@exist_file_name) }}
        it { should_not raise_error }
      end

      context 'with not existing configfilename,' do
        subject { lambda{LogTableMapper.new.connect(@not_exist_file_name) }}
        it { should raise_error Errno::ENOENT }
      end
    end
  end
end
