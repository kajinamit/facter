# frozen_string_literal: true

describe 'Windows Ipaddress6Interfaces' do
  context '#call_the_resolver' do
    let(:interfaces) { { 'eth0' => { ip6: 'fe80::99bf:da20:ad3:9bfe' }, 'en1' => { ip6: 'fe80::99bf:da20:ad3:9bfe' } } }
    subject(:fact) { Facter::Windows::Ipaddress6Interfaces.new }

    before do
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:interfaces).and_return(interfaces)
    end

    it 'calls Facter::Resolvers::Networking' do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:interfaces)
      fact.call_the_resolver
    end

    it 'returns legacy facts with names ipaddress6_<interface_name>' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'ipaddress6_eth0',
                                                    value: interfaces['eth0'][:ip6], type: :legacy),
                        an_object_having_attributes(name: 'ipaddress6_en1',
                                                    value: interfaces['en1'][:ip6], type: :legacy))
    end
  end
end
