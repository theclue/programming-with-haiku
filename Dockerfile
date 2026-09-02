FROM ivotron/pandoc
ENV TZ="Europe/Rome"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    tzdata calibre python3 python3-pip texlive-fonts-extra texlive-xetex \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && pip3 install --no-cache-dir pandoc-latex-environment \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

WORKDIR /app
COPY . .

ENTRYPOINT []
CMD ["make", "all"]
