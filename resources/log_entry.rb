actions :clear, :dump

property :ilos, Array, :required => true
property :log_type, String, :required => true, :equal_to => ["IEL", "IML"]
property :severity_level, String, :equal_to => ["OK","Warning","Critical"]
property :dump_file, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']
property :duration, Integer, :default => 24

include IloHelper

action :clear do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    next if client.logs_empty?(log_type)
    converge_by "Clear ilo #{client.host} #{log_type} logs" do
      client.clear_logs(log_type)
    end
  end
end

action :dump do
  load_sdk(self)
  dumpContent = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    dumpContent[host.to_s] = client.get_logs(severity_level, duration, log_type).to_yaml
  end
  file dump_file do
    owner owner
    group group
    content dumpContent.to_yaml
  end
end