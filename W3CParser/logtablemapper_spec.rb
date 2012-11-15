require 'logtablemapper'

describe 'LogTableMapper' do
  context 'when any state,' do
    before do
      @exist_file_name = 'database.yml'
      @not_exist_file_name = 'aaa.iii'
    end

    describe 'LogTableMapper#connect' do
      context 'with existing configfilename,' do
        subject { LogTableMapper.new }
        it 'success connect to database' do
          subject.connect(@exist_file_name).should_not raise_error
        end
      end
    end

    describe 'LogTableMapper#connect' do
      context 'with not existing configfilename,' do
        subject { LogTableMapper.new }
        it 'raise error' do
          lambda { subject.connect(@not_exist_file_name) }.should raise_error Errno::ENOENT 
        end
      end
    end
  end
end
