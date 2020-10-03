FROM ubuntu:18.04


# In China, replace the url between the 2nd and 3rd '@' with these lines
# Usage: sed -i "s@replace_this@by_that@g"

#http://mirrors.tuna.tsinghua.edu.cn
#http://mirrors.tuna.tsinghua.edu.cn
#http://mirrors.tuna.tsinghua.edu.cn
RUN sed -i "s@http://security.ubuntu.com@http://security.ubuntu.com@g" /etc/apt/sources.list && \
    sed -i "s@http://deb.ubuntu.com@http://deb.ubuntu.com@g" /etc/apt/sources.list && \
    sed -i "s@http://archive.ubuntu.com@http://archive.ubuntu.com@g" /etc/apt/sources.list && \
    rm -Rf /var/lib/apt/lists/* && apt-get update

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ Europe/Amsterdam 

RUN apt-get upgrade -y && apt-get dist-upgrade
RUN apt-get install -qq -y apt-transport-https libffi-dev libxml2 \
    tklib zlib1g-dev libssl-dev curl wget gnupg2 rbenv ruby-build ca-certificates

# require gnupg2
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# require curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# for ubuntu 18.04 use libgdbm4 libgdbm-dev
RUN apt-get install -y yarn git tzdata apt-utils zsh nodejs npm vim \
    imagemagick jq build-essential \
    libxml2-dev libxslt1-dev libreadline-dev ruby-all-dev \
    autoconf bison libyaml-dev libreadline6-dev libncurses5-dev  sudo lsb-release

RUN mkdir /app

WORKDIR /app

RUN addgroup --system user --gid 1000 && adduser --uid 1000 --system --group  user
RUN echo "user:user" | chpasswd && adduser user sudo

RUN chown -R user:user /app && chmod -R 755 /app
#RUN cat /root/.ssh/id_ed25519.pub
#RUN chown -R root:root /root/.ssh && chmod -R 400 /root/.ssh

# Install Zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Config git
RUN git config --global user.email "benoit.mrejen@gmail.com" && git config --global user.name "Benoit Mrejen"

# rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.zshrc
RUN exec $SHELL

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.zshrc
RUN exec $SHELL

RUN git clone https://github.com/tpope/rbenv-aliases.git ~/.rbenv/plugins/rbenv-aliases
RUN rbenv alias --auto
RUN git clone https://github.com/rbenv/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
# RUN rbenv install 2.7.1 && rbenv global 2.7.1

# If in China:
# RUN gem sources --remove https://rubygems.org/ && gem sources -a https://gems.ruby-china.com/

# gems
RUN gem install rake bundler rspec rubocop rubocop-performance pry hub colored octokit pry-byebug 

# PostgreSQL
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
#RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
#RUN apt-get update -y && apt-get install -y postgresql postgresql-contrib

ENV DEBIAN_FRONTEND teletype
COPY robbyrussell.zsh-theme /root/.oh-my-zsh/themes
CMD /bin/zsh