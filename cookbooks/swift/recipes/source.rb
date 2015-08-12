# Copyright (c) 2015 SwiftStack, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# python install

execute "git python-swiftclient" do
  cwd "/vagrant"
  command "git clone -b #{node['swiftclient_repo_branch']} #{node['swiftclient_repo']}"
  creates "/vagrant/python-swiftclient"
  action :run
end

execute "git swift-bench" do
  cwd "/vagrant"
  command "git clone -b #{node['swift_bench_repo_branch']} #{node['swift_bench_repo']}"
  creates "/vagrant/swift-bench"
  action :run
end

execute "git swift" do
  cwd "/vagrant"
  command "git clone -b #{node['swift_repo_branch']} #{node['swift_repo']}"
  creates "/vagrant/swift"
  action :run
end

execute "git swift-specs" do
  cwd "/vagrant"
  command "git clone -b #{node['swift_specs_repo_branch']} #{node['swift_specs_repo']}"
  creates "/vagrant/swift-specs"
  action :run
end

execute "fix semantic_version error from testtools" do
  command "pip install --upgrade testtools"
end

execute "python-swiftclient-install" do
  cwd "/vagrant/python-swiftclient"
  command "pip install -e . && pip install -r test-requirements.txt"
  if not node['full_reprovision']
    creates "/usr/local/lib/python2.7/dist-packages/python-swiftclient.egg-link"
  end
  action :run
end

execute "swift-bench-install" do
  cwd "/vagrant/swift-bench"
  command "pip install -e . && pip install -r test-requirements.txt"
  if not node['full_reprovision']
    creates "/usr/local/lib/python2.7/dist-packages/swift-bench.egg-link"
  end
  action :run
end

execute "python-swift-install" do
  cwd "/vagrant/swift"
  command "pip install -e . && pip install -r test-requirements.txt"
  if not node['full_reprovision']
    creates "/usr/local/lib/python2.7/dist-packages/swift.egg-link"
  end
  action :run
end

execute "swift-specs-install" do
  cwd "/vagrant/swift-specs"
  command "pip install -r requirements.txt"
  action :run
end

execute "install tox" do
  command "pip install tox"
  if not node['full_reprovision']
    creates "/usr/local/lib/python2.7/dist-packages/tox"
  end
  action :run
end

[
  'swift',
  'python-swiftclient',
].each do |dirname|
  execute "ln #{dirname}" do
    command "ln -s /vagrant/#{dirname} /home/vagrant/#{dirname}"
    creates "/home/vagrant/#{dirname}"
  end
end

go_tar_ball = "go1.4.2.linux-amd64.tar.gz"

execute "download go" do
  cwd "/usr/local/"
  command "wget https://storage.googleapis.com/golang/#{go_tar_ball}"
  creates "/usr/local/#{go_tar_ball}"
end

execute "inflate go" do
  cwd "/usr/local/"
  command "tar zxvf #{go_tar_ball}"
  if not node['full_reprovision']
    creates "/usr/local/go"
  end
end

execute "install go" do
  command "ln -s /usr/local/go/bin/* /usr/local/bin || true"
end
