# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative 'base_resource'

module IloCookbook
  ## Class for iLO HTTPS Certificate Actions
  class HTTPSCert < BaseResource
    resource_name :ilo_https_cert

    property :ilo, Hash
    property :certificate, String
    property :file_path, String
    property :country, String
    property :state, String
    property :city, String
    property :orgName, String
    property :orgUnit, String
    property :commonName, String

    action :import do
      load_sdk
      raise 'Please provide certificate or file_path!' unless certificate || file_path
      warn 'WARNING: Both certificate and file_path provided. Defaulting to certificate.' if certificate && file_path
      client = build_client(ilo)
      cur_certificate = client.get_certificate.to_s
      if certificate
        next if cur_certificate.gsub(/\s+/, '') == certificate.gsub(/\s+/, '')
        converge_by 'Importing new certificate' do
          client.import_certificate(certificate)
        end
      elsif file
        cert = ::File.open(file_path).read
        next if cur_certificate.gsub(/\s+/, '') == cert.gsub(/\s+/, '')
        converge_by "Importing new certificate from '#{file_path}'" do
          client.import_certificate(cert)
        end
      end
    end

    action :generate_csr do
      load_sdk
      client = build_client(ilo)
      converge_by 'Generating CSR' do
        client.generate_csr(country, state, city, orgName, orgUnit, commonName)
      end
    end

    action :dump_csr do
      load_sdk
      client = build_client(ilo)
      converge_by "Returning CSR and placing it in '#{file_path}'" do
        csr = client.get_csr
        file file_path do
          content csr
        end
      end
    end
  end
end
