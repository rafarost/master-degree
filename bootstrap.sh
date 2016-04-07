RUBY_VERSION_NUMBER=2.1.5
RUBY_VERSION=ruby-${RUBY_VERSION_NUMBER}
RVM_PATH=/usr/local/rvm
GEM_HOME=${RVM_PATH}/gems/${RUBY_VERSION}
GEM_PATH=${GEM_HOME}
ENV_PATH=${GEM_PATH}/bin:${RVM_PATH}/rubies/ruby-2.1.5/bin:${RVM_PATH}/bin:${PATH}

# Set /etc/environment
sudo sh -c "echo '# /etc/environment: Default environment specific pam module configuration file.' > /etc/environment"
sudo sh -c "echo '# See: /etc/security/pam_env.conf' >> /etc/environment"
sudo sh -c "echo '' >> /etc/environment"
sudo sh -c "echo 'PATH=\"${ENV_PATH}\"' >> /etc/environment"
sudo sh -c "echo '' >> /etc/environment"
sudo sh -c "echo 'RUBY_VERSION=\"${RUBY_VERSION}\"' >> /etc/environment"
sudo sh -c "echo 'RVM_PATH=\"${RVM_PATH}\"' >> /etc/environment"
sudo sh -c "echo 'GEM_HOME=\"${GEM_HOME}\"' >> /etc/environment"
sudo sh -c "echo 'GEM_PATH=\"${GEM_PATH}\"' >> /etc/environment"
sudo sh -c "echo '' >> /etc/environment"

sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
sudo bash -l -c "curl --retry 10 --retry-delay 10 --silent --show-error --location https://get.rvm.io | \
  bash -s stable --ruby=${RUBY_VERSION_NUMBER}"

sudo bash -l -c "rvm use --default ${RUBY_VERSION}"
sudo usermod $(whoami) -G rvm


cat > $HOME/.gemrc << EOL
---
:backtrace: false
:bulk_threshold: 1000
:sources:
- https://rubygems.org/
:update_sources: true
:verbose: true
gem:  --no-ri --no-rdoc
EOL

sudo bash -l -c 'gem install --version 1.10.6 bundler'
